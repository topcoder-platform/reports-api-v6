"""Run real PostgreSQL regressions with STATISTICS_PSQL_COMMAND set to a psql command.

Example: STATISTICS_PSQL_COMMAND='docker exec -i statistics-query-tests psql -U postgres'
python3 -m unittest discover -s test/statistics
Uses transactional, uniquely named fixture schemas; no application tables are changed.
"""
import os
from pathlib import Path
import shlex
import subprocess
import unittest
import uuid


@unittest.skipUnless(os.environ.get('STATISTICS_PSQL_COMMAND'), 'PostgreSQL command not configured')
class FirstSubmittersTest(unittest.TestCase):
    def test_reports_ignore_non_member_identifiers_without_losing_first_submission_semantics(self):
        root = Path(__file__).resolve().parents[2]
        for track, abbreviation in [('design', 'DS'), ('development', 'Dev')]:
            with self.subTest(track=track):
                suffix = uuid.uuid4().hex
                schemas = {name: f'stats_test_{name}_{suffix}' for name in ['members', 'reviews', 'challenges']}
                query = (root / f'sql/reports/statistics/{track}/first-time-{track}-submitters.sql').read_text()
                sql = '''BEGIN;
CREATE SCHEMA members;
CREATE SCHEMA reviews;
CREATE SCHEMA challenges;
CREATE TABLE members.member ("userId" bigint, handle text);
CREATE TABLE members."memberMaxRating" ("userId" bigint, rating int);
CREATE TABLE challenges."ChallengeTrack" (id text, abbreviation text);
CREATE TABLE challenges."Challenge" (id text, name text, "trackId" text);
CREATE TABLE reviews.submission ("memberId" text, "challengeId" text, "submittedDate" timestamptz);
INSERT INTO members.member VALUES (101, 'new-member'), (102, 'returning-member'), (103, 'no-rating');
INSERT INTO members."memberMaxRating" VALUES (101, 1000), (101, 1500);
INSERT INTO challenges."ChallengeTrack" VALUES ('track', 'TRACK_ABBREVIATION');
INSERT INTO challenges."Challenge" VALUES ('first', 'First challenge', 'track'), ('second', 'Second challenge', 'track');
INSERT INTO reviews.submission VALUES
 ('101', 'first', now() - interval '2 days'), ('101', 'second', now() - interval '1 day'),
 ('102', 'first', now() - interval '1 year'), ('102', 'second', now() - interval '1 day'),
 ('103', 'first', now() - interval '1 day'),
 ('service-account@clients', 'first', now()), ('', 'first', now()),
 ('9223372036854775808', 'first', now()), ('999999999999999999999999999', 'first', now()),
 (NULL, 'first', now());
CREATE TEMP TABLE actual AS
QUERY
DO $$ BEGIN
  IF (SELECT count(*) FROM actual) <> 2 THEN RAISE EXCEPTION 'Expected two real first-time members'; END IF;
  IF NOT EXISTS (SELECT FROM actual WHERE "user.handle" = 'new-member'
    AND "challenge.challenge_name" = 'First challenge' AND "submitter_profile.max_rating" = 1500)
    THEN RAISE EXCEPTION 'Lost earliest submission or highest rating'; END IF;
  IF NOT EXISTS (SELECT FROM actual WHERE "user.handle" = 'no-rating' AND "submitter_profile.max_rating" IS NULL)
    THEN RAISE EXCEPTION 'Lost unrated member'; END IF;
END $$;
ROLLBACK;
'''.replace('TRACK_ABBREVIATION', abbreviation).replace('QUERY', query)
                for name, replacement in schemas.items():
                    sql = sql.replace(f'CREATE SCHEMA {name};', f'CREATE SCHEMA {replacement};')
                    sql = sql.replace(name + '.', replacement + '.')
                result = subprocess.run(shlex.split(os.environ['STATISTICS_PSQL_COMMAND']) + ['-X', '-v', 'ON_ERROR_STOP=1'],
                                        input=sql, text=True, capture_output=True)
                self.assertEqual(0, result.returncode, result.stderr)
