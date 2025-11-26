--
-- PostgreSQL database dump
--

\restrict Aamsb0w6QlUnTHU724QaKOrqwzyz9pVhXQENKuxshNefvZ1e3SmtbIPHI8uc1NG

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.6 (Ubuntu 17.6-0ubuntu0.25.04.1)

-- Started on 2025-11-25 11:41:49 AEDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 11 (class 2615 OID 1362914)
-- Name: academy; Type: SCHEMA; Schema: -; Owner: academy
--

CREATE SCHEMA academy;


ALTER SCHEMA academy OWNER TO academy;

--
-- TOC entry 12 (class 2615 OID 2030550)
-- Name: autopilot; Type: SCHEMA; Schema: -; Owner: autopilot
--

CREATE SCHEMA autopilot;


ALTER SCHEMA autopilot OWNER TO autopilot;

--
-- TOC entry 13 (class 2615 OID 2069891)
-- Name: billing-accounts; Type: SCHEMA; Schema: -; Owner: billingaccounts
--

CREATE SCHEMA "billing-accounts";


ALTER SCHEMA "billing-accounts" OWNER TO billingaccounts;

--
-- TOC entry 14 (class 2615 OID 2004827)
-- Name: challenges; Type: SCHEMA; Schema: -; Owner: challenges
--

CREATE SCHEMA challenges;


ALTER SCHEMA challenges OWNER TO challenges;

--
-- TOC entry 15 (class 2615 OID 1363874)
-- Name: emails; Type: SCHEMA; Schema: -; Owner: emails
--

CREATE SCHEMA emails;


ALTER SCHEMA emails OWNER TO emails;

--
-- TOC entry 7708 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA emails; Type: COMMENT; Schema: -; Owner: emails
--

COMMENT ON SCHEMA emails IS 'TC Email Service';


--
-- TOC entry 16 (class 2615 OID 1320061)
-- Name: finance; Type: SCHEMA; Schema: -; Owner: finance
--

CREATE SCHEMA finance;


ALTER SCHEMA finance OWNER TO finance;

--
-- TOC entry 17 (class 2615 OID 1347860)
-- Name: gamification; Type: SCHEMA; Schema: -; Owner: gamification
--

CREATE SCHEMA gamification;


ALTER SCHEMA gamification OWNER TO gamification;

--
-- TOC entry 18 (class 2615 OID 2070261)
-- Name: groups; Type: SCHEMA; Schema: -; Owner: groups
--

CREATE SCHEMA groups;


ALTER SCHEMA groups OWNER TO groups;

--
-- TOC entry 19 (class 2615 OID 1831862)
-- Name: identity; Type: SCHEMA; Schema: -; Owner: identity
--

CREATE SCHEMA identity;


ALTER SCHEMA identity OWNER TO identity;

--
-- TOC entry 20 (class 2615 OID 1825257)
-- Name: lookups; Type: SCHEMA; Schema: -; Owner: lookups
--

CREATE SCHEMA lookups;


ALTER SCHEMA lookups OWNER TO lookups;

--
-- TOC entry 21 (class 2615 OID 2023503)
-- Name: members; Type: SCHEMA; Schema: -; Owner: members
--

CREATE SCHEMA members;


ALTER SCHEMA members OWNER TO members;

--
-- TOC entry 22 (class 2615 OID 1348134)
-- Name: messages; Type: SCHEMA; Schema: -; Owner: messages
--

CREATE SCHEMA messages;


ALTER SCHEMA messages OWNER TO messages;

--
-- TOC entry 23 (class 2615 OID 1436568)
-- Name: notifications; Type: SCHEMA; Schema: -; Owner: notifications
--

CREATE SCHEMA notifications;


ALTER SCHEMA notifications OWNER TO notifications;

--
-- TOC entry 7717 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA notifications; Type: COMMENT; Schema: -; Owner: notifications
--

COMMENT ON SCHEMA notifications IS 'TC Notifications Service';


--
-- TOC entry 24 (class 2615 OID 2200)
-- Name: projects; Type: SCHEMA; Schema: -; Owner: projects
--

CREATE SCHEMA projects;


ALTER SCHEMA projects OWNER TO projects;

--
-- TOC entry 7719 (class 0 OID 0)
-- Dependencies: 24
-- Name: SCHEMA projects; Type: COMMENT; Schema: -; Owner: projects
--

COMMENT ON SCHEMA projects IS 'TC Projects Service DB';


--
-- TOC entry 10 (class 2615 OID 2063642)
-- Name: public; Type: SCHEMA; Schema: -; Owner: topcoder
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO topcoder;

--
-- TOC entry 7721 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: topcoder
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 25 (class 2615 OID 1825030)
-- Name: resources; Type: SCHEMA; Schema: -; Owner: resources
--

CREATE SCHEMA resources;


ALTER SCHEMA resources OWNER TO resources;

--
-- TOC entry 26 (class 2615 OID 2033636)
-- Name: reviews; Type: SCHEMA; Schema: -; Owner: reviews
--

CREATE SCHEMA reviews;


ALTER SCHEMA reviews OWNER TO reviews;

--
-- TOC entry 27 (class 2615 OID 1476988)
-- Name: skills; Type: SCHEMA; Schema: -; Owner: skills
--

CREATE SCHEMA skills;


ALTER SCHEMA skills OWNER TO skills;

--
-- TOC entry 7725 (class 0 OID 0)
-- Dependencies: 27
-- Name: SCHEMA skills; Type: COMMENT; Schema: -; Owner: skills
--

COMMENT ON SCHEMA skills IS 'Standardized Skills Schema';


--
-- TOC entry 28 (class 2615 OID 1475405)
-- Name: taas; Type: SCHEMA; Schema: -; Owner: taas
--

CREATE SCHEMA taas;


ALTER SCHEMA taas OWNER TO taas;

--
-- TOC entry 7727 (class 0 OID 0)
-- Dependencies: 28
-- Name: SCHEMA taas; Type: COMMENT; Schema: -; Owner: taas
--

COMMENT ON SCHEMA taas IS 'TaaS API';


--
-- TOC entry 29 (class 2615 OID 1363440)
-- Name: terms; Type: SCHEMA; Schema: -; Owner: terms
--

CREATE SCHEMA terms;


ALTER SCHEMA terms OWNER TO terms;

--
-- TOC entry 30 (class 2615 OID 1352749)
-- Name: timeline; Type: SCHEMA; Schema: -; Owner: timeline
--

CREATE SCHEMA timeline;


ALTER SCHEMA timeline OWNER TO timeline;

--
-- TOC entry 7730 (class 0 OID 0)
-- Dependencies: 30
-- Name: SCHEMA timeline; Type: COMMENT; Schema: -; Owner: timeline
--

COMMENT ON SCHEMA timeline IS 'Timeline wall API';


--
-- TOC entry 1 (class 3079 OID 1476033)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA pg_catalog;


--
-- TOC entry 7732 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 5 (class 3079 OID 2069551)
-- Name: pg_prewarm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_prewarm WITH SCHEMA public;


--
-- TOC entry 7733 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pg_prewarm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_prewarm IS 'prewarm relation data';


--
-- TOC entry 3 (class 3079 OID 1323388)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA pg_catalog;


--
-- TOC entry 7734 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 6 (class 3079 OID 2033646)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA reviews;


--
-- TOC entry 7735 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 2 (class 3079 OID 1334256)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA pg_catalog;


--
-- TOC entry 7736 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1515 (class 1247 OID 1362922)
-- Name: CertificationStatus; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."CertificationStatus" AS ENUM (
    'active',
    'inactive',
    'coming_soon',
    'deprecated',
    'coming-soon'
);


ALTER TYPE academy."CertificationStatus" OWNER TO topcoder;

--
-- TOC entry 1518 (class 1247 OID 1362934)
-- Name: CourseStatus; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."CourseStatus" AS ENUM (
    'available',
    'coming_soon',
    'not_available',
    'removed'
);


ALTER TYPE academy."CourseStatus" OWNER TO topcoder;

--
-- TOC entry 1521 (class 1247 OID 1362944)
-- Name: FccCertificationType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."FccCertificationType" AS ENUM (
    'certification',
    'course-completion'
);


ALTER TYPE academy."FccCertificationType" OWNER TO topcoder;

--
-- TOC entry 1524 (class 1247 OID 1362950)
-- Name: LearnerLevel; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."LearnerLevel" AS ENUM (
    'Beginner',
    'Intermediate',
    'Expert',
    'All Levels'
);


ALTER TYPE academy."LearnerLevel" OWNER TO topcoder;

--
-- TOC entry 1527 (class 1247 OID 1362960)
-- Name: ResourceableType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."ResourceableType" AS ENUM (
    'FreeCodeCampCertification',
    'TopcoderUdemyCourse'
);


ALTER TYPE academy."ResourceableType" OWNER TO topcoder;

--
-- TOC entry 1530 (class 1247 OID 1362966)
-- Name: enum_CertificationEnrollment_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationEnrollment_status" AS ENUM (
    'enrolled',
    'disenrolled',
    'completed'
);


ALTER TYPE academy."enum_CertificationEnrollment_status" OWNER TO topcoder;

--
-- TOC entry 1533 (class 1247 OID 1362974)
-- Name: enum_CertificationEnrollments_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationEnrollments_status" AS ENUM (
    'enrolled',
    'disenrolled',
    'completed'
);


ALTER TYPE academy."enum_CertificationEnrollments_status" OWNER TO topcoder;

--
-- TOC entry 1536 (class 1247 OID 1362982)
-- Name: enum_CertificationResourceProgresses_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationResourceProgresses_status" AS ENUM (
    'not-started',
    'in-progress',
    'completed'
);


ALTER TYPE academy."enum_CertificationResourceProgresses_status" OWNER TO topcoder;

--
-- TOC entry 1539 (class 1247 OID 1362990)
-- Name: enum_CertificationResource_resourceableType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationResource_resourceableType" AS ENUM (
    'FreeCodeCampCertification',
    'TopcoderUdemyCourse'
);


ALTER TYPE academy."enum_CertificationResource_resourceableType" OWNER TO topcoder;

--
-- TOC entry 1542 (class 1247 OID 1362996)
-- Name: enum_FccCertificationProgresses_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccCertificationProgresses_status" AS ENUM (
    'in-progress',
    'completed',
    'not-started'
);


ALTER TYPE academy."enum_FccCertificationProgresses_status" OWNER TO topcoder;

--
-- TOC entry 1545 (class 1247 OID 1363004)
-- Name: enum_FccCourseProgresses_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccCourseProgresses_status" AS ENUM (
    'in-progress',
    'completed'
);


ALTER TYPE academy."enum_FccCourseProgresses_status" OWNER TO topcoder;

--
-- TOC entry 1548 (class 1247 OID 1363010)
-- Name: enum_FccCourses_learnerLevel; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccCourses_learnerLevel" AS ENUM (
    'Beginner',
    'Intermediate',
    'Expert',
    'All Levels'
);


ALTER TYPE academy."enum_FccCourses_learnerLevel" OWNER TO topcoder;

--
-- TOC entry 1551 (class 1247 OID 1363020)
-- Name: enum_FccModuleProgresses_moduleStatus; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccModuleProgresses_moduleStatus" AS ENUM (
    'not-started',
    'in-progress',
    'completed'
);


ALTER TYPE academy."enum_FccModuleProgresses_moduleStatus" OWNER TO topcoder;

--
-- TOC entry 1554 (class 1247 OID 1363028)
-- Name: enum_FreeCodeCampCertification_certType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FreeCodeCampCertification_certType" AS ENUM (
    'certification',
    'course-completion'
);


ALTER TYPE academy."enum_FreeCodeCampCertification_certType" OWNER TO topcoder;

--
-- TOC entry 1557 (class 1247 OID 1363034)
-- Name: enum_FreeCodeCampCertification_learnerLevel; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FreeCodeCampCertification_learnerLevel" AS ENUM (
    'Beginner',
    'Intermediate',
    'Expert',
    'All Levels'
);


ALTER TYPE academy."enum_FreeCodeCampCertification_learnerLevel" OWNER TO topcoder;

--
-- TOC entry 1560 (class 1247 OID 1363044)
-- Name: enum_FreeCodeCampCertification_state; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FreeCodeCampCertification_state" AS ENUM (
    'active',
    'inactive',
    'coming_soon',
    'coming-soon',
    'deprecated'
);


ALTER TYPE academy."enum_FreeCodeCampCertification_state" OWNER TO topcoder;

--
-- TOC entry 1563 (class 1247 OID 1363056)
-- Name: enum_TopcoderCertification_learnerLevel; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_TopcoderCertification_learnerLevel" AS ENUM (
    'Beginner',
    'Intermediate',
    'Expert',
    'All Levels'
);


ALTER TYPE academy."enum_TopcoderCertification_learnerLevel" OWNER TO topcoder;

--
-- TOC entry 1566 (class 1247 OID 1363066)
-- Name: enum_TopcoderCertification_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_TopcoderCertification_status" AS ENUM (
    'active',
    'inactive',
    'coming_soon',
    'deprecated'
);


ALTER TYPE academy."enum_TopcoderCertification_status" OWNER TO topcoder;

--
-- TOC entry 1569 (class 1247 OID 1363076)
-- Name: enum_TopcoderUdemyCourse_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_TopcoderUdemyCourse_status" AS ENUM (
    'available',
    'coming_soon',
    'not_available',
    'removed'
);


ALTER TYPE academy."enum_TopcoderUdemyCourse_status" OWNER TO topcoder;

--
-- TOC entry 1572 (class 1247 OID 1363086)
-- Name: enum_UdemyCourse_level; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_UdemyCourse_level" AS ENUM (
    'Beginner',
    'Intermediate',
    'Expert',
    'All Levels'
);


ALTER TYPE academy."enum_UdemyCourse_level" OWNER TO topcoder;

--
-- TOC entry 2280 (class 1247 OID 2069908)
-- Name: BAStatus; Type: TYPE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TYPE "billing-accounts"."BAStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE "billing-accounts"."BAStatus" OWNER TO billingaccounts;

--
-- TOC entry 2277 (class 1247 OID 2069902)
-- Name: ClientStatus; Type: TYPE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TYPE "billing-accounts"."ClientStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE "billing-accounts"."ClientStatus" OWNER TO billingaccounts;

--
-- TOC entry 1899 (class 1247 OID 2004858)
-- Name: ChallengeStatusEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."ChallengeStatusEnum" AS ENUM (
    'NEW',
    'DRAFT',
    'APPROVED',
    'ACTIVE',
    'COMPLETED',
    'DELETED',
    'CANCELLED',
    'CANCELLED_FAILED_REVIEW',
    'CANCELLED_FAILED_SCREENING',
    'CANCELLED_ZERO_SUBMISSIONS',
    'CANCELLED_WINNER_UNRESPONSIVE',
    'CANCELLED_CLIENT_REQUEST',
    'CANCELLED_REQUIREMENTS_INFEASIBLE',
    'CANCELLED_ZERO_REGISTRATIONS',
    'CANCELLED_PAYMENT_FAILED'
);


ALTER TYPE challenges."ChallengeStatusEnum" OWNER TO challenges;

--
-- TOC entry 1983 (class 1247 OID 2005316)
-- Name: ChallengeTrackEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."ChallengeTrackEnum" AS ENUM (
    'DESIGN',
    'DATA_SCIENCE',
    'DEVELOPMENT',
    'QUALITY_ASSURANCE'
);


ALTER TYPE challenges."ChallengeTrackEnum" OWNER TO challenges;

--
-- TOC entry 1896 (class 1247 OID 2004854)
-- Name: DiscussionTypeEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."DiscussionTypeEnum" AS ENUM (
    'CHALLENGE'
);


ALTER TYPE challenges."DiscussionTypeEnum" OWNER TO challenges;

--
-- TOC entry 1902 (class 1247 OID 2004890)
-- Name: PrizeSetTypeEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."PrizeSetTypeEnum" AS ENUM (
    'PLACEMENT',
    'COPILOT',
    'REVIEWER',
    'CHECKPOINT'
);


ALTER TYPE challenges."PrizeSetTypeEnum" OWNER TO challenges;

--
-- TOC entry 1977 (class 1247 OID 2005282)
-- Name: ReviewOpportunityTypeEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."ReviewOpportunityTypeEnum" AS ENUM (
    'REGULAR_REVIEW',
    'COMPONENT_DEV_REVIEW',
    'SPEC_REVIEW',
    'ITERATIVE_REVIEW',
    'SCENARIOS_REVIEW'
);


ALTER TYPE challenges."ReviewOpportunityTypeEnum" OWNER TO challenges;

--
-- TOC entry 1893 (class 1247 OID 2004848)
-- Name: ReviewTypeEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."ReviewTypeEnum" AS ENUM (
    'COMMUNITY',
    'INTERNAL',
    'SYSTEM',
    'PROVISIONAL',
    'EXAMPLE'
);


ALTER TYPE challenges."ReviewTypeEnum" OWNER TO challenges;

--
-- TOC entry 1398 (class 1247 OID 1334282)
-- Name: action_type; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.action_type AS ENUM (
    'INITIATE_WITHDRAWAL',
    'ADD_WITHDRAWAL_METHOD',
    'REMOVE_WITHDRAWAL_METHOD',
    'SETUP_TAX_FORMS',
    'REMOVE_TAX_FORMS'
);


ALTER TYPE finance.action_type OWNER TO finance;

--
-- TOC entry 1401 (class 1247 OID 1334304)
-- Name: payment_method_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.payment_method_status AS ENUM (
    'OTP_PENDING',
    'OTP_VERIFIED',
    'CONNECTED',
    'INACTIVE'
);


ALTER TYPE finance.payment_method_status OWNER TO finance;

--
-- TOC entry 1404 (class 1247 OID 1334314)
-- Name: payment_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.payment_status AS ENUM (
    'PAID',
    'ON_HOLD',
    'ON_HOLD_ADMIN',
    'OWED',
    'PROCESSING',
    'CANCELLED',
    'FAILED',
    'RETURNED'
);


ALTER TYPE finance.payment_status OWNER TO finance;

--
-- TOC entry 1407 (class 1247 OID 1334328)
-- Name: reference_type; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.reference_type AS ENUM (
    'ADD_PAYMENT_METHOD',
    'REMOVE_PAYMENT_METHOD',
    'GET_PAYMENT_METHOD_REGISTRATION_LINK',
    'VIEW_TAX_FORM',
    'SUBMIT_TAX_FORM',
    'REMOVE_TAX_FORM',
    'WITHDRAW_PAYMENT'
);


ALTER TYPE finance.reference_type OWNER TO finance;

--
-- TOC entry 1455 (class 1247 OID 1334766)
-- Name: tax_form_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.tax_form_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE finance.tax_form_status OWNER TO finance;

--
-- TOC entry 1410 (class 1247 OID 1334354)
-- Name: transaction_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.transaction_status AS ENUM (
    'INITIATED',
    'COMPLETED',
    'EXPIRED',
    'CANCELLED',
    'FAILED'
);


ALTER TYPE finance.transaction_status OWNER TO finance;

--
-- TOC entry 1734 (class 1247 OID 1771164)
-- Name: verification_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.verification_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE finance.verification_status OWNER TO finance;

--
-- TOC entry 1446 (class 1247 OID 1334733)
-- Name: webhook_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.webhook_status AS ENUM (
    'error',
    'processed',
    'logged'
);


ALTER TYPE finance.webhook_status OWNER TO finance;

--
-- TOC entry 1413 (class 1247 OID 1334366)
-- Name: winnings_category; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.winnings_category AS ENUM (
    'ALGORITHM_CONTEST_PAYMENT',
    'CONTRACT_PAYMENT',
    'PROBLEM_PAYMENT',
    'CODER_REFERRAL_PAYMENT',
    'CHARITY_PAYMENT',
    'COMPONENT_PAYMENT',
    'REVIEW_BOARD_PAYMENT',
    'ONE_OFF_PAYMENT',
    'BUG_FIXES_PAYMENT',
    'MARATHON_MATCH_PAYMENT',
    'DIGITAL_RUN_PAYMENT',
    'DIGITAL_RUN_ROOKIE_PAYMENT',
    'PROBLEM_TESTING_PAYMENT',
    'PROBLEM_WRITING_PAYMENT',
    'TOPCODER_STUDIO_CONTEST_PAYMENT',
    'LOGO_CONTEST_PAYMENT',
    'ARTICLE_PAYMENT',
    'CCIP_PAYMENT',
    'COMPONENT_TOURNAMENT_BONUS_PAYMENT',
    'ROYALTY_PAYMENT',
    'ALGORITHM_TOURNAMENT_PRIZE_PAYMENT',
    'RELIABILITY_BONUS_PAYMENT',
    'DIGITAL_RUN_TOP_PERFORMERS_PAYMENT',
    'ARCHITECTURE_REVIEW_PAYMENT',
    'SPECIFICATION_REVIEW_PAYMENT',
    'ASSEMBLY_COMPETITION_REVIEW',
    'ARCHITECTURE_PAYMENT',
    'PREDICTIVE_CONTEST_PAYMENT',
    'INTRODUCTORY_EVENT_COMPONENT_CONTEST_PAYMENT',
    'MARATHON_MATCH_TOURNAMENT_PRIZE_PAYMENT',
    'ASSEMBLY_PAYMENT',
    'TESTING_PAYMENT',
    'STUDIO_TOURNAMENT_PRIZE_PAYMENT',
    'HIGH_SCHOOL_TOURNAMENT_PRIZE_PAYMENT',
    'COLLEGE_TOUR_REPRESENTATIVE',
    'STUDIO_REVIEW_BOARD_PAYMENT',
    'COMPONENT_ENHANCEMENTS_PAYMENT',
    'REVIEW_BOARD_BONUS_PAYMENT',
    'COMPONENT_BUILD_PAYMENT',
    'DIGITAL_RUN_V2_PAYMENT',
    'DIGITAL_RUN_V2_TOP_PERFORMERS_PAYMENT',
    'SPECIFICATION_CONTEST_PAYMENT',
    'CONCEPTUALIZATION_CONTEST_PAYMENT',
    'TEST_SUITES_PAYMENT',
    'COPILOT_PAYMENT',
    'STUDIO_BUG_FIXES_PAYMENT',
    'STUDIO_ENHANCEMENTS_PAYMENT',
    'STUDIO_SPECIFICATION_REVIEW_PAYMENT',
    'UI_PROTOTYPE_COMPETITION_PAYMENT',
    'RIA_BUILD_COMPETITION_PAYMENT',
    'RIA_COMPONENT_COMPETITION_PAYMENT',
    'SPECIFICATION_WRITING_PAYMENT',
    'STUDIO_SPECIFICATION_WRITING_PAYMENT',
    'DEPLOYMENT_TASK_PAYMENT',
    'TEST_SCENARIOS_PAYMENT',
    'STUDIO_SUBMISSION_SCREENING_PAYMENT',
    'STUDIO_COPILOT_PAYMENT',
    'COPILOT_POSTING_PAYMENT',
    'CONTENT_CREATION_PAYMENT',
    'DIGITAL_RUN_V2_PAYMENT_TAXABLE',
    'DIGITAL_RUN_V2_TOP_PERFORMERS_PAYMENT_TAXABLE',
    'CONTEST_CHECKPOINT_PAYMENT',
    'CONTEST_PAYMENT',
    'MARATHON_MATCH_NON_TAXABLE_PAYMENT',
    'NEGATIVE_PAYMENT',
    'PROJECT_BUG_FIXES_PAYMENT',
    'PROJECT_COPILOT_PAYMENT',
    'PROJECT_DEPLOYMENT_TASK_PAYMENT',
    'PROJECT_ENHANCEMENTS_PAYMENT',
    'TASK_PAYMENT',
    'TASK_REVIEW_PAYMENT',
    'TASK_COPILOT_PAYMENT'
);


ALTER TYPE finance.winnings_category OWNER TO finance;

--
-- TOC entry 1416 (class 1247 OID 1334512)
-- Name: winnings_type; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.winnings_type AS ENUM (
    'PAYMENT',
    'REWARD'
);


ALTER TYPE finance.winnings_type OWNER TO finance;

--
-- TOC entry 2301 (class 1247 OID 2070272)
-- Name: GroupStatus; Type: TYPE; Schema: groups; Owner: groups
--

CREATE TYPE groups."GroupStatus" AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE groups."GroupStatus" OWNER TO groups;

--
-- TOC entry 2007 (class 1247 OID 2023538)
-- Name: DeviceType; Type: TYPE; Schema: members; Owner: members
--

CREATE TYPE members."DeviceType" AS ENUM (
    'Console',
    'Desktop',
    'Laptop',
    'Smartphone',
    'Tablet',
    'Wearable',
    'Other'
);


ALTER TYPE members."DeviceType" OWNER TO members;

--
-- TOC entry 2004 (class 1247 OID 2023528)
-- Name: FinancialStatus; Type: TYPE; Schema: members; Owner: members
--

CREATE TYPE members."FinancialStatus" AS ENUM (
    'PENDING',
    'PAID',
    'FAILED',
    'CANCELLED'
);


ALTER TYPE members."FinancialStatus" OWNER TO members;

--
-- TOC entry 2001 (class 1247 OID 2023514)
-- Name: MemberStatus; Type: TYPE; Schema: members; Owner: members
--

CREATE TYPE members."MemberStatus" AS ENUM (
    'UNVERIFIED',
    'ACTIVE',
    'INACTIVE_USER_REQUEST',
    'INACTIVE_DUPLICATE_ACCOUNT',
    'INACTIVE_IRREGULAR_ACCOUNT',
    'UNKNOWN'
);


ALTER TYPE members."MemberStatus" OWNER TO members;

--
-- TOC entry 2013 (class 1247 OID 2023564)
-- Name: ServiceProviderType; Type: TYPE; Schema: members; Owner: members
--

CREATE TYPE members."ServiceProviderType" AS ENUM (
    'InternetServiceProvider',
    'MobileCarrier',
    'Television',
    'FinancialInstitution',
    'Other'
);


ALTER TYPE members."ServiceProviderType" OWNER TO members;

--
-- TOC entry 2010 (class 1247 OID 2023552)
-- Name: SoftwareType; Type: TYPE; Schema: members; Owner: members
--

CREATE TYPE members."SoftwareType" AS ENUM (
    'DeveloperTools',
    'Browser',
    'Productivity',
    'GraphAndDesign',
    'Utilities'
);


ALTER TYPE members."SoftwareType" OWNER TO members;

--
-- TOC entry 2016 (class 1247 OID 2023576)
-- Name: WorkIndustryType; Type: TYPE; Schema: members; Owner: members
--

CREATE TYPE members."WorkIndustryType" AS ENUM (
    'Banking',
    'ConsumerGoods',
    'Energy',
    'Entertainment',
    'HealthCare',
    'Pharma',
    'PublicSector',
    'TechAndTechnologyService',
    'Telecoms',
    'TravelAndHospitality'
);


ALTER TYPE members."WorkIndustryType" OWNER TO members;

--
-- TOC entry 1659 (class 1247 OID 1436579)
-- Name: enum_ScheduledEvents_status; Type: TYPE; Schema: notifications; Owner: topcoder
--

CREATE TYPE notifications."enum_ScheduledEvents_status" AS ENUM (
    'pending',
    'completed',
    'failed'
);


ALTER TYPE notifications."enum_ScheduledEvents_status" OWNER TO topcoder;

--
-- TOC entry 1282 (class 1247 OID 1323824)
-- Name: enum_project_phase_approval_decision; Type: TYPE; Schema: projects; Owner: topcoder
--

CREATE TYPE projects.enum_project_phase_approval_decision AS ENUM (
    'approve',
    'reject'
);


ALTER TYPE projects.enum_project_phase_approval_decision OWNER TO topcoder;

--
-- TOC entry 2151 (class 1247 OID 2033716)
-- Name: ChallengeTrack; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ChallengeTrack" AS ENUM (
    'DEVELOPMENT',
    'DATA_SCIENCE',
    'DESIGN',
    'QUALITY_ASSURANCE'
);


ALTER TYPE reviews."ChallengeTrack" OWNER TO reviews;

--
-- TOC entry 2154 (class 1247 OID 2033726)
-- Name: QuestionType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."QuestionType" AS ENUM (
    'SCALE',
    'YES_NO',
    'TEST_CASE'
);


ALTER TYPE reviews."QuestionType" OWNER TO reviews;

--
-- TOC entry 2199 (class 1247 OID 2033966)
-- Name: ReviewApplicationRole; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewApplicationRole" AS ENUM (
    'PRIMARY_REVIEWER',
    'SECONDARY_REVIEWER',
    'PRIMARY_FAILURE_REVIEWER',
    'ACCURACY_REVIEWER',
    'STRESS_REVIEWER',
    'FAILURE_REVIEWER',
    'SPECIFICATION_REVIEWER',
    'ITERATIVE_REVIEWER',
    'REVIEWER'
);


ALTER TYPE reviews."ReviewApplicationRole" OWNER TO reviews;

--
-- TOC entry 2193 (class 1247 OID 2033944)
-- Name: ReviewApplicationStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewApplicationStatus" AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED'
);


ALTER TYPE reviews."ReviewApplicationStatus" OWNER TO reviews;

--
-- TOC entry 2157 (class 1247 OID 2033732)
-- Name: ReviewItemCommentType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewItemCommentType" AS ENUM (
    'COMMENT',
    'REQUIRED',
    'RECOMMENDED',
    'AGGREGATION_COMMENT',
    'AGGREGATION_REVIEW_COMMENT',
    'SUBMITTER_COMMENT',
    'FINAL_FIX_COMMENT',
    'FINAL_REVIEW_COMMENT',
    'MANAGER_COMMENT',
    'APPROVAL_REVIEW_COMMENT',
    'APPROVAL_REVIEW_COMMENT_OTHER_FIXES',
    'SPECIFICATION_REVIEW_COMMENT'
);


ALTER TYPE reviews."ReviewItemCommentType" OWNER TO reviews;

--
-- TOC entry 2190 (class 1247 OID 2033936)
-- Name: ReviewOpportunityStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewOpportunityStatus" AS ENUM (
    'OPEN',
    'CLOSED',
    'CANCELLED'
);


ALTER TYPE reviews."ReviewOpportunityStatus" OWNER TO reviews;

--
-- TOC entry 2196 (class 1247 OID 2033954)
-- Name: ReviewOpportunityType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewOpportunityType" AS ENUM (
    'REGULAR_REVIEW',
    'COMPONENT_DEV_REVIEW',
    'SPEC_REVIEW',
    'ITERATIVE_REVIEW',
    'SCENARIOS_REVIEW'
);


ALTER TYPE reviews."ReviewOpportunityType" OWNER TO reviews;

--
-- TOC entry 2256 (class 1247 OID 2034313)
-- Name: ReviewStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewStatus" AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'COMPLETED',
    'DRAFT',
    'SUBMITTED',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE reviews."ReviewStatus" OWNER TO reviews;

--
-- TOC entry 2145 (class 1247 OID 2033691)
-- Name: ScorecardStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ScorecardStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'DELETED'
);


ALTER TYPE reviews."ScorecardStatus" OWNER TO reviews;

--
-- TOC entry 2148 (class 1247 OID 2033698)
-- Name: ScorecardType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ScorecardType" AS ENUM (
    'SCREENING',
    'REVIEW',
    'APPROVAL',
    'POST_MORTEM',
    'SPECIFICATION_REVIEW',
    'CHECKPOINT_SCREENING',
    'CHECKPOINT_REVIEW',
    'ITERATIVE_REVIEW'
);


ALTER TYPE reviews."ScorecardType" OWNER TO reviews;

--
-- TOC entry 2226 (class 1247 OID 2034096)
-- Name: SubmissionStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."SubmissionStatus" AS ENUM (
    'ACTIVE',
    'FAILED_SCREENING',
    'FAILED_REVIEW',
    'COMPLETED_WITHOUT_WIN',
    'DELETED',
    'FAILED_CHECKPOINT_SCREENING',
    'FAILED_CHECKPOINT_REVIEW'
);


ALTER TYPE reviews."SubmissionStatus" OWNER TO reviews;

--
-- TOC entry 2223 (class 1247 OID 2034086)
-- Name: SubmissionType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."SubmissionType" AS ENUM (
    'CONTEST_SUBMISSION',
    'SPECIFICATION_SUBMISSION',
    'CHECKPOINT_SUBMISSION',
    'STUDIO_FINAL_FIX_SUBMISSION'
);


ALTER TYPE reviews."SubmissionType" OWNER TO reviews;

--
-- TOC entry 2220 (class 1247 OID 2034080)
-- Name: UploadStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."UploadStatus" AS ENUM (
    'ACTIVE',
    'DELETED'
);


ALTER TYPE reviews."UploadStatus" OWNER TO reviews;

--
-- TOC entry 2217 (class 1247 OID 2034071)
-- Name: UploadType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."UploadType" AS ENUM (
    'SUBMISSION',
    'TEST_CASE',
    'FINAL_FIX',
    'REVIEW_DOCUMENT'
);


ALTER TYPE reviews."UploadType" OWNER TO reviews;

--
-- TOC entry 1686 (class 1247 OID 1475408)
-- Name: enum_interviews_status; Type: TYPE; Schema: taas; Owner: topcoder
--

CREATE TYPE taas.enum_interviews_status AS ENUM (
    'Scheduling',
    'Scheduled',
    'Requested for reschedule',
    'Rescheduled',
    'Completed',
    'Cancelled',
    'Expired'
);


ALTER TYPE taas.enum_interviews_status OWNER TO topcoder;

--
-- TOC entry 1689 (class 1247 OID 1475424)
-- Name: enum_payment_schedulers_status; Type: TYPE; Schema: taas; Owner: topcoder
--

CREATE TYPE taas.enum_payment_schedulers_status AS ENUM (
    'in-progress',
    'completed',
    'failed'
);


ALTER TYPE taas.enum_payment_schedulers_status OWNER TO topcoder;

--
-- TOC entry 1692 (class 1247 OID 1475432)
-- Name: enum_payment_schedulers_step; Type: TYPE; Schema: taas; Owner: topcoder
--

CREATE TYPE taas.enum_payment_schedulers_step AS ENUM (
    'start-process',
    'create-challenge',
    'assign-member',
    'activate-challenge',
    'get-userId',
    'close-challenge'
);


ALTER TYPE taas.enum_payment_schedulers_step OWNER TO topcoder;

--
-- TOC entry 1695 (class 1247 OID 1475446)
-- Name: enum_work_period_payments_status; Type: TYPE; Schema: taas; Owner: topcoder
--

CREATE TYPE taas.enum_work_period_payments_status AS ENUM (
    'completed',
    'cancelled',
    'scheduled',
    'in-progress',
    'failed'
);


ALTER TYPE taas.enum_work_period_payments_status OWNER TO topcoder;

--
-- TOC entry 1509 (class 1247 OID 1352752)
-- Name: event-status; Type: TYPE; Schema: timeline; Owner: topcoder
--

CREATE TYPE timeline."event-status" AS ENUM (
    'InReview',
    'Approved',
    'Rejected',
    'Deleted'
);


ALTER TYPE timeline."event-status" OWNER TO topcoder;

--
-- TOC entry 625 (class 1255 OID 1323829)
-- Name: project_text_update_trigger(); Type: FUNCTION; Schema: projects; Owner: topcoder
--

CREATE FUNCTION projects.project_text_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        new."projectFullText" :=
        lower(new.name || ' ' || coalesce(new.description, '') || ' ' || coalesce(new.details#>>'{utm, code}', ''));
        return new;
    end
$$;


ALTER FUNCTION projects.project_text_update_trigger() OWNER TO topcoder;

--
-- TOC entry 664 (class 1255 OID 2066978)
-- Name: handle_appeal_change(); Type: FUNCTION; Schema: reviews; Owner: reviews
--

CREATE FUNCTION reviews.handle_appeal_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM reviews.update_review_pending_summary_for_resource(NEW."resourceId");
  RETURN NEW;
END;
$$;


ALTER FUNCTION reviews.handle_appeal_change() OWNER TO reviews;

--
-- TOC entry 665 (class 1255 OID 2066980)
-- Name: handle_appeal_response_change(); Type: FUNCTION; Schema: reviews; Owner: reviews
--

CREATE FUNCTION reviews.handle_appeal_response_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  target_resource text;
BEGIN
  IF TG_OP IN ('INSERT','UPDATE') THEN
    target_resource := NEW."resourceId";
  ELSE
    target_resource := OLD."resourceId";
  END IF;

  PERFORM reviews.update_review_pending_summary_for_resource(target_resource);
  RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION reviews.handle_appeal_response_change() OWNER TO reviews;

--
-- TOC entry 662 (class 1255 OID 2033683)
-- Name: nanoid(integer); Type: FUNCTION; Schema: reviews; Owner: reviews
--

CREATE FUNCTION reviews.nanoid(size integer DEFAULT 14) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  id text := '';
  i int := 0;
  urlAlphabet char(64) := 'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';
  bytes bytea := gen_random_bytes(size);
  byte int;
  pos int;
BEGIN
  WHILE i < size LOOP
    byte := get_byte(bytes, i);
    pos := (byte & 63) + 1; -- + 1 because substr starts at 1 for some reason
    id := id || substr(urlAlphabet, pos, 1);
    i = i + 1;
  END LOOP;
  RETURN id;
END
$$;


ALTER FUNCTION reviews.nanoid(size integer) OWNER TO reviews;

--
-- TOC entry 663 (class 1255 OID 2066977)
-- Name: update_review_pending_summary_for_resource(text); Type: FUNCTION; Schema: reviews; Owner: reviews
--

CREATE FUNCTION reviews.update_review_pending_summary_for_resource(p_resource_id text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  pending_count integer;
BEGIN
  SELECT COUNT(*)
  INTO pending_count
  FROM reviews.review rv
  JOIN reviews."reviewItem" ri
    ON ri."reviewId" = rv.id
  JOIN reviews."reviewItemComment" ric
    ON ric."reviewItemId" = ri.id
  JOIN reviews.appeal ap
    ON ap."reviewItemCommentId" = ric.id
  LEFT JOIN reviews."appealResponse" apr
    ON apr."appealId" = ap.id
   AND apr."resourceId" = rv."resourceId"
  WHERE rv."resourceId" = p_resource_id
    AND apr.id IS NULL;

  IF pending_count > 0 THEN
    INSERT INTO reviews.review_pending_summary ("resourceId", "pendingAppealCount", "updatedAt")
    VALUES (p_resource_id, pending_count, now())
    ON CONFLICT ("resourceId")
    DO UPDATE SET
      "pendingAppealCount" = EXCLUDED."pendingAppealCount",
      "updatedAt"          = now();
  ELSE
    DELETE FROM reviews.review_pending_summary
    WHERE "resourceId" = p_resource_id;
  END IF;
END;
$$;


ALTER FUNCTION reviews.update_review_pending_summary_for_resource(p_resource_id text) OWNER TO reviews;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 344 (class 1259 OID 1363095)
-- Name: CertificationCategory; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."CertificationCategory" (
    id integer NOT NULL,
    category text NOT NULL,
    track text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE academy."CertificationCategory" OWNER TO topcoder;

--
-- TOC entry 345 (class 1259 OID 1363100)
-- Name: CertificationCategory_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."CertificationCategory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."CertificationCategory_id_seq" OWNER TO topcoder;

--
-- TOC entry 7741 (class 0 OID 0)
-- Dependencies: 345
-- Name: CertificationCategory_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationCategory_id_seq" OWNED BY academy."CertificationCategory".id;


--
-- TOC entry 346 (class 1259 OID 1363101)
-- Name: CertificationEnrollments; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."CertificationEnrollments" (
    id integer NOT NULL,
    "topcoderCertificationId" integer,
    "userId" character varying(255),
    "userHandle" character varying(255),
    status academy."enum_CertificationEnrollments_status" DEFAULT 'enrolled'::academy."enum_CertificationEnrollments_status",
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "completedAt" timestamp with time zone,
    "userName" character varying(255),
    "completionUuid" character varying(255),
    "completionEventId" uuid
);


ALTER TABLE academy."CertificationEnrollments" OWNER TO topcoder;

--
-- TOC entry 347 (class 1259 OID 1363107)
-- Name: CertificationEnrollments_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."CertificationEnrollments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."CertificationEnrollments_id_seq" OWNER TO topcoder;

--
-- TOC entry 7744 (class 0 OID 0)
-- Dependencies: 347
-- Name: CertificationEnrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationEnrollments_id_seq" OWNED BY academy."CertificationEnrollments".id;


--
-- TOC entry 348 (class 1259 OID 1363108)
-- Name: CertificationResource; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."CertificationResource" (
    id integer NOT NULL,
    "resourceProviderId" integer NOT NULL,
    "resourceableId" integer NOT NULL,
    "resourceableType" academy."ResourceableType" NOT NULL,
    "displayOrder" integer,
    "completionOrder" integer,
    "resourceDescription" text,
    "resourceTitle" text,
    "topcoderCertificationId" integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE academy."CertificationResource" OWNER TO topcoder;

--
-- TOC entry 349 (class 1259 OID 1363113)
-- Name: CertificationResourceProgresses; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."CertificationResourceProgresses" (
    id integer NOT NULL,
    "certificationEnrollmentId" integer,
    "certificationResourceId" integer,
    status academy."enum_CertificationResourceProgresses_status" DEFAULT 'not-started'::academy."enum_CertificationResourceProgresses_status",
    "resourceProgressId" integer,
    "resourceProgressType" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE academy."CertificationResourceProgresses" OWNER TO topcoder;

--
-- TOC entry 350 (class 1259 OID 1363117)
-- Name: CertificationResourceProgresses_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."CertificationResourceProgresses_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."CertificationResourceProgresses_id_seq" OWNER TO topcoder;

--
-- TOC entry 7748 (class 0 OID 0)
-- Dependencies: 350
-- Name: CertificationResourceProgresses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationResourceProgresses_id_seq" OWNED BY academy."CertificationResourceProgresses".id;


--
-- TOC entry 351 (class 1259 OID 1363118)
-- Name: CertificationResource_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."CertificationResource_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."CertificationResource_id_seq" OWNER TO topcoder;

--
-- TOC entry 7750 (class 0 OID 0)
-- Dependencies: 351
-- Name: CertificationResource_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationResource_id_seq" OWNED BY academy."CertificationResource".id;


--
-- TOC entry 352 (class 1259 OID 1363119)
-- Name: DataVersion; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."DataVersion" (
    version timestamp(3) without time zone NOT NULL
);


ALTER TABLE academy."DataVersion" OWNER TO topcoder;

--
-- TOC entry 353 (class 1259 OID 1363122)
-- Name: FccCertificationProgresses; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FccCertificationProgresses" (
    id integer NOT NULL,
    "fccCertificationId" integer,
    "certProgressDynamoUuid" uuid,
    "fccCourseId" integer,
    "userId" character varying(255) NOT NULL,
    certification character varying(255),
    "certificationId" character varying(255),
    "certificationTitle" character varying(255),
    "certificationTrackType" character varying(255),
    "certType" character varying(255),
    "courseKey" character varying(255) NOT NULL,
    status academy."enum_FccCertificationProgresses_status" NOT NULL,
    "startDate" timestamp with time zone,
    "lastInteractionDate" timestamp with time zone,
    "completedDate" timestamp with time zone,
    "academicHonestyPolicyAcceptedAt" timestamp with time zone,
    "currentLesson" character varying(255),
    "certificationImageUrl" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    email character varying(255),
    "completionEventId" uuid
);


ALTER TABLE academy."FccCertificationProgresses" OWNER TO topcoder;

--
-- TOC entry 354 (class 1259 OID 1363127)
-- Name: FccCertificationProgresses_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."FccCertificationProgresses_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."FccCertificationProgresses_id_seq" OWNER TO topcoder;

--
-- TOC entry 7754 (class 0 OID 0)
-- Dependencies: 354
-- Name: FccCertificationProgresses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccCertificationProgresses_id_seq" OWNED BY academy."FccCertificationProgresses".id;


--
-- TOC entry 355 (class 1259 OID 1363128)
-- Name: FccCompletedLessons; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FccCompletedLessons" (
    id character varying(255) NOT NULL,
    "fccModuleProgressId" integer NOT NULL,
    "dashedName" character varying(255) NOT NULL,
    "completedDate" timestamp with time zone
);


ALTER TABLE academy."FccCompletedLessons" OWNER TO topcoder;

--
-- TOC entry 356 (class 1259 OID 1363133)
-- Name: FccCourses; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FccCourses" (
    id integer NOT NULL,
    "fccCourseUuid" uuid NOT NULL,
    "providerId" integer,
    key character varying(255),
    title character varying(255),
    "certificationId" integer,
    "estimatedCompletionTimeValue" integer,
    "estimatedCompletionTimeUnits" character varying(255),
    "introCopy" text[],
    "keyPoints" text[],
    "completionSuggestions" text[],
    note character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "learnerLevel" academy."enum_FccCourses_learnerLevel" DEFAULT 'Beginner'::academy."enum_FccCourses_learnerLevel",
    skills uuid[]
);


ALTER TABLE academy."FccCourses" OWNER TO topcoder;

--
-- TOC entry 357 (class 1259 OID 1363139)
-- Name: FccCourses_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."FccCourses_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."FccCourses_id_seq" OWNER TO topcoder;

--
-- TOC entry 7758 (class 0 OID 0)
-- Dependencies: 357
-- Name: FccCourses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccCourses_id_seq" OWNED BY academy."FccCourses".id;


--
-- TOC entry 358 (class 1259 OID 1363140)
-- Name: FccLessons; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FccLessons" (
    id character varying(255) NOT NULL,
    "fccModuleId" integer,
    title character varying(255) NOT NULL,
    "dashedName" character varying(255) NOT NULL,
    "isAssessment" boolean DEFAULT false NOT NULL,
    "order" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE academy."FccLessons" OWNER TO topcoder;

--
-- TOC entry 359 (class 1259 OID 1363146)
-- Name: FccModuleProgresses; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FccModuleProgresses" (
    id integer NOT NULL,
    module character varying(255) NOT NULL,
    "moduleStatus" academy."enum_FccModuleProgresses_moduleStatus" DEFAULT 'not-started'::academy."enum_FccModuleProgresses_moduleStatus",
    "lessonCount" integer,
    "isAssessment" boolean,
    "startDate" timestamp with time zone,
    "lastInteractionDate" timestamp with time zone,
    "completedDate" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "fccCertificationProgressId" integer
);


ALTER TABLE academy."FccModuleProgresses" OWNER TO topcoder;

--
-- TOC entry 360 (class 1259 OID 1363150)
-- Name: FccModuleProgresses_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."FccModuleProgresses_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."FccModuleProgresses_id_seq" OWNER TO topcoder;

--
-- TOC entry 7762 (class 0 OID 0)
-- Dependencies: 360
-- Name: FccModuleProgresses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccModuleProgresses_id_seq" OWNED BY academy."FccModuleProgresses".id;


--
-- TOC entry 361 (class 1259 OID 1363151)
-- Name: FccModules; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FccModules" (
    id integer NOT NULL,
    "fccCourseId" integer,
    key character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "dashedName" character varying(255) NOT NULL,
    "estimatedCompletionTimeValue" integer,
    "estimatedCompletionTimeUnits" character varying(255),
    "introCopy" text[],
    "isAssessment" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "order" integer
);


ALTER TABLE academy."FccModules" OWNER TO topcoder;

--
-- TOC entry 362 (class 1259 OID 1363157)
-- Name: FccModules_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."FccModules_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."FccModules_id_seq" OWNER TO topcoder;

--
-- TOC entry 7765 (class 0 OID 0)
-- Dependencies: 362
-- Name: FccModules_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccModules_id_seq" OWNED BY academy."FccModules".id;


--
-- TOC entry 363 (class 1259 OID 1363158)
-- Name: FreeCodeCampCertification; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."FreeCodeCampCertification" (
    id integer NOT NULL,
    "fccId" uuid NOT NULL,
    key text NOT NULL,
    "providerCertificationId" text NOT NULL,
    title text NOT NULL,
    certification text NOT NULL,
    "completionHours" integer NOT NULL,
    state academy."CertificationStatus" DEFAULT 'active'::academy."CertificationStatus" NOT NULL,
    "certificationCategoryId" integer NOT NULL,
    "certType" academy."FccCertificationType" DEFAULT 'certification'::academy."FccCertificationType" NOT NULL,
    "publishedAt" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "learnerLevel" academy."enum_FreeCodeCampCertification_learnerLevel" DEFAULT 'Beginner'::academy."enum_FreeCodeCampCertification_learnerLevel",
    description text,
    "resourceProviderId" integer
);


ALTER TABLE academy."FreeCodeCampCertification" OWNER TO topcoder;

--
-- TOC entry 364 (class 1259 OID 1363166)
-- Name: FreeCodeCampCertification_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."FreeCodeCampCertification_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."FreeCodeCampCertification_id_seq" OWNER TO topcoder;

--
-- TOC entry 7768 (class 0 OID 0)
-- Dependencies: 364
-- Name: FreeCodeCampCertification_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FreeCodeCampCertification_id_seq" OWNED BY academy."FreeCodeCampCertification".id;


--
-- TOC entry 365 (class 1259 OID 1363167)
-- Name: ResourceProvider; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."ResourceProvider" (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    "attributionStatement" text,
    url text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE academy."ResourceProvider" OWNER TO topcoder;

--
-- TOC entry 366 (class 1259 OID 1363172)
-- Name: ResourceProvider_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."ResourceProvider_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."ResourceProvider_id_seq" OWNER TO topcoder;

--
-- TOC entry 7771 (class 0 OID 0)
-- Dependencies: 366
-- Name: ResourceProvider_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."ResourceProvider_id_seq" OWNED BY academy."ResourceProvider".id;


--
-- TOC entry 367 (class 1259 OID 1363173)
-- Name: SequelizeMeta; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE academy."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 368 (class 1259 OID 1363176)
-- Name: TopcoderCertification; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."TopcoderCertification" (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    status academy."CertificationStatus" DEFAULT 'active'::academy."CertificationStatus" NOT NULL,
    "sequentialCourses" boolean DEFAULT false NOT NULL,
    "learnerLevel" academy."LearnerLevel" NOT NULL,
    version timestamp(3) without time zone NOT NULL,
    "certificationCategoryId" integer NOT NULL,
    "stripeProductId" text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "learningOutcomes" text[],
    prerequisites text[],
    "dashedName" character varying(255),
    "introText" text,
    "learnedOutcomes" text[],
    skills uuid[]
);


ALTER TABLE academy."TopcoderCertification" OWNER TO topcoder;

--
-- TOC entry 369 (class 1259 OID 1363183)
-- Name: TopcoderCertification_id_seq; Type: SEQUENCE; Schema: academy; Owner: topcoder
--

CREATE SEQUENCE academy."TopcoderCertification_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE academy."TopcoderCertification_id_seq" OWNER TO topcoder;

--
-- TOC entry 7775 (class 0 OID 0)
-- Dependencies: 369
-- Name: TopcoderCertification_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."TopcoderCertification_id_seq" OWNED BY academy."TopcoderCertification".id;


--
-- TOC entry 370 (class 1259 OID 1363184)
-- Name: TopcoderUdemyCourse; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."TopcoderUdemyCourse" (
    id integer NOT NULL,
    title text NOT NULL,
    status academy."CourseStatus" DEFAULT 'available'::academy."CourseStatus" NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "removedAt" timestamp(3) without time zone
);


ALTER TABLE academy."TopcoderUdemyCourse" OWNER TO topcoder;

--
-- TOC entry 371 (class 1259 OID 1363190)
-- Name: UdemyCourse; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."UdemyCourse" (
    id integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    headline text NOT NULL,
    url text NOT NULL,
    categories text[],
    topics text[],
    promo_video_url jsonb NOT NULL,
    instructors text[],
    requirements text[],
    what_you_will_learn text[],
    level academy."LearnerLevel" NOT NULL,
    images jsonb NOT NULL,
    locale character varying(6) NOT NULL,
    primary_category character varying(100),
    primary_subcategory character varying(100),
    estimated_content_length integer NOT NULL,
    estimated_content_length_video integer NOT NULL,
    num_lectures integer NOT NULL,
    num_videos integer NOT NULL,
    last_update_date timestamp(3) without time zone NOT NULL,
    data_version timestamp(3) without time zone NOT NULL
);


ALTER TABLE academy."UdemyCourse" OWNER TO topcoder;

--
-- TOC entry 372 (class 1259 OID 1363195)
-- Name: fccCertsModulesLessons; Type: MATERIALIZED VIEW; Schema: academy; Owner: topcoder
--

CREATE MATERIALIZED VIEW academy."fccCertsModulesLessons" AS
 SELECT cert.key AS cert,
    m.key AS module,
    l.id,
    l."dashedName"
   FROM (((academy."FreeCodeCampCertification" cert
     JOIN academy."FccCourses" crs ON ((crs."certificationId" = cert.id)))
     JOIN academy."FccModules" m ON ((m."fccCourseId" = crs.id)))
     JOIN academy."FccLessons" l ON ((l."fccModuleId" = m.id)))
  ORDER BY cert.key, m."order", l."order"
  WITH NO DATA;


ALTER MATERIALIZED VIEW academy."fccCertsModulesLessons" OWNER TO topcoder;

--
-- TOC entry 599 (class 1259 OID 2061240)
-- Name: actions; Type: TABLE; Schema: autopilot; Owner: autopilot
--

CREATE TABLE autopilot.actions (
    id uuid NOT NULL,
    "challengeId" text,
    action text NOT NULL,
    status text DEFAULT 'SUCCESS'::text NOT NULL,
    source text,
    details jsonb,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE autopilot.actions OWNER TO autopilot;

--
-- TOC entry 603 (class 1259 OID 2069922)
-- Name: BillingAccount; Type: TABLE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TABLE "billing-accounts"."BillingAccount" (
    "projectId" text,
    name text NOT NULL,
    description text,
    status "billing-accounts"."BAStatus" DEFAULT 'ACTIVE'::"billing-accounts"."BAStatus" NOT NULL,
    "startDate" timestamp(3) without time zone,
    "endDate" timestamp(3) without time zone,
    budget numeric(20,4) NOT NULL,
    markup numeric(10,4) NOT NULL,
    "clientId" text NOT NULL,
    "poNumber" character varying(255),
    "subscriptionNumber" character varying(255),
    "isManualPrize" boolean DEFAULT false NOT NULL,
    "paymentTerms" character varying(255),
    "salesTax" numeric(10,4),
    billable boolean DEFAULT true NOT NULL,
    "createdBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    id integer NOT NULL
);


ALTER TABLE "billing-accounts"."BillingAccount" OWNER TO billingaccounts;

--
-- TOC entry 606 (class 1259 OID 2069949)
-- Name: BillingAccountAccess; Type: TABLE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TABLE "billing-accounts"."BillingAccountAccess" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "billingAccountId" integer NOT NULL
);


ALTER TABLE "billing-accounts"."BillingAccountAccess" OWNER TO billingaccounts;

--
-- TOC entry 607 (class 1259 OID 2069991)
-- Name: BillingAccount_id_seq; Type: SEQUENCE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE SEQUENCE "billing-accounts"."BillingAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "billing-accounts"."BillingAccount_id_seq" OWNER TO billingaccounts;

--
-- TOC entry 7783 (class 0 OID 0)
-- Dependencies: 607
-- Name: BillingAccount_id_seq; Type: SEQUENCE OWNED BY; Schema: billing-accounts; Owner: billingaccounts
--

ALTER SEQUENCE "billing-accounts"."BillingAccount_id_seq" OWNED BY "billing-accounts"."BillingAccount".id;


--
-- TOC entry 602 (class 1259 OID 2069913)
-- Name: Client; Type: TABLE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TABLE "billing-accounts"."Client" (
    id text NOT NULL,
    name text NOT NULL,
    "codeName" character varying(255),
    status "billing-accounts"."ClientStatus" DEFAULT 'ACTIVE'::"billing-accounts"."ClientStatus" NOT NULL,
    "startDate" timestamp(3) without time zone,
    "endDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE "billing-accounts"."Client" OWNER TO billingaccounts;

--
-- TOC entry 605 (class 1259 OID 2069941)
-- Name: ConsumedAmount; Type: TABLE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TABLE "billing-accounts"."ConsumedAmount" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    amount numeric(20,4) NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "billingAccountId" integer NOT NULL
);


ALTER TABLE "billing-accounts"."ConsumedAmount" OWNER TO billingaccounts;

--
-- TOC entry 604 (class 1259 OID 2069933)
-- Name: LockedAmount; Type: TABLE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TABLE "billing-accounts"."LockedAmount" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    amount numeric(20,4) NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "billingAccountId" integer NOT NULL
);


ALTER TABLE "billing-accounts"."LockedAmount" OWNER TO billingaccounts;

--
-- TOC entry 601 (class 1259 OID 2069892)
-- Name: _prisma_migrations; Type: TABLE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TABLE "billing-accounts"._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE "billing-accounts"._prisma_migrations OWNER TO billingaccounts;

--
-- TOC entry 476 (class 1259 OID 2004945)
-- Name: Attachment; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."Attachment" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    name text NOT NULL,
    "fileSize" integer NOT NULL,
    url text NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."Attachment" OWNER TO challenges;

--
-- TOC entry 475 (class 1259 OID 2004937)
-- Name: AuditLog; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."AuditLog" (
    id text NOT NULL,
    "challengeId" text,
    "fieldName" text NOT NULL,
    "oldValue" text,
    "newValue" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "memberId" text
);


ALTER TABLE challenges."AuditLog" OWNER TO challenges;

--
-- TOC entry 471 (class 1259 OID 2004899)
-- Name: Challenge; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."Challenge" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "privateDescription" text,
    "challengeSource" text,
    "descriptionFormat" text,
    "projectId" integer,
    "typeId" text NOT NULL,
    "trackId" text NOT NULL,
    "timelineTemplateId" text,
    "overviewTotalPrizes" double precision,
    "currentPhaseNames" text[],
    tags text[],
    groups text[],
    "taskIsTask" boolean DEFAULT false NOT NULL,
    "taskIsAssigned" boolean DEFAULT false NOT NULL,
    "taskMemberId" text,
    "submissionStartDate" timestamp(3) without time zone,
    "submissionEndDate" timestamp(3) without time zone,
    "registrationStartDate" timestamp(3) without time zone,
    "registrationEndDate" timestamp(3) without time zone,
    "startDate" timestamp(3) without time zone,
    "endDate" timestamp(3) without time zone,
    "legacyId" integer,
    status challenges."ChallengeStatusEnum" DEFAULT 'NEW'::challenges."ChallengeStatusEnum" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL,
    "wiproAllowed" boolean DEFAULT false NOT NULL,
    "numOfRegistrants" integer DEFAULT 0 NOT NULL,
    "numOfSubmissions" integer DEFAULT 0 NOT NULL,
    "numOfCheckpointSubmissions" integer DEFAULT 0 NOT NULL
);


ALTER TABLE challenges."Challenge" OWNER TO challenges;

--
-- TOC entry 482 (class 1259 OID 2004993)
-- Name: ChallengeBilling; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeBilling" (
    id text NOT NULL,
    "billingAccountId" text,
    markup double precision,
    "clientBillingRate" double precision,
    "challengeId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeBilling" OWNER TO challenges;

--
-- TOC entry 487 (class 1259 OID 2005040)
-- Name: ChallengeConstraint; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeConstraint" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "allowedRegistrants" text[] DEFAULT ARRAY[]::text[],
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeConstraint" OWNER TO challenges;

--
-- TOC entry 485 (class 1259 OID 2005024)
-- Name: ChallengeDiscussion; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeDiscussion" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "discussionId" text,
    name text NOT NULL,
    type challenges."DiscussionTypeEnum" NOT NULL,
    provider text NOT NULL,
    url text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeDiscussion" OWNER TO challenges;

--
-- TOC entry 486 (class 1259 OID 2005032)
-- Name: ChallengeDiscussionOption; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeDiscussionOption" (
    id text NOT NULL,
    "discussionId" text NOT NULL,
    "optionKey" text NOT NULL,
    "optionValue" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeDiscussionOption" OWNER TO challenges;

--
-- TOC entry 484 (class 1259 OID 2005016)
-- Name: ChallengeEvent; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeEvent" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "eventId" integer NOT NULL,
    name text,
    key text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeEvent" OWNER TO challenges;

--
-- TOC entry 483 (class 1259 OID 2005001)
-- Name: ChallengeLegacy; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeLegacy" (
    id text NOT NULL,
    "reviewType" challenges."ReviewTypeEnum" DEFAULT 'INTERNAL'::challenges."ReviewTypeEnum" NOT NULL,
    "confidentialityType" text DEFAULT 'public'::text NOT NULL,
    "forumId" integer,
    "directProjectId" integer,
    "screeningScorecardId" integer,
    "reviewScorecardId" integer,
    "isTask" boolean DEFAULT false NOT NULL,
    "useSchedulingAPI" boolean DEFAULT false NOT NULL,
    "pureV5Task" boolean DEFAULT false NOT NULL,
    "pureV5" boolean DEFAULT false NOT NULL,
    "selfService" boolean DEFAULT false NOT NULL,
    "selfServiceCopilot" text,
    track text,
    "subTrack" text,
    "legacySystemId" integer,
    "challengeId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeLegacy" OWNER TO challenges;

--
-- TOC entry 477 (class 1259 OID 2004953)
-- Name: ChallengeMetadata; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeMetadata" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeMetadata" OWNER TO challenges;

--
-- TOC entry 489 (class 1259 OID 2005057)
-- Name: ChallengePhase; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengePhase" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "phaseId" text NOT NULL,
    name text NOT NULL,
    description text,
    "isOpen" boolean DEFAULT false,
    predecessor text,
    duration integer,
    "scheduledStartDate" timestamp(3) without time zone,
    "scheduledEndDate" timestamp(3) without time zone,
    "actualStartDate" timestamp(3) without time zone,
    "actualEndDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengePhase" OWNER TO challenges;

--
-- TOC entry 490 (class 1259 OID 2005066)
-- Name: ChallengePhaseConstraint; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengePhaseConstraint" (
    id text NOT NULL,
    "challengePhaseId" text NOT NULL,
    name text NOT NULL,
    value integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengePhaseConstraint" OWNER TO challenges;

--
-- TOC entry 491 (class 1259 OID 2005074)
-- Name: ChallengePrizeSet; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengePrizeSet" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    type challenges."PrizeSetTypeEnum" NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengePrizeSet" OWNER TO challenges;

--
-- TOC entry 494 (class 1259 OID 2005251)
-- Name: ChallengeReviewer; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeReviewer" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "scorecardId" text NOT NULL,
    "isMemberReview" boolean NOT NULL,
    "memberReviewerCount" integer,
    "phaseId" text NOT NULL,
    "baseCoefficient" double precision,
    "incrementalCoefficient" double precision,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL,
    type challenges."ReviewOpportunityTypeEnum",
    "aiWorkflowId" character varying(14),
    "shouldOpenOpportunity" boolean DEFAULT true NOT NULL,
    "fixedAmount" double precision DEFAULT 0
);


ALTER TABLE challenges."ChallengeReviewer" OWNER TO challenges;

--
-- TOC entry 481 (class 1259 OID 2004985)
-- Name: ChallengeSkill; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeSkill" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "skillId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeSkill" OWNER TO challenges;

--
-- TOC entry 480 (class 1259 OID 2004977)
-- Name: ChallengeTerm; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeTerm" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "termId" text NOT NULL,
    "roleId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeTerm" OWNER TO challenges;

--
-- TOC entry 474 (class 1259 OID 2004928)
-- Name: ChallengeTimelineTemplate; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeTimelineTemplate" (
    id text NOT NULL,
    "typeId" text NOT NULL,
    "trackId" text NOT NULL,
    "timelineTemplateId" text NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeTimelineTemplate" OWNER TO challenges;

--
-- TOC entry 473 (class 1259 OID 2004920)
-- Name: ChallengeTrack; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeTrack" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "isActive" boolean NOT NULL,
    abbreviation text NOT NULL,
    "legacyId" integer,
    track challenges."ChallengeTrackEnum",
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeTrack" OWNER TO challenges;

--
-- TOC entry 472 (class 1259 OID 2004910)
-- Name: ChallengeType; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeType" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "isActive" boolean DEFAULT true NOT NULL,
    "isTask" boolean DEFAULT false NOT NULL,
    abbreviation text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeType" OWNER TO challenges;

--
-- TOC entry 479 (class 1259 OID 2004969)
-- Name: ChallengeWinner; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."ChallengeWinner" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "userId" integer NOT NULL,
    handle text NOT NULL,
    placement integer NOT NULL,
    type challenges."PrizeSetTypeEnum" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."ChallengeWinner" OWNER TO challenges;

--
-- TOC entry 495 (class 1259 OID 2005293)
-- Name: DefaultChallengeReviewer; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."DefaultChallengeReviewer" (
    id text NOT NULL,
    "typeId" text NOT NULL,
    "trackId" text NOT NULL,
    "scorecardId" text NOT NULL,
    "isMemberReview" boolean NOT NULL,
    "memberReviewerCount" integer,
    "phaseName" text NOT NULL,
    "baseCoefficient" double precision,
    "incrementalCoefficient" double precision,
    "opportunityType" challenges."ReviewOpportunityTypeEnum",
    "isAIReviewer" boolean,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL,
    "phaseId" text,
    "shouldOpenOpportunity" boolean DEFAULT true NOT NULL,
    "fixedAmount" double precision DEFAULT 0,
    "timelineTemplateId" text
);


ALTER TABLE challenges."DefaultChallengeReviewer" OWNER TO challenges;

--
-- TOC entry 498 (class 1259 OID 2015711)
-- Name: Resource; Type: TABLE; Schema: resources; Owner: resources
--

CREATE TABLE resources."Resource" (
    id text NOT NULL,
    "challengeId" text NOT NULL,
    "memberId" text NOT NULL,
    "memberHandle" text NOT NULL,
    "roleId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text,
    "legacyId" integer,
    "phaseChangeNotifications" boolean DEFAULT true
);


ALTER TABLE resources."Resource" OWNER TO resources;

--
-- TOC entry 613 (class 1259 OID 2108454)
-- Name: MemberChallengeAccess; Type: VIEW; Schema: challenges; Owner: challenges
--

CREATE VIEW challenges."MemberChallengeAccess" AS
 SELECT DISTINCT "challengeId",
    "memberId"
   FROM resources."Resource" r
  WHERE (("challengeId" IS NOT NULL) AND ("memberId" IS NOT NULL));


ALTER VIEW challenges."MemberChallengeAccess" OWNER TO challenges;

--
-- TOC entry 488 (class 1259 OID 2005049)
-- Name: Phase; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."Phase" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "isOpen" boolean NOT NULL,
    duration integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."Phase" OWNER TO challenges;

--
-- TOC entry 478 (class 1259 OID 2004961)
-- Name: Prize; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."Prize" (
    id text NOT NULL,
    description text,
    "prizeSetId" text NOT NULL,
    type text NOT NULL,
    value double precision NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."Prize" OWNER TO challenges;

--
-- TOC entry 492 (class 1259 OID 2005082)
-- Name: TimelineTemplate; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."TimelineTemplate" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."TimelineTemplate" OWNER TO challenges;

--
-- TOC entry 493 (class 1259 OID 2005091)
-- Name: TimelineTemplatePhase; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges."TimelineTemplatePhase" (
    id text NOT NULL,
    "timelineTemplateId" text NOT NULL,
    "phaseId" text NOT NULL,
    predecessor text,
    "defaultDuration" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text NOT NULL
);


ALTER TABLE challenges."TimelineTemplatePhase" OWNER TO challenges;

--
-- TOC entry 470 (class 1259 OID 2004828)
-- Name: _prisma_migrations; Type: TABLE; Schema: challenges; Owner: challenges
--

CREATE TABLE challenges._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE challenges._prisma_migrations OWNER TO challenges;

--
-- TOC entry 382 (class 1259 OID 1363875)
-- Name: Emails; Type: TABLE; Schema: emails; Owner: topcoder
--

CREATE TABLE emails."Emails" (
    id bigint NOT NULL,
    topic_name character varying(255),
    data text NOT NULL,
    recipients character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE emails."Emails" OWNER TO topcoder;

--
-- TOC entry 383 (class 1259 OID 1363880)
-- Name: Emails_id_seq; Type: SEQUENCE; Schema: emails; Owner: topcoder
--

CREATE SEQUENCE emails."Emails_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE emails."Emails_id_seq" OWNER TO topcoder;

--
-- TOC entry 7816 (class 0 OID 0)
-- Dependencies: 383
-- Name: Emails_id_seq; Type: SEQUENCE OWNED BY; Schema: emails; Owner: topcoder
--

ALTER SEQUENCE emails."Emails_id_seq" OWNED BY emails."Emails".id;


--
-- TOC entry 306 (class 1259 OID 1334272)
-- Name: _prisma_migrations; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE finance._prisma_migrations OWNER TO finance;

--
-- TOC entry 307 (class 1259 OID 1334517)
-- Name: audit; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.audit (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    winnings_id uuid NOT NULL,
    user_id character varying(80) NOT NULL,
    action character varying(512) NOT NULL,
    note text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE finance.audit OWNER TO finance;

--
-- TOC entry 598 (class 1259 OID 2055330)
-- Name: challenge_lock; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.challenge_lock (
    id integer NOT NULL,
    external_id character varying(255) NOT NULL,
    lock_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    error text
);


ALTER TABLE finance.challenge_lock OWNER TO finance;

--
-- TOC entry 597 (class 1259 OID 2055329)
-- Name: challenge_lock_id_seq; Type: SEQUENCE; Schema: finance; Owner: finance
--

CREATE SEQUENCE finance.challenge_lock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.challenge_lock_id_seq OWNER TO finance;

--
-- TOC entry 7821 (class 0 OID 0)
-- Dependencies: 597
-- Name: challenge_lock_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.challenge_lock_id_seq OWNED BY finance.challenge_lock.id;


--
-- TOC entry 309 (class 1259 OID 1334533)
-- Name: origin; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.origin (
    origin_id integer NOT NULL,
    origin_name character varying(255) NOT NULL
);


ALTER TABLE finance.origin OWNER TO finance;

--
-- TOC entry 308 (class 1259 OID 1334532)
-- Name: origin_origin_id_seq; Type: SEQUENCE; Schema: finance; Owner: finance
--

CREATE SEQUENCE finance.origin_origin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.origin_origin_id_seq OWNER TO finance;

--
-- TOC entry 7823 (class 0 OID 0)
-- Dependencies: 308
-- Name: origin_origin_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.origin_origin_id_seq OWNED BY finance.origin.origin_id;


--
-- TOC entry 310 (class 1259 OID 1334539)
-- Name: otp; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.otp (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    otp_hash character varying(255) NOT NULL,
    expiration_time timestamp(6) without time zone DEFAULT (CURRENT_TIMESTAMP + '00:05:00'::interval) NOT NULL,
    action_type finance.reference_type NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    verified_at timestamp(6) without time zone
);


ALTER TABLE finance.otp OWNER TO finance;

--
-- TOC entry 311 (class 1259 OID 1334550)
-- Name: payment; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.payment (
    payment_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    winnings_id uuid NOT NULL,
    net_amount numeric(12,2),
    gross_amount numeric(12,2),
    total_amount numeric(12,2),
    installment_number integer DEFAULT 1,
    date_paid timestamp(6) without time zone,
    payment_method_id integer,
    currency character varying(5) DEFAULT 'USD'::character varying,
    created_by character varying(80) NOT NULL,
    updated_by character varying(80),
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    version integer DEFAULT 1,
    release_date timestamp(6) without time zone DEFAULT (CURRENT_TIMESTAMP + '15 days'::interval),
    payment_status finance.payment_status,
    billing_account character varying(80) NOT NULL,
    challenge_fee numeric(12,2),
    challenge_markup numeric(12,2)
);


ALTER TABLE finance.payment OWNER TO finance;

--
-- TOC entry 313 (class 1259 OID 1334563)
-- Name: payment_method; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.payment_method (
    payment_method_id integer NOT NULL,
    payment_method_type character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE finance.payment_method OWNER TO finance;

--
-- TOC entry 312 (class 1259 OID 1334562)
-- Name: payment_method_payment_method_id_seq; Type: SEQUENCE; Schema: finance; Owner: finance
--

CREATE SEQUENCE finance.payment_method_payment_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.payment_method_payment_method_id_seq OWNER TO finance;

--
-- TOC entry 7827 (class 0 OID 0)
-- Dependencies: 312
-- Name: payment_method_payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.payment_method_payment_method_id_seq OWNED BY finance.payment_method.payment_method_id;


--
-- TOC entry 314 (class 1259 OID 1334571)
-- Name: payment_release_associations; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.payment_release_associations (
    payment_release_id uuid NOT NULL,
    payment_id uuid NOT NULL
);


ALTER TABLE finance.payment_release_associations OWNER TO finance;

--
-- TOC entry 315 (class 1259 OID 1334576)
-- Name: payment_releases; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.payment_releases (
    payment_release_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id character varying(80) NOT NULL,
    total_net_amount numeric(12,2) NOT NULL,
    payment_method_id integer NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying,
    external_transaction_id character varying(255),
    metadata jsonb,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    payee_id character varying(80),
    release_date timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    batch_id uuid
);


ALTER TABLE finance.payment_releases OWNER TO finance;

--
-- TOC entry 320 (class 1259 OID 1334752)
-- Name: trolley_recipient; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.trolley_recipient (
    id integer NOT NULL,
    user_payment_method_id uuid NOT NULL,
    user_id character varying(80) NOT NULL,
    trolley_id character varying(80) NOT NULL
);


ALTER TABLE finance.trolley_recipient OWNER TO finance;

--
-- TOC entry 319 (class 1259 OID 1334751)
-- Name: trolley_recipient_id_seq; Type: SEQUENCE; Schema: finance; Owner: finance
--

CREATE SEQUENCE finance.trolley_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.trolley_recipient_id_seq OWNER TO finance;

--
-- TOC entry 7831 (class 0 OID 0)
-- Dependencies: 319
-- Name: trolley_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.trolley_recipient_id_seq OWNED BY finance.trolley_recipient.id;


--
-- TOC entry 322 (class 1259 OID 1334779)
-- Name: trolley_recipient_payment_method; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.trolley_recipient_payment_method (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    trolley_recipient_id integer NOT NULL,
    recipient_account_id character varying(80) NOT NULL
);


ALTER TABLE finance.trolley_recipient_payment_method OWNER TO finance;

--
-- TOC entry 318 (class 1259 OID 1334739)
-- Name: trolley_webhook_log; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.trolley_webhook_log (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    event_id text NOT NULL,
    event_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    event_model text,
    event_action text,
    status finance.webhook_status NOT NULL,
    error_message text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    event_payload jsonb NOT NULL
);


ALTER TABLE finance.trolley_webhook_log OWNER TO finance;

--
-- TOC entry 432 (class 1259 OID 1771169)
-- Name: user_identity_verification_associations; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.user_identity_verification_associations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id character varying(80) NOT NULL,
    verification_id text NOT NULL,
    date_filed timestamp(6) without time zone NOT NULL,
    verification_status finance.verification_status NOT NULL
);


ALTER TABLE finance.user_identity_verification_associations OWNER TO finance;

--
-- TOC entry 316 (class 1259 OID 1334633)
-- Name: user_payment_methods; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.user_payment_methods (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id character varying(80) NOT NULL,
    payment_method_id integer NOT NULL,
    status finance.payment_method_status DEFAULT 'OTP_PENDING'::finance.payment_method_status
);


ALTER TABLE finance.user_payment_methods OWNER TO finance;

--
-- TOC entry 321 (class 1259 OID 1334771)
-- Name: user_tax_form_associations; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.user_tax_form_associations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id character varying(80) NOT NULL,
    tax_form_id text NOT NULL,
    date_filed timestamp(6) without time zone NOT NULL,
    tax_form_status finance.tax_form_status NOT NULL
);


ALTER TABLE finance.user_tax_form_associations OWNER TO finance;

--
-- TOC entry 317 (class 1259 OID 1334648)
-- Name: winnings; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.winnings (
    winning_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    winner_id character varying(80) NOT NULL,
    type finance.winnings_type NOT NULL,
    origin_id integer,
    category finance.winnings_category,
    title character varying(255),
    description text,
    external_id character varying(255),
    attributes jsonb,
    created_by character varying(80) NOT NULL,
    updated_by character varying(80),
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finance.winnings OWNER TO finance;

--
-- TOC entry 323 (class 1259 OID 1347861)
-- Name: SequelizeMeta; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE gamification."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 324 (class 1259 OID 1347864)
-- Name: badge_custom_fields; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.badge_custom_fields (
    organization_id uuid NOT NULL,
    field_def_id uuid NOT NULL,
    name character varying NOT NULL,
    value_type character varying NOT NULL,
    text_value text,
    number_value numeric
);


ALTER TABLE gamification.badge_custom_fields OWNER TO topcoder;

--
-- TOC entry 325 (class 1259 OID 1347869)
-- Name: member_badges; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.member_badges (
    user_id bigint NOT NULL,
    org_badge_id uuid NOT NULL,
    awarded_at timestamp with time zone NOT NULL,
    awarded_by character varying NOT NULL,
    user_handle character varying NOT NULL
);


ALTER TABLE gamification.member_badges OWNER TO topcoder;

--
-- TOC entry 326 (class 1259 OID 1347874)
-- Name: organization; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization (
    id uuid NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE gamification.organization OWNER TO topcoder;

--
-- TOC entry 327 (class 1259 OID 1347879)
-- Name: organization_badges; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization_badges (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    badge_status character varying NOT NULL,
    badge_name character varying NOT NULL,
    badge_description text,
    badge_image_url character varying NOT NULL,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE gamification.organization_badges OWNER TO topcoder;

--
-- TOC entry 328 (class 1259 OID 1347885)
-- Name: organization_badges_custom_fields; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization_badges_custom_fields (
    custom_field_id uuid NOT NULL,
    badges_id uuid NOT NULL
);


ALTER TABLE gamification.organization_badges_custom_fields OWNER TO topcoder;

--
-- TOC entry 329 (class 1259 OID 1347888)
-- Name: organization_badges_tags; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization_badges_tags (
    tags_id uuid NOT NULL,
    organization_badges_id uuid NOT NULL
);


ALTER TABLE gamification.organization_badges_tags OWNER TO topcoder;

--
-- TOC entry 330 (class 1259 OID 1347891)
-- Name: tags; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.tags (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    tag_value text NOT NULL
);


ALTER TABLE gamification.tags OWNER TO topcoder;

--
-- TOC entry 609 (class 1259 OID 2070277)
-- Name: Group; Type: TABLE; Schema: groups; Owner: groups
--

CREATE TABLE groups."Group" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "organizationId" text NOT NULL,
    domain text NOT NULL,
    "ssoId" text NOT NULL,
    "oldId" text,
    "privateGroup" boolean NOT NULL,
    "selfRegister" boolean NOT NULL,
    status groups."GroupStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE groups."Group" OWNER TO groups;

--
-- TOC entry 610 (class 1259 OID 2070285)
-- Name: GroupMember; Type: TABLE; Schema: groups; Owner: groups
--

CREATE TABLE groups."GroupMember" (
    id text NOT NULL,
    "groupId" text NOT NULL,
    "memberId" text NOT NULL,
    "membershipType" text NOT NULL,
    roles jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE groups."GroupMember" OWNER TO groups;

--
-- TOC entry 611 (class 1259 OID 2070293)
-- Name: User; Type: TABLE; Schema: groups; Owner: groups
--

CREATE TABLE groups."User" (
    id text NOT NULL,
    "universalUID" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE groups."User" OWNER TO groups;

--
-- TOC entry 612 (class 1259 OID 2070301)
-- Name: _ParentSubGroups; Type: TABLE; Schema: groups; Owner: groups
--

CREATE TABLE groups."_ParentSubGroups" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE groups."_ParentSubGroups" OWNER TO groups;

--
-- TOC entry 608 (class 1259 OID 2070262)
-- Name: _prisma_migrations; Type: TABLE; Schema: groups; Owner: groups
--

CREATE TABLE groups._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE groups._prisma_migrations OWNER TO groups;

--
-- TOC entry 433 (class 1259 OID 1831866)
-- Name: _prisma_migrations; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE identity._prisma_migrations OWNER TO identity;

--
-- TOC entry 436 (class 1259 OID 1831877)
-- Name: achievement_type_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.achievement_type_lu (
    achievement_type_id numeric(5,0) NOT NULL,
    achievement_type_desc character varying(64) NOT NULL
);


ALTER TABLE identity.achievement_type_lu OWNER TO identity;

--
-- TOC entry 464 (class 1259 OID 1832034)
-- Name: client; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.client (
    id integer NOT NULL,
    client_id text NOT NULL,
    name text NOT NULL,
    redirect_uri character varying(8192),
    secret text,
    "createdBy" integer,
    "createdAt" timestamp(0) without time zone,
    "modifiedBy" integer,
    "modifiedAt" timestamp(0) without time zone
);


ALTER TABLE identity.client OWNER TO identity;

--
-- TOC entry 463 (class 1259 OID 1832033)
-- Name: client_id_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.client_id_seq OWNER TO identity;

--
-- TOC entry 7854 (class 0 OID 0)
-- Dependencies: 463
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.client_id_seq OWNED BY identity.client.id;


--
-- TOC entry 437 (class 1259 OID 1831882)
-- Name: country; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.country (
    country_code character varying(3) NOT NULL,
    country_name character varying(40) NOT NULL,
    modify_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    participating numeric(1,0),
    default_taxform_id numeric(10,0),
    longitude numeric(10,7),
    latitude numeric(10,7),
    region character varying(64),
    iso_name character varying(128),
    iso_alpha2_code character varying(2),
    iso_alpha3_code character varying(3)
);


ALTER TABLE identity.country OWNER TO identity;

--
-- TOC entry 439 (class 1259 OID 1831889)
-- Name: dice_connection; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.dice_connection (
    id integer NOT NULL,
    user_id numeric(10,0) NOT NULL,
    connection character varying(50),
    accepted boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    short_url character varying(100),
    con_created_at timestamp(6) without time zone
);


ALTER TABLE identity.dice_connection OWNER TO identity;

--
-- TOC entry 438 (class 1259 OID 1831888)
-- Name: dice_connection_id_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.dice_connection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.dice_connection_id_seq OWNER TO identity;

--
-- TOC entry 7857 (class 0 OID 0)
-- Dependencies: 438
-- Name: dice_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.dice_connection_id_seq OWNED BY identity.dice_connection.id;


--
-- TOC entry 434 (class 1259 OID 1831875)
-- Name: sequence_email_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.sequence_email_seq
    START WITH 70100000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.sequence_email_seq OWNER TO identity;

--
-- TOC entry 440 (class 1259 OID 1831897)
-- Name: email; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.email (
    user_id numeric(10,0),
    email_id numeric(10,0) DEFAULT nextval('identity.sequence_email_seq'::regclass) NOT NULL,
    email_type_id numeric(5,0),
    address character varying(100),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    modify_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    primary_ind numeric(1,0),
    status_id numeric(3,0)
);


ALTER TABLE identity.email OWNER TO identity;

--
-- TOC entry 441 (class 1259 OID 1831905)
-- Name: email_status_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.email_status_lu (
    status_id numeric(3,0) NOT NULL,
    status_desc character varying(100),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    modify_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE identity.email_status_lu OWNER TO identity;

--
-- TOC entry 442 (class 1259 OID 1831912)
-- Name: email_type_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.email_type_lu (
    email_type_id numeric(5,0) NOT NULL,
    email_type_desc character varying(100),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    modify_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE identity.email_type_lu OWNER TO identity;

--
-- TOC entry 443 (class 1259 OID 1831919)
-- Name: id_sequences; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.id_sequences (
    name character varying(254) NOT NULL,
    next_block_start numeric(12,0) NOT NULL,
    block_size numeric(10,0) NOT NULL,
    exhausted numeric(1,0) DEFAULT 0 NOT NULL
);


ALTER TABLE identity.id_sequences OWNER TO identity;

--
-- TOC entry 444 (class 1259 OID 1831925)
-- Name: invalid_handles; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.invalid_handles (
    invalid_handle_id integer NOT NULL,
    invalid_handle character varying(20) NOT NULL
);


ALTER TABLE identity.invalid_handles OWNER TO identity;

--
-- TOC entry 466 (class 1259 OID 1832043)
-- Name: role; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.role (
    id integer NOT NULL,
    name character varying(45) NOT NULL,
    "createdBy" integer,
    "createdAt" timestamp(0) without time zone,
    "modifiedBy" integer,
    "modifiedAt" timestamp(0) without time zone
);


ALTER TABLE identity.role OWNER TO identity;

--
-- TOC entry 468 (class 1259 OID 1832050)
-- Name: role_assignment; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.role_assignment (
    id integer NOT NULL,
    role_id integer NOT NULL,
    subject_id integer NOT NULL,
    "createdBy" integer,
    "createdAt" timestamp(0) without time zone,
    "modifiedBy" integer,
    "modifiedAt" timestamp(0) without time zone,
    subject_type integer DEFAULT 1 NOT NULL
);


ALTER TABLE identity.role_assignment OWNER TO identity;

--
-- TOC entry 467 (class 1259 OID 1832049)
-- Name: role_assignment_id_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.role_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.role_assignment_id_seq OWNER TO identity;

--
-- TOC entry 7865 (class 0 OID 0)
-- Dependencies: 467
-- Name: role_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.role_assignment_id_seq OWNED BY identity.role_assignment.id;


--
-- TOC entry 465 (class 1259 OID 1832042)
-- Name: role_id_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.role_id_seq OWNER TO identity;

--
-- TOC entry 7866 (class 0 OID 0)
-- Dependencies: 465
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.role_id_seq OWNED BY identity.role.id;


--
-- TOC entry 445 (class 1259 OID 1831930)
-- Name: security_groups; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.security_groups (
    group_id numeric(12,0) NOT NULL,
    description character varying(254) NOT NULL,
    challenge_group_ind smallint DEFAULT 0 NOT NULL,
    create_user_id numeric(12,0)
);


ALTER TABLE identity.security_groups OWNER TO identity;

--
-- TOC entry 446 (class 1259 OID 1831936)
-- Name: security_status_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.security_status_lu (
    security_status_id numeric(3,0) NOT NULL,
    status_desc character varying(200)
);


ALTER TABLE identity.security_status_lu OWNER TO identity;

--
-- TOC entry 447 (class 1259 OID 1831941)
-- Name: security_user; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.security_user (
    login_id numeric(12,0) NOT NULL,
    user_id character varying(50) NOT NULL,
    password character varying(300) NOT NULL,
    create_user_id numeric(12,0),
    modify_date timestamp(6) without time zone
);


ALTER TABLE identity.security_user OWNER TO identity;

--
-- TOC entry 469 (class 1259 OID 1832187)
-- Name: sequence_user_group_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.sequence_user_group_seq
    START WITH 88770000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.sequence_user_group_seq OWNER TO identity;

--
-- TOC entry 435 (class 1259 OID 1831876)
-- Name: sequence_user_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.sequence_user_seq
    START WITH 88770000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.sequence_user_seq OWNER TO identity;

--
-- TOC entry 448 (class 1259 OID 1831946)
-- Name: social_login_provider; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.social_login_provider (
    social_login_provider_id numeric(10,0) NOT NULL,
    name character varying(50)
);


ALTER TABLE identity.social_login_provider OWNER TO identity;

--
-- TOC entry 449 (class 1259 OID 1831951)
-- Name: sso_login_provider; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.sso_login_provider (
    sso_login_provider_id numeric(10,0) NOT NULL,
    name character varying(50),
    type character varying(50) NOT NULL,
    identify_email_enabled boolean DEFAULT true NOT NULL,
    identify_handle_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE identity.sso_login_provider OWNER TO identity;

--
-- TOC entry 450 (class 1259 OID 1831958)
-- Name: user; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity."user" (
    user_id numeric(10,0) DEFAULT nextval('identity.sequence_user_seq'::regclass) NOT NULL,
    first_name character varying(64),
    last_name character varying(64),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    modify_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    handle character varying(50) NOT NULL,
    last_login timestamp(6) without time zone,
    status character varying(3) NOT NULL,
    activation_code character varying(32),
    middle_name character varying(64),
    handle_lower character varying(50),
    timezone_id numeric(5,0),
    last_site_hit_date timestamp(6) without time zone,
    name_in_another_language character varying(64),
    password character varying(16),
    open_id character varying(200),
    reg_source character varying(20),
    utm_source character varying(50),
    utm_medium character varying(50),
    utm_campaign character varying(50)
);


ALTER TABLE identity."user" OWNER TO identity;

--
-- TOC entry 452 (class 1259 OID 1831969)
-- Name: user_2fa; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_2fa (
    id integer NOT NULL,
    user_id numeric(10,0) NOT NULL,
    mfa_enabled boolean DEFAULT false NOT NULL,
    dice_enabled boolean DEFAULT false NOT NULL,
    created_by numeric(10,0) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by numeric(10,0) NOT NULL,
    modified_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE identity.user_2fa OWNER TO identity;

--
-- TOC entry 451 (class 1259 OID 1831968)
-- Name: user_2fa_id_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.user_2fa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.user_2fa_id_seq OWNER TO identity;

--
-- TOC entry 7874 (class 0 OID 0)
-- Dependencies: 451
-- Name: user_2fa_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.user_2fa_id_seq OWNED BY identity.user_2fa.id;


--
-- TOC entry 453 (class 1259 OID 1831979)
-- Name: user_achievement; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_achievement (
    user_id numeric(10,0) NOT NULL,
    achievement_date date NOT NULL,
    achievement_type_id numeric(5,0) NOT NULL,
    description character varying(255),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE identity.user_achievement OWNER TO identity;

--
-- TOC entry 462 (class 1259 OID 1832026)
-- Name: user_email_xref; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_email_xref (
    user_id numeric(10,0) NOT NULL,
    email_id numeric(10,0) NOT NULL,
    is_primary boolean NOT NULL,
    status_id numeric(3,0) NOT NULL,
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    modify_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE identity.user_email_xref OWNER TO identity;

--
-- TOC entry 454 (class 1259 OID 1831985)
-- Name: user_group_xref; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_group_xref (
    user_group_id numeric(12,0) DEFAULT nextval('identity.sequence_user_group_seq'::regclass) NOT NULL,
    login_id numeric(12,0),
    group_id numeric(12,0),
    create_user_id numeric(12,0),
    security_status_id numeric(3,0),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE identity.user_group_xref OWNER TO identity;

--
-- TOC entry 456 (class 1259 OID 1831992)
-- Name: user_otp_email; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_otp_email (
    id integer NOT NULL,
    user_id numeric(10,0) NOT NULL,
    mode smallint NOT NULL,
    otp character varying(6) NOT NULL,
    expire_at timestamp(6) without time zone NOT NULL,
    resend boolean DEFAULT false NOT NULL,
    fail_count smallint DEFAULT 0 NOT NULL
);


ALTER TABLE identity.user_otp_email OWNER TO identity;

--
-- TOC entry 455 (class 1259 OID 1831991)
-- Name: user_otp_email_id_seq; Type: SEQUENCE; Schema: identity; Owner: identity
--

CREATE SEQUENCE identity.user_otp_email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identity.user_otp_email_id_seq OWNER TO identity;

--
-- TOC entry 7879 (class 0 OID 0)
-- Dependencies: 455
-- Name: user_otp_email_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.user_otp_email_id_seq OWNED BY identity.user_otp_email.id;


--
-- TOC entry 457 (class 1259 OID 1832000)
-- Name: user_social_login; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_social_login (
    social_user_id character varying(254),
    user_id numeric(10,0) NOT NULL,
    social_login_provider_id numeric(10,0) NOT NULL,
    social_user_name character varying(100) NOT NULL,
    social_email character varying(100),
    social_email_verified boolean,
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    modify_date timestamp(6) without time zone
);


ALTER TABLE identity.user_social_login OWNER TO identity;

--
-- TOC entry 458 (class 1259 OID 1832006)
-- Name: user_sso_login; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_sso_login (
    user_id numeric(10,0) NOT NULL,
    sso_user_id character varying(100) NOT NULL,
    sso_user_name character varying(100),
    provider_id numeric(10,0) NOT NULL,
    email character varying(100)
);


ALTER TABLE identity.user_sso_login OWNER TO identity;

--
-- TOC entry 459 (class 1259 OID 1832011)
-- Name: user_status; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_status (
    user_id numeric(10,0) NOT NULL,
    user_status_type_id numeric(3,0) NOT NULL,
    user_status_id numeric(5,0)
);


ALTER TABLE identity.user_status OWNER TO identity;

--
-- TOC entry 460 (class 1259 OID 1832016)
-- Name: user_status_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_status_lu (
    user_status_id numeric(5,0) NOT NULL,
    description character varying(100)
);


ALTER TABLE identity.user_status_lu OWNER TO identity;

--
-- TOC entry 461 (class 1259 OID 1832021)
-- Name: user_status_type_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_status_type_lu (
    user_status_type_id numeric(3,0) NOT NULL,
    description character varying(100)
);


ALTER TABLE identity.user_status_type_lu OWNER TO identity;

--
-- TOC entry 566 (class 1259 OID 2029892)
-- Name: Country; Type: TABLE; Schema: lookups; Owner: lookups
--

CREATE TABLE lookups."Country" (
    id text NOT NULL,
    name text NOT NULL,
    "countryFlag" text NOT NULL,
    "countryCode" text NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE lookups."Country" OWNER TO lookups;

--
-- TOC entry 567 (class 1259 OID 2029901)
-- Name: Device; Type: TABLE; Schema: lookups; Owner: lookups
--

CREATE TABLE lookups."Device" (
    id text NOT NULL,
    type text NOT NULL,
    manufacturer text NOT NULL,
    model text NOT NULL,
    "operatingSystem" text,
    "operatingSystemVersion" text,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE lookups."Device" OWNER TO lookups;

--
-- TOC entry 568 (class 1259 OID 2029910)
-- Name: EducationalInstitution; Type: TABLE; Schema: lookups; Owner: lookups
--

CREATE TABLE lookups."EducationalInstitution" (
    id text NOT NULL,
    name text NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE lookups."EducationalInstitution" OWNER TO lookups;

--
-- TOC entry 565 (class 1259 OID 2029883)
-- Name: _prisma_migrations; Type: TABLE; Schema: lookups; Owner: lookups
--

CREATE TABLE lookups._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE lookups._prisma_migrations OWNER TO lookups;

--
-- TOC entry 500 (class 1259 OID 2023504)
-- Name: _prisma_migrations; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE members._prisma_migrations OWNER TO members;

--
-- TOC entry 561 (class 1259 OID 2023911)
-- Name: displayMode; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."displayMode" (
    id uuid NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."displayMode" OWNER TO members;

--
-- TOC entry 507 (class 1259 OID 2023626)
-- Name: distributionStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."distributionStats" (
    id bigint NOT NULL,
    track text NOT NULL,
    "subTrack" text NOT NULL,
    "ratingRange0To099" integer NOT NULL,
    "ratingRange100To199" integer NOT NULL,
    "ratingRange200To299" integer NOT NULL,
    "ratingRange300To399" integer NOT NULL,
    "ratingRange400To499" integer NOT NULL,
    "ratingRange500To599" integer NOT NULL,
    "ratingRange600To699" integer NOT NULL,
    "ratingRange700To799" integer NOT NULL,
    "ratingRange800To899" integer NOT NULL,
    "ratingRange900To999" integer NOT NULL,
    "ratingRange1000To1099" integer NOT NULL,
    "ratingRange1100To1199" integer NOT NULL,
    "ratingRange1200To1299" integer NOT NULL,
    "ratingRange1300To1399" integer NOT NULL,
    "ratingRange1400To1499" integer NOT NULL,
    "ratingRange1500To1599" integer NOT NULL,
    "ratingRange1600To1699" integer NOT NULL,
    "ratingRange1700To1799" integer NOT NULL,
    "ratingRange1800To1899" integer NOT NULL,
    "ratingRange1900To1999" integer NOT NULL,
    "ratingRange2000To2099" integer NOT NULL,
    "ratingRange2100To2199" integer NOT NULL,
    "ratingRange2200To2299" integer NOT NULL,
    "ratingRange2300To2399" integer NOT NULL,
    "ratingRange2400To2499" integer NOT NULL,
    "ratingRange2500To2599" integer NOT NULL,
    "ratingRange2600To2699" integer NOT NULL,
    "ratingRange2700To2799" integer NOT NULL,
    "ratingRange2800To2899" integer NOT NULL,
    "ratingRange2900To2999" integer NOT NULL,
    "ratingRange3000To3099" integer NOT NULL,
    "ratingRange3100To3199" integer NOT NULL,
    "ratingRange3200To3299" integer NOT NULL,
    "ratingRange3300To3399" integer NOT NULL,
    "ratingRange3400To3499" integer NOT NULL,
    "ratingRange3500To3599" integer NOT NULL,
    "ratingRange3600To3699" integer NOT NULL,
    "ratingRange3700To3799" integer NOT NULL,
    "ratingRange3800To3899" integer NOT NULL,
    "ratingRange3900To3999" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."distributionStats" OWNER TO members;

--
-- TOC entry 506 (class 1259 OID 2023625)
-- Name: distributionStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."distributionStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."distributionStats_id_seq" OWNER TO members;

--
-- TOC entry 7892 (class 0 OID 0)
-- Dependencies: 506
-- Name: distributionStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."distributionStats_id_seq" OWNED BY members."distributionStats".id;


--
-- TOC entry 501 (class 1259 OID 2023597)
-- Name: member; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members.member (
    "userId" bigint NOT NULL,
    handle text NOT NULL,
    "handleLower" text NOT NULL,
    email text NOT NULL,
    verified boolean,
    "skillScore" double precision,
    "memberRatingId" bigint,
    "firstName" text,
    "lastName" text,
    description text,
    "otherLangName" text,
    status members."MemberStatus",
    "newEmail" text,
    "emailVerifyToken" text,
    "emailVerifyTokenDate" timestamp(3) without time zone,
    "newEmailVerifyToken" text,
    "newEmailVerifyTokenDate" timestamp(3) without time zone,
    "homeCountryCode" text,
    "competitionCountryCode" text,
    "photoURL" text,
    tracks text[],
    "loginCount" integer,
    "lastLoginDate" timestamp(3) without time zone,
    "availableForGigs" boolean,
    "skillScoreDeduction" double precision,
    "namesAndHandleAppearance" text,
    "aggregatedSkills" jsonb,
    "enteredSkills" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text,
    country text
);


ALTER TABLE members.member OWNER TO members;

--
-- TOC entry 503 (class 1259 OID 2023606)
-- Name: memberAddress; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberAddress" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "streetAddr1" text,
    "streetAddr2" text,
    city text,
    zip text,
    "stateCode" text,
    type text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberAddress" OWNER TO members;

--
-- TOC entry 502 (class 1259 OID 2023605)
-- Name: memberAddress_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberAddress_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberAddress_id_seq" OWNER TO members;

--
-- TOC entry 7895 (class 0 OID 0)
-- Dependencies: 502
-- Name: memberAddress_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberAddress_id_seq" OWNED BY members."memberAddress".id;


--
-- TOC entry 518 (class 1259 OID 2023686)
-- Name: memberCopilotStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberCopilotStats" (
    id bigint NOT NULL,
    "memberStatsId" bigint NOT NULL,
    contests integer NOT NULL,
    projects integer NOT NULL,
    failures integer NOT NULL,
    reposts integer NOT NULL,
    "activeContests" integer NOT NULL,
    "activeProjects" integer NOT NULL,
    fulfillment double precision NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberCopilotStats" OWNER TO members;

--
-- TOC entry 517 (class 1259 OID 2023685)
-- Name: memberCopilotStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberCopilotStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberCopilotStats_id_seq" OWNER TO members;

--
-- TOC entry 7897 (class 0 OID 0)
-- Dependencies: 517
-- Name: memberCopilotStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberCopilotStats_id_seq" OWNED BY members."memberCopilotStats".id;


--
-- TOC entry 514 (class 1259 OID 2023665)
-- Name: memberDataScienceHistoryStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDataScienceHistoryStats" (
    id bigint NOT NULL,
    "historyStatsId" bigint NOT NULL,
    "challengeId" bigint NOT NULL,
    "challengeName" text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    rating integer NOT NULL,
    placement integer NOT NULL,
    percentile double precision NOT NULL,
    "subTrack" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text,
    "subTrackId" integer NOT NULL
);


ALTER TABLE members."memberDataScienceHistoryStats" OWNER TO members;

--
-- TOC entry 513 (class 1259 OID 2023664)
-- Name: memberDataScienceHistoryStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDataScienceHistoryStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDataScienceHistoryStats_id_seq" OWNER TO members;

--
-- TOC entry 7899 (class 0 OID 0)
-- Dependencies: 513
-- Name: memberDataScienceHistoryStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDataScienceHistoryStats_id_seq" OWNED BY members."memberDataScienceHistoryStats".id;


--
-- TOC entry 528 (class 1259 OID 2023736)
-- Name: memberDataScienceStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDataScienceStats" (
    id bigint NOT NULL,
    "memberStatsId" bigint NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "mostRecentEventName" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberDataScienceStats" OWNER TO members;

--
-- TOC entry 527 (class 1259 OID 2023735)
-- Name: memberDataScienceStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDataScienceStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDataScienceStats_id_seq" OWNER TO members;

--
-- TOC entry 7901 (class 0 OID 0)
-- Dependencies: 527
-- Name: memberDataScienceStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDataScienceStats_id_seq" OWNED BY members."memberDataScienceStats".id;


--
-- TOC entry 524 (class 1259 OID 2023716)
-- Name: memberDesignStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDesignStats" (
    id bigint NOT NULL,
    "memberStatsId" bigint NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberDesignStats" OWNER TO members;

--
-- TOC entry 526 (class 1259 OID 2023726)
-- Name: memberDesignStatsItem; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDesignStatsItem" (
    id bigint NOT NULL,
    "designStatsId" bigint NOT NULL,
    name text NOT NULL,
    "subTrackId" integer NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "numInquiries" integer NOT NULL,
    submissions integer NOT NULL,
    "passedScreening" integer NOT NULL,
    "avgPlacement" double precision NOT NULL,
    "screeningSuccessRate" double precision NOT NULL,
    "submissionRate" double precision NOT NULL,
    "winPercent" double precision NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberDesignStatsItem" OWNER TO members;

--
-- TOC entry 525 (class 1259 OID 2023725)
-- Name: memberDesignStatsItem_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDesignStatsItem_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDesignStatsItem_id_seq" OWNER TO members;

--
-- TOC entry 7904 (class 0 OID 0)
-- Dependencies: 525
-- Name: memberDesignStatsItem_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDesignStatsItem_id_seq" OWNED BY members."memberDesignStatsItem".id;


--
-- TOC entry 523 (class 1259 OID 2023715)
-- Name: memberDesignStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDesignStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDesignStats_id_seq" OWNER TO members;

--
-- TOC entry 7905 (class 0 OID 0)
-- Dependencies: 523
-- Name: memberDesignStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDesignStats_id_seq" OWNED BY members."memberDesignStats".id;


--
-- TOC entry 512 (class 1259 OID 2023655)
-- Name: memberDevelopHistoryStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDevelopHistoryStats" (
    id bigint NOT NULL,
    "historyStatsId" bigint NOT NULL,
    "challengeId" bigint NOT NULL,
    "challengeName" text NOT NULL,
    "ratingDate" timestamp(3) without time zone NOT NULL,
    "newRating" integer NOT NULL,
    "subTrack" text NOT NULL,
    "subTrackId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberDevelopHistoryStats" OWNER TO members;

--
-- TOC entry 511 (class 1259 OID 2023654)
-- Name: memberDevelopHistoryStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDevelopHistoryStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDevelopHistoryStats_id_seq" OWNER TO members;

--
-- TOC entry 7907 (class 0 OID 0)
-- Dependencies: 511
-- Name: memberDevelopHistoryStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDevelopHistoryStats_id_seq" OWNED BY members."memberDevelopHistoryStats".id;


--
-- TOC entry 520 (class 1259 OID 2023696)
-- Name: memberDevelopStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDevelopStats" (
    id bigint NOT NULL,
    "memberStatsId" bigint NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberDevelopStats" OWNER TO members;

--
-- TOC entry 522 (class 1259 OID 2023706)
-- Name: memberDevelopStatsItem; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberDevelopStatsItem" (
    id bigint NOT NULL,
    "developStatsId" bigint NOT NULL,
    name text NOT NULL,
    "subTrackId" integer NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "numInquiries" bigint,
    submissions bigint,
    "passedScreening" bigint,
    "passedReview" bigint,
    appeals bigint,
    "submissionRate" double precision,
    "screeningSuccessRate" double precision,
    "reviewSuccessRate" double precision,
    "appealSuccessRate" double precision,
    "minScore" double precision,
    "maxScore" double precision,
    "avgScore" double precision,
    "avgPlacement" double precision,
    "winPercent" double precision,
    rating integer,
    "minRating" integer,
    "maxRating" integer,
    volatility integer,
    reliability double precision,
    "overallRank" integer,
    "overallSchoolRank" integer,
    "overallCountryRank" integer,
    "overallPercentile" double precision,
    "activeRank" integer,
    "activeSchoolRank" integer,
    "activeCountryRank" integer,
    "activePercentile" double precision,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberDevelopStatsItem" OWNER TO members;

--
-- TOC entry 521 (class 1259 OID 2023705)
-- Name: memberDevelopStatsItem_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDevelopStatsItem_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDevelopStatsItem_id_seq" OWNER TO members;

--
-- TOC entry 7910 (class 0 OID 0)
-- Dependencies: 521
-- Name: memberDevelopStatsItem_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDevelopStatsItem_id_seq" OWNED BY members."memberDevelopStatsItem".id;


--
-- TOC entry 519 (class 1259 OID 2023695)
-- Name: memberDevelopStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberDevelopStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberDevelopStats_id_seq" OWNER TO members;

--
-- TOC entry 7911 (class 0 OID 0)
-- Dependencies: 519
-- Name: memberDevelopStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDevelopStats_id_seq" OWNED BY members."memberDevelopStats".id;


--
-- TOC entry 508 (class 1259 OID 2023635)
-- Name: memberFinancial; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberFinancial" (
    "userId" bigint NOT NULL,
    amount double precision NOT NULL,
    status members."FinancialStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberFinancial" OWNER TO members;

--
-- TOC entry 510 (class 1259 OID 2023644)
-- Name: memberHistoryStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberHistoryStats" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "groupId" bigint,
    "isPrivate" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberHistoryStats" OWNER TO members;

--
-- TOC entry 509 (class 1259 OID 2023643)
-- Name: memberHistoryStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberHistoryStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberHistoryStats_id_seq" OWNER TO members;

--
-- TOC entry 7914 (class 0 OID 0)
-- Dependencies: 509
-- Name: memberHistoryStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberHistoryStats_id_seq" OWNED BY members."memberHistoryStats".id;


--
-- TOC entry 536 (class 1259 OID 2023776)
-- Name: memberMarathonStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberMarathonStats" (
    id bigint NOT NULL,
    "dataScienceStatsId" bigint NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "mostRecentEventName" text,
    rating integer NOT NULL,
    percentile double precision NOT NULL,
    rank integer NOT NULL,
    "avgRank" double precision NOT NULL,
    "avgNumSubmissions" integer NOT NULL,
    "bestRank" integer NOT NULL,
    "countryRank" integer NOT NULL,
    "schoolRank" integer NOT NULL,
    volatility integer NOT NULL,
    "maximumRating" integer NOT NULL,
    "minimumRating" integer NOT NULL,
    "defaultLanguage" text NOT NULL,
    competitions integer NOT NULL,
    "topFiveFinishes" integer NOT NULL,
    "topTenFinishes" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberMarathonStats" OWNER TO members;

--
-- TOC entry 535 (class 1259 OID 2023775)
-- Name: memberMarathonStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberMarathonStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberMarathonStats_id_seq" OWNER TO members;

--
-- TOC entry 7916 (class 0 OID 0)
-- Dependencies: 535
-- Name: memberMarathonStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberMarathonStats_id_seq" OWNED BY members."memberMarathonStats".id;


--
-- TOC entry 505 (class 1259 OID 2023616)
-- Name: memberMaxRating; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberMaxRating" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    rating integer NOT NULL,
    track text,
    "subTrack" text,
    "ratingColor" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberMaxRating" OWNER TO members;

--
-- TOC entry 504 (class 1259 OID 2023615)
-- Name: memberMaxRating_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberMaxRating_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberMaxRating_id_seq" OWNER TO members;

--
-- TOC entry 7918 (class 0 OID 0)
-- Dependencies: 504
-- Name: memberMaxRating_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberMaxRating_id_seq" OWNED BY members."memberMaxRating".id;


--
-- TOC entry 563 (class 1259 OID 2023927)
-- Name: memberSkill; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberSkill" (
    id uuid NOT NULL,
    "userId" bigint NOT NULL,
    "skillId" uuid NOT NULL,
    "displayModeId" uuid,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberSkill" OWNER TO members;

--
-- TOC entry 564 (class 1259 OID 2023935)
-- Name: memberSkillLevel; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberSkillLevel" (
    "memberSkillId" uuid NOT NULL,
    "skillLevelId" uuid NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberSkillLevel" OWNER TO members;

--
-- TOC entry 532 (class 1259 OID 2023756)
-- Name: memberSrmChallengeDetail; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberSrmChallengeDetail" (
    id bigint NOT NULL,
    "srmStatsId" bigint NOT NULL,
    challenges integer NOT NULL,
    "failedChallenges" integer NOT NULL,
    "levelName" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberSrmChallengeDetail" OWNER TO members;

--
-- TOC entry 531 (class 1259 OID 2023755)
-- Name: memberSrmChallengeDetail_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberSrmChallengeDetail_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberSrmChallengeDetail_id_seq" OWNER TO members;

--
-- TOC entry 7922 (class 0 OID 0)
-- Dependencies: 531
-- Name: memberSrmChallengeDetail_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberSrmChallengeDetail_id_seq" OWNED BY members."memberSrmChallengeDetail".id;


--
-- TOC entry 534 (class 1259 OID 2023766)
-- Name: memberSrmDivisionDetail; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberSrmDivisionDetail" (
    id bigint NOT NULL,
    "srmStatsId" bigint NOT NULL,
    "problemsSubmitted" integer NOT NULL,
    "problemsSysByTest" integer NOT NULL,
    "problemsFailed" integer NOT NULL,
    "levelName" text NOT NULL,
    "divisionName" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberSrmDivisionDetail" OWNER TO members;

--
-- TOC entry 533 (class 1259 OID 2023765)
-- Name: memberSrmDivisionDetail_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberSrmDivisionDetail_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberSrmDivisionDetail_id_seq" OWNER TO members;

--
-- TOC entry 7924 (class 0 OID 0)
-- Dependencies: 533
-- Name: memberSrmDivisionDetail_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberSrmDivisionDetail_id_seq" OWNED BY members."memberSrmDivisionDetail".id;


--
-- TOC entry 530 (class 1259 OID 2023746)
-- Name: memberSrmStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberSrmStats" (
    id bigint NOT NULL,
    "dataScienceStatsId" bigint NOT NULL,
    challenges bigint,
    wins bigint,
    "mostRecentSubmission" timestamp(3) without time zone,
    "mostRecentEventDate" timestamp(3) without time zone,
    "mostRecentEventName" text,
    rating integer NOT NULL,
    percentile double precision NOT NULL,
    rank integer NOT NULL,
    "countryRank" integer NOT NULL,
    "schoolRank" integer NOT NULL,
    volatility integer NOT NULL,
    "maximumRating" integer NOT NULL,
    "minimumRating" integer NOT NULL,
    "defaultLanguage" text NOT NULL,
    competitions integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberSrmStats" OWNER TO members;

--
-- TOC entry 529 (class 1259 OID 2023745)
-- Name: memberSrmStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberSrmStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberSrmStats_id_seq" OWNER TO members;

--
-- TOC entry 7926 (class 0 OID 0)
-- Dependencies: 529
-- Name: memberSrmStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberSrmStats_id_seq" OWNED BY members."memberSrmStats".id;


--
-- TOC entry 516 (class 1259 OID 2023675)
-- Name: memberStats; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberStats" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "memberRatingId" bigint,
    challenges integer,
    wins integer,
    "groupId" bigint,
    "isPrivate" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberStats" OWNER TO members;

--
-- TOC entry 515 (class 1259 OID 2023674)
-- Name: memberStats_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberStats_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberStats_id_seq" OWNER TO members;

--
-- TOC entry 7928 (class 0 OID 0)
-- Dependencies: 515
-- Name: memberStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberStats_id_seq" OWNED BY members."memberStats".id;


--
-- TOC entry 550 (class 1259 OID 2023846)
-- Name: memberTraitBasicInfo; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitBasicInfo" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    country text NOT NULL,
    "primaryInterestInTopcoder" text NOT NULL,
    "tshirtSize" text,
    gender text,
    "shortBio" text NOT NULL,
    "birthDate" timestamp(3) without time zone,
    "currentLocation" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitBasicInfo" OWNER TO members;

--
-- TOC entry 549 (class 1259 OID 2023845)
-- Name: memberTraitBasicInfo_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitBasicInfo_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitBasicInfo_id_seq" OWNER TO members;

--
-- TOC entry 7930 (class 0 OID 0)
-- Dependencies: 549
-- Name: memberTraitBasicInfo_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitBasicInfo_id_seq" OWNED BY members."memberTraitBasicInfo".id;


--
-- TOC entry 558 (class 1259 OID 2023886)
-- Name: memberTraitCommunity; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitCommunity" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    "communityName" text NOT NULL,
    status boolean NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitCommunity" OWNER TO members;

--
-- TOC entry 557 (class 1259 OID 2023885)
-- Name: memberTraitCommunity_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitCommunity_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitCommunity_id_seq" OWNER TO members;

--
-- TOC entry 7932 (class 0 OID 0)
-- Dependencies: 557
-- Name: memberTraitCommunity_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitCommunity_id_seq" OWNED BY members."memberTraitCommunity".id;


--
-- TOC entry 540 (class 1259 OID 2023796)
-- Name: memberTraitDevice; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitDevice" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    "deviceType" members."DeviceType" NOT NULL,
    manufacturer text NOT NULL,
    model text NOT NULL,
    "operatingSystem" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text,
    "osLanguage" text,
    "osVersion" text
);


ALTER TABLE members."memberTraitDevice" OWNER TO members;

--
-- TOC entry 539 (class 1259 OID 2023795)
-- Name: memberTraitDevice_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitDevice_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitDevice_id_seq" OWNER TO members;

--
-- TOC entry 7934 (class 0 OID 0)
-- Dependencies: 539
-- Name: memberTraitDevice_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitDevice_id_seq" OWNED BY members."memberTraitDevice".id;


--
-- TOC entry 548 (class 1259 OID 2023836)
-- Name: memberTraitEducation; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitEducation" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    "collegeName" text NOT NULL,
    degree text NOT NULL,
    "endYear" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitEducation" OWNER TO members;

--
-- TOC entry 547 (class 1259 OID 2023835)
-- Name: memberTraitEducation_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitEducation_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitEducation_id_seq" OWNER TO members;

--
-- TOC entry 7936 (class 0 OID 0)
-- Dependencies: 547
-- Name: memberTraitEducation_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitEducation_id_seq" OWNED BY members."memberTraitEducation".id;


--
-- TOC entry 552 (class 1259 OID 2023856)
-- Name: memberTraitLanguage; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitLanguage" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    language text NOT NULL,
    "spokenLevel" text,
    "writtenLevel" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitLanguage" OWNER TO members;

--
-- TOC entry 551 (class 1259 OID 2023855)
-- Name: memberTraitLanguage_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitLanguage_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitLanguage_id_seq" OWNER TO members;

--
-- TOC entry 7938 (class 0 OID 0)
-- Dependencies: 551
-- Name: memberTraitLanguage_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitLanguage_id_seq" OWNED BY members."memberTraitLanguage".id;


--
-- TOC entry 554 (class 1259 OID 2023866)
-- Name: memberTraitOnboardChecklist; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitOnboardChecklist" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    "listItemType" text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    message text NOT NULL,
    status text NOT NULL,
    metadata jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text,
    skip boolean
);


ALTER TABLE members."memberTraitOnboardChecklist" OWNER TO members;

--
-- TOC entry 553 (class 1259 OID 2023865)
-- Name: memberTraitOnboardChecklist_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitOnboardChecklist_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitOnboardChecklist_id_seq" OWNER TO members;

--
-- TOC entry 7940 (class 0 OID 0)
-- Dependencies: 553
-- Name: memberTraitOnboardChecklist_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitOnboardChecklist_id_seq" OWNED BY members."memberTraitOnboardChecklist".id;


--
-- TOC entry 556 (class 1259 OID 2023876)
-- Name: memberTraitPersonalization; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitPersonalization" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    key text,
    value jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitPersonalization" OWNER TO members;

--
-- TOC entry 555 (class 1259 OID 2023875)
-- Name: memberTraitPersonalization_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitPersonalization_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitPersonalization_id_seq" OWNER TO members;

--
-- TOC entry 7942 (class 0 OID 0)
-- Dependencies: 555
-- Name: memberTraitPersonalization_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitPersonalization_id_seq" OWNED BY members."memberTraitPersonalization".id;


--
-- TOC entry 544 (class 1259 OID 2023816)
-- Name: memberTraitServiceProvider; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitServiceProvider" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    type members."ServiceProviderType" NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitServiceProvider" OWNER TO members;

--
-- TOC entry 543 (class 1259 OID 2023815)
-- Name: memberTraitServiceProvider_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitServiceProvider_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitServiceProvider_id_seq" OWNER TO members;

--
-- TOC entry 7944 (class 0 OID 0)
-- Dependencies: 543
-- Name: memberTraitServiceProvider_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitServiceProvider_id_seq" OWNED BY members."memberTraitServiceProvider".id;


--
-- TOC entry 542 (class 1259 OID 2023806)
-- Name: memberTraitSoftware; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitSoftware" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    "softwareType" members."SoftwareType" NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitSoftware" OWNER TO members;

--
-- TOC entry 541 (class 1259 OID 2023805)
-- Name: memberTraitSoftware_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitSoftware_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitSoftware_id_seq" OWNER TO members;

--
-- TOC entry 7946 (class 0 OID 0)
-- Dependencies: 541
-- Name: memberTraitSoftware_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitSoftware_id_seq" OWNED BY members."memberTraitSoftware".id;


--
-- TOC entry 546 (class 1259 OID 2023826)
-- Name: memberTraitWork; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraitWork" (
    id bigint NOT NULL,
    "memberTraitId" bigint NOT NULL,
    industry members."WorkIndustryType",
    "companyName" text NOT NULL,
    "position" text NOT NULL,
    "startDate" timestamp(3) without time zone,
    "endDate" timestamp(3) without time zone,
    working boolean,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraitWork" OWNER TO members;

--
-- TOC entry 545 (class 1259 OID 2023825)
-- Name: memberTraitWork_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraitWork_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraitWork_id_seq" OWNER TO members;

--
-- TOC entry 7948 (class 0 OID 0)
-- Dependencies: 545
-- Name: memberTraitWork_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitWork_id_seq" OWNED BY members."memberTraitWork".id;


--
-- TOC entry 538 (class 1259 OID 2023786)
-- Name: memberTraits; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."memberTraits" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    subscriptions text[],
    hobby text[],
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."memberTraits" OWNER TO members;

--
-- TOC entry 537 (class 1259 OID 2023785)
-- Name: memberTraits_id_seq; Type: SEQUENCE; Schema: members; Owner: members
--

CREATE SEQUENCE members."memberTraits_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE members."memberTraits_id_seq" OWNER TO members;

--
-- TOC entry 7950 (class 0 OID 0)
-- Dependencies: 537
-- Name: memberTraits_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraits_id_seq" OWNED BY members."memberTraits".id;


--
-- TOC entry 560 (class 1259 OID 2023903)
-- Name: skill; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members.skill (
    id uuid NOT NULL,
    name text NOT NULL,
    "categoryId" uuid NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members.skill OWNER TO members;

--
-- TOC entry 559 (class 1259 OID 2023895)
-- Name: skillCategory; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."skillCategory" (
    id uuid NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."skillCategory" OWNER TO members;

--
-- TOC entry 562 (class 1259 OID 2023919)
-- Name: skillLevel; Type: TABLE; Schema: members; Owner: members
--

CREATE TABLE members."skillLevel" (
    id uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE members."skillLevel" OWNER TO members;

--
-- TOC entry 331 (class 1259 OID 1348140)
-- Name: SequelizeMeta; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE messages."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 332 (class 1259 OID 1348143)
-- Name: email_logs; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages.email_logs (
    id bigint NOT NULL,
    "fromAddress" character varying(255) NOT NULL,
    "toAddress" character varying(500) NOT NULL,
    "ccAddresses" character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "rawText" text NOT NULL,
    "userId" bigint NOT NULL,
    "topicId" bigint NOT NULL,
    "postId" bigint NOT NULL,
    token character varying(500) NOT NULL,
    status character varying(255) NOT NULL
);


ALTER TABLE messages.email_logs OWNER TO topcoder;

--
-- TOC entry 333 (class 1259 OID 1348148)
-- Name: email_logs_id_seq; Type: SEQUENCE; Schema: messages; Owner: topcoder
--

CREATE SEQUENCE messages.email_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE messages.email_logs_id_seq OWNER TO topcoder;

--
-- TOC entry 7956 (class 0 OID 0)
-- Dependencies: 333
-- Name: email_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.email_logs_id_seq OWNED BY messages.email_logs.id;


--
-- TOC entry 334 (class 1259 OID 1348149)
-- Name: post_attachments; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages.post_attachments (
    id bigint NOT NULL,
    "postId" bigint,
    "originalFileName" character varying(512) NOT NULL,
    url character varying(255) NOT NULL,
    "createdBy" character varying(255) NOT NULL,
    "updatedBy" character varying(255) NOT NULL,
    "deletedBy" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE messages.post_attachments OWNER TO topcoder;

--
-- TOC entry 335 (class 1259 OID 1348154)
-- Name: post_attachments_id_seq; Type: SEQUENCE; Schema: messages; Owner: topcoder
--

CREATE SEQUENCE messages.post_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE messages.post_attachments_id_seq OWNER TO topcoder;

--
-- TOC entry 7959 (class 0 OID 0)
-- Dependencies: 335
-- Name: post_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.post_attachments_id_seq OWNED BY messages.post_attachments.id;


--
-- TOC entry 336 (class 1259 OID 1348155)
-- Name: post_user_stats; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages.post_user_stats (
    "postId" bigint NOT NULL,
    action character varying(255) NOT NULL,
    "userIds" character varying(255)[],
    "topicId" bigint NOT NULL
);


ALTER TABLE messages.post_user_stats OWNER TO topcoder;

--
-- TOC entry 337 (class 1259 OID 1348160)
-- Name: posts; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages.posts (
    id bigint NOT NULL,
    raw text NOT NULL,
    cooked text,
    "discoursePostId" bigint,
    "topicId" bigint NOT NULL,
    "postNumber" integer,
    "viaEmail" boolean,
    "rawEmail" text,
    hidden boolean DEFAULT false,
    "hiddenReason" character varying(255),
    "createdAt" timestamp with time zone,
    "createdBy" character varying(255),
    "updatedAt" timestamp with time zone,
    "updatedBy" character varying(255),
    "deletedAt" timestamp with time zone,
    "deletedBy" character varying(255)
);


ALTER TABLE messages.posts OWNER TO topcoder;

--
-- TOC entry 338 (class 1259 OID 1348166)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: messages; Owner: topcoder
--

CREATE SEQUENCE messages.posts_id_seq
    START WITH 80000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE messages.posts_id_seq OWNER TO topcoder;

--
-- TOC entry 7963 (class 0 OID 0)
-- Dependencies: 338
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.posts_id_seq OWNED BY messages.posts.id;


--
-- TOC entry 339 (class 1259 OID 1348167)
-- Name: reference_lookups; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages.reference_lookups (
    reference character varying(255) NOT NULL,
    endpoint character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "accessCondition" character varying(255) NOT NULL
);


ALTER TABLE messages.reference_lookups OWNER TO topcoder;

--
-- TOC entry 340 (class 1259 OID 1348172)
-- Name: topics; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages.topics (
    id bigint NOT NULL,
    reference character varying(255) NOT NULL,
    "referenceId" character varying(255) NOT NULL,
    "discourseTopicId" bigint,
    tag character varying(255),
    "createdAt" timestamp with time zone,
    "createdBy" character varying(255),
    "updatedAt" timestamp with time zone,
    "updatedBy" character varying(255),
    title character varying(255) NOT NULL,
    "highestPostNumber" integer,
    closed boolean DEFAULT false,
    hidden boolean DEFAULT false,
    archived boolean DEFAULT false,
    "hiddenReason" character varying(255),
    "deletedAt" timestamp with time zone,
    "deletedBy" character varying(255),
    tags character varying(255)[]
);


ALTER TABLE messages.topics OWNER TO topcoder;

--
-- TOC entry 341 (class 1259 OID 1348180)
-- Name: topics_id_seq; Type: SEQUENCE; Schema: messages; Owner: topcoder
--

CREATE SEQUENCE messages.topics_id_seq
    START WITH 25000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE messages.topics_id_seq OWNER TO topcoder;

--
-- TOC entry 7967 (class 0 OID 0)
-- Dependencies: 341
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.topics_id_seq OWNED BY messages.topics.id;


--
-- TOC entry 384 (class 1259 OID 1436585)
-- Name: NotificationSettings; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications."NotificationSettings" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "topicOld" character varying(255),
    "serviceId" character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    topic character varying(255)
);


ALTER TABLE notifications."NotificationSettings" OWNER TO topcoder;

--
-- TOC entry 385 (class 1259 OID 1436590)
-- Name: NotificationSettings_id_seq; Type: SEQUENCE; Schema: notifications; Owner: topcoder
--

CREATE SEQUENCE notifications."NotificationSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE notifications."NotificationSettings_id_seq" OWNER TO topcoder;

--
-- TOC entry 7970 (class 0 OID 0)
-- Dependencies: 385
-- Name: NotificationSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."NotificationSettings_id_seq" OWNED BY notifications."NotificationSettings".id;


--
-- TOC entry 386 (class 1259 OID 1436591)
-- Name: Notifications; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications."Notifications" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    type character varying(255) NOT NULL,
    contents jsonb NOT NULL,
    read boolean NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    version smallint,
    seen boolean
);


ALTER TABLE notifications."Notifications" OWNER TO topcoder;

--
-- TOC entry 387 (class 1259 OID 1436596)
-- Name: Notifications_id_seq; Type: SEQUENCE; Schema: notifications; Owner: topcoder
--

CREATE SEQUENCE notifications."Notifications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE notifications."Notifications_id_seq" OWNER TO topcoder;

--
-- TOC entry 7973 (class 0 OID 0)
-- Dependencies: 387
-- Name: Notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."Notifications_id_seq" OWNED BY notifications."Notifications".id;


--
-- TOC entry 388 (class 1259 OID 1436597)
-- Name: ScheduledEvents; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications."ScheduledEvents" (
    id bigint NOT NULL,
    "schedulerId" character varying(255) NOT NULL,
    data json NOT NULL,
    period character varying(255) NOT NULL,
    status notifications."enum_ScheduledEvents_status" NOT NULL,
    "eventType" character varying(255),
    "userId" bigint,
    reference character varying(255),
    "referenceId" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE notifications."ScheduledEvents" OWNER TO topcoder;

--
-- TOC entry 389 (class 1259 OID 1436602)
-- Name: ScheduledEvents_id_seq; Type: SEQUENCE; Schema: notifications; Owner: topcoder
--

CREATE SEQUENCE notifications."ScheduledEvents_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE notifications."ScheduledEvents_id_seq" OWNER TO topcoder;

--
-- TOC entry 7976 (class 0 OID 0)
-- Dependencies: 389
-- Name: ScheduledEvents_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."ScheduledEvents_id_seq" OWNED BY notifications."ScheduledEvents".id;


--
-- TOC entry 390 (class 1259 OID 1436603)
-- Name: ServiceSettings; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications."ServiceSettings" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "serviceId" character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE notifications."ServiceSettings" OWNER TO topcoder;

--
-- TOC entry 391 (class 1259 OID 1436608)
-- Name: ServiceSettings_id_seq; Type: SEQUENCE; Schema: notifications; Owner: topcoder
--

CREATE SEQUENCE notifications."ServiceSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE notifications."ServiceSettings_id_seq" OWNER TO topcoder;

--
-- TOC entry 7979 (class 0 OID 0)
-- Dependencies: 391
-- Name: ServiceSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."ServiceSettings_id_seq" OWNED BY notifications."ServiceSettings".id;


--
-- TOC entry 392 (class 1259 OID 1436609)
-- Name: bk_notifications_20200609; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications.bk_notifications_20200609 (
    id bigint,
    "userId" bigint,
    type character varying(255),
    contents jsonb,
    read boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    version smallint,
    seen boolean
);


ALTER TABLE notifications.bk_notifications_20200609 OWNER TO topcoder;

--
-- TOC entry 393 (class 1259 OID 1436614)
-- Name: bulk_message_user_refs; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications.bulk_message_user_refs (
    id bigint NOT NULL,
    bulk_message_id bigint NOT NULL,
    notification_id bigint,
    user_id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE notifications.bulk_message_user_refs OWNER TO topcoder;

--
-- TOC entry 394 (class 1259 OID 1436617)
-- Name: bulk_message_user_refs_id_seq; Type: SEQUENCE; Schema: notifications; Owner: topcoder
--

CREATE SEQUENCE notifications.bulk_message_user_refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE notifications.bulk_message_user_refs_id_seq OWNER TO topcoder;

--
-- TOC entry 7983 (class 0 OID 0)
-- Dependencies: 394
-- Name: bulk_message_user_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications.bulk_message_user_refs_id_seq OWNED BY notifications.bulk_message_user_refs.id;


--
-- TOC entry 395 (class 1259 OID 1436618)
-- Name: bulk_messages; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications.bulk_messages (
    id bigint NOT NULL,
    type character varying(255) NOT NULL,
    message text NOT NULL,
    recipients jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE notifications.bulk_messages OWNER TO topcoder;

--
-- TOC entry 396 (class 1259 OID 1436623)
-- Name: bulk_messages_id_seq; Type: SEQUENCE; Schema: notifications; Owner: topcoder
--

CREATE SEQUENCE notifications.bulk_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE notifications.bulk_messages_id_seq OWNER TO topcoder;

--
-- TOC entry 7986 (class 0 OID 0)
-- Dependencies: 396
-- Name: bulk_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications.bulk_messages_id_seq OWNED BY notifications.bulk_messages.id;


--
-- TOC entry 397 (class 1259 OID 1436624)
-- Name: tmpbtable; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications.tmpbtable (
    id bigint,
    type character varying(255),
    "userId" bigint
);


ALTER TABLE notifications.tmpbtable OWNER TO topcoder;

--
-- TOC entry 240 (class 1259 OID 1323830)
-- Name: SequelizeMeta; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE projects."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 241 (class 1259 OID 1323833)
-- Name: building_blocks; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.building_blocks (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    config json DEFAULT '{}'::json NOT NULL,
    "privateConfig" json DEFAULT '{}'::json NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.building_blocks OWNER TO topcoder;

--
-- TOC entry 242 (class 1259 OID 1323840)
-- Name: building_blocks_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.building_blocks_id_seq OWNER TO topcoder;

--
-- TOC entry 7991 (class 0 OID 0)
-- Dependencies: 242
-- Name: building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.building_blocks_id_seq OWNED BY projects.building_blocks.id;


--
-- TOC entry 305 (class 1259 OID 1332735)
-- Name: copilot_applications; Type: TABLE; Schema: projects; Owner: projects
--

CREATE TABLE projects.copilot_applications (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "opportunityId" bigint NOT NULL,
    notes text,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    status character varying(16) NOT NULL
);


ALTER TABLE projects.copilot_applications OWNER TO projects;

--
-- TOC entry 304 (class 1259 OID 1332734)
-- Name: copilot_applications_id_seq; Type: SEQUENCE; Schema: projects; Owner: projects
--

CREATE SEQUENCE projects.copilot_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.copilot_applications_id_seq OWNER TO projects;

--
-- TOC entry 7994 (class 0 OID 0)
-- Dependencies: 304
-- Name: copilot_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: projects
--

ALTER SEQUENCE projects.copilot_applications_id_seq OWNED BY projects.copilot_applications.id;


--
-- TOC entry 243 (class 1259 OID 1323841)
-- Name: copilot_opportunities; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.copilot_opportunities (
    id bigint NOT NULL,
    status character varying(16) NOT NULL,
    "projectId" bigint NOT NULL,
    "copilotRequestId" bigint NOT NULL,
    type character varying(16) NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.copilot_opportunities OWNER TO topcoder;

--
-- TOC entry 244 (class 1259 OID 1323844)
-- Name: copilot_opportunities_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.copilot_opportunities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.copilot_opportunities_id_seq OWNER TO topcoder;

--
-- TOC entry 7997 (class 0 OID 0)
-- Dependencies: 244
-- Name: copilot_opportunities_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.copilot_opportunities_id_seq OWNED BY projects.copilot_opportunities.id;


--
-- TOC entry 245 (class 1259 OID 1323845)
-- Name: copilot_requests; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.copilot_requests (
    id bigint NOT NULL,
    data json NOT NULL,
    status character varying(16) NOT NULL,
    "projectId" bigint NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    "copilotOpportunityId" bigint
);


ALTER TABLE projects.copilot_requests OWNER TO topcoder;

--
-- TOC entry 246 (class 1259 OID 1323850)
-- Name: copilot_requests_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.copilot_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.copilot_requests_id_seq OWNER TO topcoder;

--
-- TOC entry 8000 (class 0 OID 0)
-- Dependencies: 246
-- Name: copilot_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.copilot_requests_id_seq OWNED BY projects.copilot_requests.id;


--
-- TOC entry 247 (class 1259 OID 1323851)
-- Name: customer_payments; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.customer_payments (
    id bigint NOT NULL,
    reference character varying(45),
    "referenceId" character varying(255),
    amount integer NOT NULL,
    currency character varying(16) NOT NULL,
    "paymentIntentId" character varying(255) NOT NULL,
    "clientSecret" character varying(255),
    status character varying(64) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE projects.customer_payments OWNER TO topcoder;

--
-- TOC entry 248 (class 1259 OID 1323856)
-- Name: customer_payments_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.customer_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.customer_payments_id_seq OWNER TO topcoder;

--
-- TOC entry 8003 (class 0 OID 0)
-- Dependencies: 248
-- Name: customer_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.customer_payments_id_seq OWNED BY projects.customer_payments.id;


--
-- TOC entry 249 (class 1259 OID 1323857)
-- Name: form; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.form (
    id bigint NOT NULL,
    key character varying(45) NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    revision bigint DEFAULT 1 NOT NULL,
    config json DEFAULT '{}'::json NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.form OWNER TO topcoder;

--
-- TOC entry 250 (class 1259 OID 1323865)
-- Name: form_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.form_id_seq OWNER TO topcoder;

--
-- TOC entry 8006 (class 0 OID 0)
-- Dependencies: 250
-- Name: form_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.form_id_seq OWNED BY projects.form.id;


--
-- TOC entry 251 (class 1259 OID 1323866)
-- Name: milestone_templates; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.milestone_templates (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    duration integer NOT NULL,
    type character varying(45) NOT NULL,
    "order" integer NOT NULL,
    "plannedText" character varying(512) NOT NULL,
    "activeText" character varying(512) NOT NULL,
    "blockedText" character varying(512) NOT NULL,
    "completedText" character varying(512) NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    "referenceId" bigint,
    hidden boolean DEFAULT false,
    reference character varying(45) NOT NULL,
    metadata json NOT NULL
);


ALTER TABLE projects.milestone_templates OWNER TO topcoder;

--
-- TOC entry 252 (class 1259 OID 1323872)
-- Name: milestones; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.milestones (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    duration integer NOT NULL,
    "startDate" timestamp with time zone NOT NULL,
    "endDate" timestamp with time zone,
    "actualStartDate" timestamp with time zone,
    "completionDate" timestamp with time zone,
    status character varying(45) NOT NULL,
    type character varying(45) NOT NULL,
    details json,
    "order" integer NOT NULL,
    "plannedText" character varying(512),
    "activeText" character varying(512),
    "completedText" character varying(512),
    "blockedText" character varying(512),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    "timelineId" bigint,
    hidden boolean DEFAULT false
);


ALTER TABLE projects.milestones OWNER TO topcoder;

--
-- TOC entry 253 (class 1259 OID 1323878)
-- Name: milestones_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.milestones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.milestones_id_seq OWNER TO topcoder;

--
-- TOC entry 8010 (class 0 OID 0)
-- Dependencies: 253
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.milestones_id_seq OWNED BY projects.milestones.id;


--
-- TOC entry 254 (class 1259 OID 1323879)
-- Name: org_config; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.org_config (
    id bigint NOT NULL,
    "orgId" character varying(45) NOT NULL,
    "configName" character varying(45) NOT NULL,
    "configValue" character varying(512),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.org_config OWNER TO topcoder;

--
-- TOC entry 255 (class 1259 OID 1323884)
-- Name: org_config_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.org_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.org_config_id_seq OWNER TO topcoder;

--
-- TOC entry 8013 (class 0 OID 0)
-- Dependencies: 255
-- Name: org_config_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.org_config_id_seq OWNED BY projects.org_config.id;


--
-- TOC entry 256 (class 1259 OID 1323885)
-- Name: phase_products; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.phase_products (
    id bigint NOT NULL,
    name character varying(255),
    "projectId" bigint,
    "directProjectId" bigint,
    "billingAccountId" bigint,
    "templateId" bigint DEFAULT 0,
    type character varying(255),
    "estimatedPrice" double precision DEFAULT 0,
    "actualPrice" double precision DEFAULT 0,
    details json DEFAULT '{}'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "phaseId" bigint
);


ALTER TABLE projects.phase_products OWNER TO topcoder;

--
-- TOC entry 257 (class 1259 OID 1323894)
-- Name: phase_products_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.phase_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.phase_products_id_seq OWNER TO topcoder;

--
-- TOC entry 8016 (class 0 OID 0)
-- Dependencies: 257
-- Name: phase_products_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.phase_products_id_seq OWNED BY projects.phase_products.id;


--
-- TOC entry 258 (class 1259 OID 1323895)
-- Name: phase_work_streams; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.phase_work_streams (
    "workStreamId" bigint NOT NULL,
    "phaseId" bigint NOT NULL
);


ALTER TABLE projects.phase_work_streams OWNER TO topcoder;

--
-- TOC entry 259 (class 1259 OID 1323898)
-- Name: plan_config; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.plan_config (
    id bigint NOT NULL,
    key character varying(45) NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    revision bigint DEFAULT 1 NOT NULL,
    config json DEFAULT '{}'::json NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.plan_config OWNER TO topcoder;

--
-- TOC entry 260 (class 1259 OID 1323906)
-- Name: plan_config_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.plan_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.plan_config_id_seq OWNER TO topcoder;

--
-- TOC entry 8020 (class 0 OID 0)
-- Dependencies: 260
-- Name: plan_config_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.plan_config_id_seq OWNED BY projects.plan_config.id;


--
-- TOC entry 261 (class 1259 OID 1323907)
-- Name: price_config; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.price_config (
    id bigint NOT NULL,
    key character varying(45) NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    revision bigint DEFAULT 1 NOT NULL,
    config json DEFAULT '{}'::json NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.price_config OWNER TO topcoder;

--
-- TOC entry 262 (class 1259 OID 1323915)
-- Name: price_config_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.price_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.price_config_id_seq OWNER TO topcoder;

--
-- TOC entry 8023 (class 0 OID 0)
-- Dependencies: 262
-- Name: price_config_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.price_config_id_seq OWNED BY projects.price_config.id;


--
-- TOC entry 263 (class 1259 OID 1323916)
-- Name: product_categories; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.product_categories (
    key character varying(45) NOT NULL,
    "displayName" character varying(255) NOT NULL,
    icon character varying(255) NOT NULL,
    info character varying(1024) NOT NULL,
    question character varying(255) NOT NULL,
    aliases json NOT NULL,
    hidden boolean DEFAULT false,
    disabled boolean DEFAULT false,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL
);


ALTER TABLE projects.product_categories OWNER TO topcoder;

--
-- TOC entry 264 (class 1259 OID 1323923)
-- Name: product_milestone_templates_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.product_milestone_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.product_milestone_templates_id_seq OWNER TO topcoder;

--
-- TOC entry 8026 (class 0 OID 0)
-- Dependencies: 264
-- Name: product_milestone_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.product_milestone_templates_id_seq OWNED BY projects.milestone_templates.id;


--
-- TOC entry 265 (class 1259 OID 1323924)
-- Name: product_templates; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.product_templates (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    "productKey" character varying(45) NOT NULL,
    icon character varying(255) NOT NULL,
    brief character varying(45) NOT NULL,
    details character varying(255) NOT NULL,
    aliases json NOT NULL,
    template json,
    hidden boolean DEFAULT false,
    disabled boolean DEFAULT false,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    category character varying(45) NOT NULL,
    "subCategory" character varying(45) NOT NULL,
    "isAddOn" boolean DEFAULT false,
    form json
);


ALTER TABLE projects.product_templates OWNER TO topcoder;

--
-- TOC entry 266 (class 1259 OID 1323932)
-- Name: product_templates_backup; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.product_templates_backup (
    id bigint,
    name character varying(255),
    "productKey" character varying(45),
    icon character varying(255),
    brief character varying(45),
    details character varying(255),
    aliases json,
    template json,
    hidden boolean,
    disabled boolean,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint,
    "updatedBy" bigint,
    category character varying(45),
    "subCategory" character varying(45),
    "isAddOn" boolean,
    form json
);


ALTER TABLE projects.product_templates_backup OWNER TO topcoder;

--
-- TOC entry 267 (class 1259 OID 1323937)
-- Name: product_templates_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.product_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.product_templates_id_seq OWNER TO topcoder;

--
-- TOC entry 8030 (class 0 OID 0)
-- Dependencies: 267
-- Name: product_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.product_templates_id_seq OWNED BY projects.product_templates.id;


--
-- TOC entry 268 (class 1259 OID 1323938)
-- Name: project_attachments; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_attachments (
    id bigint NOT NULL,
    title character varying(255),
    size integer,
    category character varying(255),
    description character varying(255),
    path character varying(2048) NOT NULL,
    "contentType" character varying(255),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "projectId" bigint,
    "deletedBy" bigint,
    "allowedUsers" integer[],
    type character varying(255) NOT NULL,
    tags character varying(255)[]
);


ALTER TABLE projects.project_attachments OWNER TO topcoder;

--
-- TOC entry 269 (class 1259 OID 1323943)
-- Name: project_attachments_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_attachments_id_seq OWNER TO topcoder;

--
-- TOC entry 8033 (class 0 OID 0)
-- Dependencies: 269
-- Name: project_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_attachments_id_seq OWNED BY projects.project_attachments.id;


--
-- TOC entry 270 (class 1259 OID 1323944)
-- Name: project_estimation_items_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_estimation_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_estimation_items_id_seq OWNER TO topcoder;

--
-- TOC entry 8035 (class 0 OID 0)
-- Dependencies: 270
-- Name: project_estimation_items_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_estimation_items_id_seq OWNED BY projects.form.id;


--
-- TOC entry 271 (class 1259 OID 1323945)
-- Name: project_estimation_items; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_estimation_items (
    id bigint DEFAULT nextval('projects.project_estimation_items_id_seq'::regclass) NOT NULL,
    "projectEstimationId" bigint NOT NULL,
    price double precision NOT NULL,
    type character varying(255) NOT NULL,
    "markupUsedReference" character varying(255) NOT NULL,
    "markupUsedReferenceId" bigint NOT NULL,
    metadata json DEFAULT '{}'::json NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.project_estimation_items OWNER TO topcoder;

--
-- TOC entry 272 (class 1259 OID 1323952)
-- Name: project_estimations; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_estimations (
    id bigint NOT NULL,
    "buildingBlockKey" character varying(255) NOT NULL,
    conditions character varying(512) NOT NULL,
    price double precision NOT NULL,
    "minTime" integer NOT NULL,
    "maxTime" integer NOT NULL,
    metadata json DEFAULT '{}'::json NOT NULL,
    "projectId" bigint NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    quantity integer DEFAULT 1
);


ALTER TABLE projects.project_estimations OWNER TO topcoder;

--
-- TOC entry 273 (class 1259 OID 1323959)
-- Name: project_estimations_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_estimations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_estimations_id_seq OWNER TO topcoder;

--
-- TOC entry 8039 (class 0 OID 0)
-- Dependencies: 273
-- Name: project_estimations_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_estimations_id_seq OWNED BY projects.project_estimations.id;


--
-- TOC entry 274 (class 1259 OID 1323960)
-- Name: project_history; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_history (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    status character varying(255) NOT NULL,
    "cancelReason" character varying(255),
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "updatedBy" integer NOT NULL
);


ALTER TABLE projects.project_history OWNER TO topcoder;

--
-- TOC entry 275 (class 1259 OID 1323965)
-- Name: project_history_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_history_id_seq OWNER TO topcoder;

--
-- TOC entry 8042 (class 0 OID 0)
-- Dependencies: 275
-- Name: project_history_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_history_id_seq OWNED BY projects.project_history.id;


--
-- TOC entry 276 (class 1259 OID 1323966)
-- Name: project_member_invites; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_member_invites (
    id bigint NOT NULL,
    "projectId" bigint,
    "userId" bigint,
    email character varying(255),
    role character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedAt" timestamp with time zone,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "deletedBy" bigint,
    "applicationId" bigint
);


ALTER TABLE projects.project_member_invites OWNER TO topcoder;

--
-- TOC entry 277 (class 1259 OID 1323971)
-- Name: project_member_invites_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_member_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_member_invites_id_seq OWNER TO topcoder;

--
-- TOC entry 8045 (class 0 OID 0)
-- Dependencies: 277
-- Name: project_member_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_member_invites_id_seq OWNED BY projects.project_member_invites.id;


--
-- TOC entry 278 (class 1259 OID 1323972)
-- Name: project_members; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_members (
    id bigint NOT NULL,
    "userId" bigint,
    role character varying(255) NOT NULL,
    "isPrimary" boolean DEFAULT false NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "projectId" bigint,
    "deletedBy" bigint
);


ALTER TABLE projects.project_members OWNER TO topcoder;

--
-- TOC entry 279 (class 1259 OID 1323976)
-- Name: project_members_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_members_id_seq OWNER TO topcoder;

--
-- TOC entry 8048 (class 0 OID 0)
-- Dependencies: 279
-- Name: project_members_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_members_id_seq OWNED BY projects.project_members.id;


--
-- TOC entry 280 (class 1259 OID 1323977)
-- Name: project_phase_approval_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_phase_approval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_phase_approval_id_seq OWNER TO topcoder;

--
-- TOC entry 281 (class 1259 OID 1323978)
-- Name: project_phase_approval; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_phase_approval (
    id bigint DEFAULT nextval('projects.project_phase_approval_id_seq'::regclass) NOT NULL,
    "phaseId" bigint NOT NULL,
    decision projects.enum_project_phase_approval_decision NOT NULL,
    comment character varying,
    "startDate" timestamp with time zone NOT NULL,
    "endDate" timestamp with time zone,
    "expectedEndDate" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL
);


ALTER TABLE projects.project_phase_approval OWNER TO topcoder;

--
-- TOC entry 282 (class 1259 OID 1323984)
-- Name: project_phase_member_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_phase_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_phase_member_id_seq OWNER TO topcoder;

--
-- TOC entry 283 (class 1259 OID 1323985)
-- Name: project_phase_member; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_phase_member (
    id bigint DEFAULT nextval('projects.project_phase_member_id_seq'::regclass) NOT NULL,
    "userId" bigint NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "phaseId" bigint
);


ALTER TABLE projects.project_phase_member OWNER TO topcoder;

--
-- TOC entry 284 (class 1259 OID 1323989)
-- Name: project_phases; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_phases (
    id bigint NOT NULL,
    name character varying(255),
    status character varying(255),
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    duration integer,
    budget double precision DEFAULT 0,
    "spentBudget" double precision DEFAULT 0,
    progress double precision DEFAULT 0,
    details json DEFAULT '{}'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "projectId" bigint,
    "order" integer,
    description character varying(255),
    requirements text
);


ALTER TABLE projects.project_phases OWNER TO topcoder;

--
-- TOC entry 285 (class 1259 OID 1323998)
-- Name: project_phases_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_phases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_phases_id_seq OWNER TO topcoder;

--
-- TOC entry 8055 (class 0 OID 0)
-- Dependencies: 285
-- Name: project_phases_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_phases_id_seq OWNED BY projects.project_phases.id;


--
-- TOC entry 286 (class 1259 OID 1323999)
-- Name: project_settings; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_settings (
    id bigint NOT NULL,
    key character varying(255),
    value character varying(255),
    "valueType" character varying(255),
    "projectId" bigint NOT NULL,
    metadata json DEFAULT '{}'::json NOT NULL,
    "readPermission" json DEFAULT '{}'::json NOT NULL,
    "writePermission" json DEFAULT '{}'::json NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.project_settings OWNER TO topcoder;

--
-- TOC entry 287 (class 1259 OID 1324007)
-- Name: project_settings_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_settings_id_seq OWNER TO topcoder;

--
-- TOC entry 8058 (class 0 OID 0)
-- Dependencies: 287
-- Name: project_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_settings_id_seq OWNED BY projects.project_settings.id;


--
-- TOC entry 288 (class 1259 OID 1324008)
-- Name: project_templates; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_templates (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(45) NOT NULL,
    category character varying(45) NOT NULL,
    icon character varying(255) NOT NULL,
    question character varying(255) NOT NULL,
    info character varying(1024) NOT NULL,
    aliases json NOT NULL,
    scope json,
    phases json,
    disabled boolean DEFAULT false,
    hidden boolean DEFAULT false,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL,
    "planConfig" json,
    "priceConfig" json,
    form json,
    "subCategory" character varying(45),
    metadata json DEFAULT '{}'::json NOT NULL
);


ALTER TABLE projects.project_templates OWNER TO topcoder;

--
-- TOC entry 289 (class 1259 OID 1324016)
-- Name: project_templates_backup; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_templates_backup (
    id bigint,
    name character varying(255),
    key character varying(45),
    category character varying(45),
    icon character varying(255),
    question character varying(255),
    info character varying(255),
    aliases json,
    scope json,
    phases json,
    disabled boolean,
    hidden boolean,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint,
    "updatedBy" bigint,
    "planConfig" json,
    "priceConfig" json,
    form json
);


ALTER TABLE projects.project_templates_backup OWNER TO topcoder;

--
-- TOC entry 290 (class 1259 OID 1324021)
-- Name: project_templates_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.project_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.project_templates_id_seq OWNER TO topcoder;

--
-- TOC entry 8062 (class 0 OID 0)
-- Dependencies: 290
-- Name: project_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_templates_id_seq OWNED BY projects.project_templates.id;


--
-- TOC entry 291 (class 1259 OID 1324022)
-- Name: project_types; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.project_types (
    key character varying(45) NOT NULL,
    "displayName" character varying(255) NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    icon character varying(255) NOT NULL,
    info character varying(1024) NOT NULL,
    question character varying(255) NOT NULL,
    aliases json NOT NULL,
    hidden boolean DEFAULT false,
    disabled boolean DEFAULT false,
    metadata json NOT NULL
);


ALTER TABLE projects.project_types OWNER TO topcoder;

--
-- TOC entry 292 (class 1259 OID 1324029)
-- Name: projects; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.projects (
    id bigint NOT NULL,
    "directProjectId" bigint,
    "billingAccountId" bigint,
    name character varying(255) NOT NULL,
    description text,
    external json,
    bookmarks json,
    utm json,
    "estimatedPrice" numeric(10,2),
    "actualPrice" numeric(10,2),
    type character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    details json,
    "challengeEligibility" json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "projectFullText" text,
    "cancelReason" character varying(255),
    "templateId" bigint,
    version character varying(3) DEFAULT 'v2'::character varying NOT NULL,
    "deletedBy" bigint,
    "lastActivityAt" timestamp with time zone NOT NULL,
    "lastActivityUserId" character varying(45) NOT NULL,
    terms character varying(255)[] DEFAULT (ARRAY[]::character varying[])::character varying(255)[] NOT NULL,
    groups character varying(255)[] DEFAULT (ARRAY[]::character varying[])::character varying(255)[] NOT NULL
);


ALTER TABLE projects.projects OWNER TO topcoder;

--
-- TOC entry 293 (class 1259 OID 1324037)
-- Name: projects_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.projects_id_seq OWNER TO topcoder;

--
-- TOC entry 8066 (class 0 OID 0)
-- Dependencies: 293
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.projects_id_seq OWNED BY projects.projects.id;


--
-- TOC entry 294 (class 1259 OID 1324038)
-- Name: scope_change_requests; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.scope_change_requests (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "oldScope" json NOT NULL,
    "newScope" json NOT NULL,
    status character varying(45) NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "approvedAt" timestamp with time zone,
    "deletedBy" integer,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL,
    "approvedBy" integer
);


ALTER TABLE projects.scope_change_requests OWNER TO topcoder;

--
-- TOC entry 295 (class 1259 OID 1324043)
-- Name: scope_change_requests_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.scope_change_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.scope_change_requests_id_seq OWNER TO topcoder;

--
-- TOC entry 8069 (class 0 OID 0)
-- Dependencies: 295
-- Name: scope_change_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.scope_change_requests_id_seq OWNED BY projects.scope_change_requests.id;


--
-- TOC entry 296 (class 1259 OID 1324044)
-- Name: status_history; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.status_history (
    id bigint NOT NULL,
    reference character varying(45) NOT NULL,
    "referenceId" bigint NOT NULL,
    status character varying(45) NOT NULL,
    comment text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdBy" integer NOT NULL,
    "updatedBy" integer NOT NULL
);


ALTER TABLE projects.status_history OWNER TO topcoder;

--
-- TOC entry 297 (class 1259 OID 1324049)
-- Name: status_history_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.status_history_id_seq OWNER TO topcoder;

--
-- TOC entry 8072 (class 0 OID 0)
-- Dependencies: 297
-- Name: status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.status_history_id_seq OWNED BY projects.status_history.id;


--
-- TOC entry 298 (class 1259 OID 1324050)
-- Name: timelines; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.timelines (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    "startDate" timestamp with time zone NOT NULL,
    "endDate" timestamp with time zone,
    reference character varying(45) NOT NULL,
    "referenceId" bigint NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.timelines OWNER TO topcoder;

--
-- TOC entry 299 (class 1259 OID 1324055)
-- Name: timelines_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.timelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.timelines_id_seq OWNER TO topcoder;

--
-- TOC entry 8075 (class 0 OID 0)
-- Dependencies: 299
-- Name: timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.timelines_id_seq OWNED BY projects.timelines.id;


--
-- TOC entry 300 (class 1259 OID 1324056)
-- Name: work_management_permissions; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.work_management_permissions (
    id bigint NOT NULL,
    policy character varying(255) NOT NULL,
    permission json NOT NULL,
    "projectTemplateId" bigint NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.work_management_permissions OWNER TO topcoder;

--
-- TOC entry 301 (class 1259 OID 1324061)
-- Name: work_management_permissions_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.work_management_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.work_management_permissions_id_seq OWNER TO topcoder;

--
-- TOC entry 8078 (class 0 OID 0)
-- Dependencies: 301
-- Name: work_management_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.work_management_permissions_id_seq OWNED BY projects.work_management_permissions.id;


--
-- TOC entry 302 (class 1259 OID 1324062)
-- Name: work_streams; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.work_streams (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(45) NOT NULL,
    status character varying(255) NOT NULL,
    "projectId" bigint NOT NULL,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedBy" bigint,
    "createdBy" bigint NOT NULL,
    "updatedBy" bigint NOT NULL
);


ALTER TABLE projects.work_streams OWNER TO topcoder;

--
-- TOC entry 303 (class 1259 OID 1324067)
-- Name: work_streams_id_seq; Type: SEQUENCE; Schema: projects; Owner: topcoder
--

CREATE SEQUENCE projects.work_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE projects.work_streams_id_seq OWNER TO topcoder;

--
-- TOC entry 8081 (class 0 OID 0)
-- Dependencies: 303
-- Name: work_streams_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.work_streams_id_seq OWNED BY projects.work_streams.id;


--
-- TOC entry 497 (class 1259 OID 2015703)
-- Name: ResourceRole; Type: TABLE; Schema: resources; Owner: resources
--

CREATE TABLE resources."ResourceRole" (
    id text NOT NULL,
    name text NOT NULL,
    "nameLower" text NOT NULL,
    "fullReadAccess" boolean NOT NULL,
    "fullWriteAccess" boolean NOT NULL,
    "isActive" boolean NOT NULL,
    "selfObtainable" boolean NOT NULL,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE resources."ResourceRole" OWNER TO resources;

--
-- TOC entry 499 (class 1259 OID 2015719)
-- Name: ResourceRolePhaseDependency; Type: TABLE; Schema: resources; Owner: resources
--

CREATE TABLE resources."ResourceRolePhaseDependency" (
    id text NOT NULL,
    "phaseId" text NOT NULL,
    "resourceRoleId" text NOT NULL,
    "phaseState" boolean NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text NOT NULL,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE resources."ResourceRolePhaseDependency" OWNER TO resources;

--
-- TOC entry 496 (class 1259 OID 2015678)
-- Name: _prisma_migrations; Type: TABLE; Schema: resources; Owner: resources
--

CREATE TABLE resources._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE resources._prisma_migrations OWNER TO resources;

--
-- TOC entry 569 (class 1259 OID 2033637)
-- Name: _prisma_migrations; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE reviews._prisma_migrations OWNER TO reviews;

--
-- TOC entry 591 (class 1259 OID 2034228)
-- Name: aiWorkflow; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."aiWorkflow" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    name character varying NOT NULL,
    "llmId" character varying(14) NOT NULL,
    description text NOT NULL,
    "defUrl" character varying NOT NULL,
    "gitWorkflowId" character varying NOT NULL,
    "gitOwnerRepo" character varying NOT NULL,
    "scorecardId" character varying(14) NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE reviews."aiWorkflow" OWNER TO reviews;

--
-- TOC entry 592 (class 1259 OID 2034237)
-- Name: aiWorkflowRun; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."aiWorkflowRun" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "workflowId" character varying(14) NOT NULL,
    "submissionId" character varying(14) NOT NULL,
    "startedAt" timestamp(3) without time zone,
    "completedAt" timestamp(3) without time zone,
    "gitRunId" character varying NOT NULL,
    score double precision,
    status character varying NOT NULL,
    "scheduledJobId" text,
    usage jsonb,
    "completedJobs" integer DEFAULT 0,
    "jobsCount" integer DEFAULT 0,
    "gitRunUrl" text
);


ALTER TABLE reviews."aiWorkflowRun" OWNER TO reviews;

--
-- TOC entry 593 (class 1259 OID 2034245)
-- Name: aiWorkflowRunItem; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."aiWorkflowRunItem" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "workflowRunId" character varying(14) NOT NULL,
    "scorecardQuestionId" character varying(14) NOT NULL,
    content text NOT NULL,
    "upVotes" integer DEFAULT 0 NOT NULL,
    "downVotes" integer DEFAULT 0 NOT NULL,
    "questionScore" double precision,
    "createdAt" timestamp(3) without time zone NOT NULL,
    "createdBy" text
);


ALTER TABLE reviews."aiWorkflowRunItem" OWNER TO reviews;

--
-- TOC entry 594 (class 1259 OID 2034255)
-- Name: aiWorkflowRunItemComment; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."aiWorkflowRunItemComment" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "workflowRunItemId" character varying(14) NOT NULL,
    "userId" text NOT NULL,
    content text NOT NULL,
    "parentId" character varying(14),
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "downVotes" integer DEFAULT 0 NOT NULL,
    "upVotes" integer DEFAULT 0 NOT NULL
);


ALTER TABLE reviews."aiWorkflowRunItemComment" OWNER TO reviews;

--
-- TOC entry 577 (class 1259 OID 2033798)
-- Name: appeal; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews.appeal (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "resourceId" text NOT NULL,
    "reviewItemCommentId" text NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text
);


ALTER TABLE reviews.appeal OWNER TO reviews;

--
-- TOC entry 578 (class 1259 OID 2033807)
-- Name: appealResponse; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."appealResponse" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "appealId" text NOT NULL,
    "resourceId" text NOT NULL,
    content text NOT NULL,
    success boolean NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text
);


ALTER TABLE reviews."appealResponse" OWNER TO reviews;

--
-- TOC entry 579 (class 1259 OID 2033816)
-- Name: challengeResult; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."challengeResult" (
    "challengeId" text NOT NULL,
    "userId" text NOT NULL,
    "paymentId" text,
    "submissionId" text NOT NULL,
    "oldRating" integer,
    "newRating" integer,
    "initialScore" double precision NOT NULL,
    "finalScore" double precision NOT NULL,
    placement integer NOT NULL,
    rated boolean NOT NULL,
    "passedReview" boolean NOT NULL,
    "validSubmission" boolean NOT NULL,
    "pointAdjustment" double precision,
    "ratingOrder" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE reviews."challengeResult" OWNER TO reviews;

--
-- TOC entry 580 (class 1259 OID 2033824)
-- Name: contactRequest; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."contactRequest" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "resourceId" text NOT NULL,
    "challengeId" text NOT NULL,
    message text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE reviews."contactRequest" OWNER TO reviews;

--
-- TOC entry 588 (class 1259 OID 2034192)
-- Name: gitWebhookLog; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."gitWebhookLog" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "eventId" text NOT NULL,
    event text NOT NULL,
    "eventPayload" jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE reviews."gitWebhookLog" OWNER TO reviews;

--
-- TOC entry 590 (class 1259 OID 2034219)
-- Name: llmModel; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."llmModel" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "providerId" character varying(14) NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    icon character varying,
    url character varying,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text
);


ALTER TABLE reviews."llmModel" OWNER TO reviews;

--
-- TOC entry 589 (class 1259 OID 2034211)
-- Name: llmProvider; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."llmProvider" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    name character varying NOT NULL,
    "createdAt" timestamp(3) without time zone NOT NULL,
    "createdBy" text
);


ALTER TABLE reviews."llmProvider" OWNER TO reviews;

--
-- TOC entry 587 (class 1259 OID 2034153)
-- Name: resourceSubmission; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."resourceSubmission" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "resourceId" text NOT NULL,
    "submissionId" text,
    "legacySubmissionId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE reviews."resourceSubmission" OWNER TO reviews;

--
-- TOC entry 574 (class 1259 OID 2033769)
-- Name: review; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews.review (
    id character varying(36) DEFAULT gen_random_uuid() NOT NULL,
    "resourceId" text NOT NULL,
    "phaseId" text NOT NULL,
    "submissionId" character varying(14),
    "scorecardId" text NOT NULL,
    committed boolean DEFAULT false NOT NULL,
    "finalScore" double precision,
    "initialScore" double precision,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text,
    metadata jsonb,
    "typeId" text,
    "reviewDate" timestamp(3) without time zone,
    "legacySubmissionId" text,
    status reviews."ReviewStatus"
);


ALTER TABLE reviews.review OWNER TO reviews;

--
-- TOC entry 582 (class 1259 OID 2033995)
-- Name: reviewApplication; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewApplication" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "userId" text NOT NULL,
    handle text NOT NULL,
    "opportunityId" text NOT NULL,
    role reviews."ReviewApplicationRole" NOT NULL,
    status reviews."ReviewApplicationStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE reviews."reviewApplication" OWNER TO reviews;

--
-- TOC entry 595 (class 1259 OID 2034332)
-- Name: reviewAudit; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewAudit" (
    id character varying(36) DEFAULT gen_random_uuid() NOT NULL,
    "reviewId" character varying(36) NOT NULL,
    "submissionId" character varying(14),
    "challengeId" text,
    "actorId" text NOT NULL,
    description text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE reviews."reviewAudit" OWNER TO reviews;

--
-- TOC entry 575 (class 1259 OID 2033779)
-- Name: reviewItem; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewItem" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "reviewId" text NOT NULL,
    "scorecardQuestionId" text NOT NULL,
    "uploadId" text,
    "initialAnswer" text NOT NULL,
    "finalAnswer" text,
    "managerComment" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text
);


ALTER TABLE reviews."reviewItem" OWNER TO reviews;

--
-- TOC entry 576 (class 1259 OID 2033788)
-- Name: reviewItemComment; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewItemComment" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "resourceId" text NOT NULL,
    "reviewItemId" text NOT NULL,
    content text NOT NULL,
    type reviews."ReviewItemCommentType" NOT NULL,
    "sortOrder" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text
);


ALTER TABLE reviews."reviewItemComment" OWNER TO reviews;

--
-- TOC entry 581 (class 1259 OID 2033985)
-- Name: reviewOpportunity; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewOpportunity" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "challengeId" text NOT NULL,
    status reviews."ReviewOpportunityStatus" NOT NULL,
    type reviews."ReviewOpportunityType" NOT NULL,
    "openPositions" integer NOT NULL,
    "startDate" timestamp(3) without time zone NOT NULL,
    duration integer NOT NULL,
    "basePayment" double precision NOT NULL,
    "incrementalPayment" double precision NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text
);


ALTER TABLE reviews."reviewOpportunity" OWNER TO reviews;

--
-- TOC entry 584 (class 1259 OID 2034035)
-- Name: reviewSummation; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewSummation" (
    id character varying(36) DEFAULT gen_random_uuid() NOT NULL,
    "submissionId" character varying(14) NOT NULL,
    "aggregateScore" double precision NOT NULL,
    "scorecardId" text,
    "isPassing" boolean NOT NULL,
    "isFinal" boolean,
    "reviewedDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacySubmissionId" text,
    "scorecardLegacyId" text,
    "isProvisional" boolean,
    "isExample" boolean,
    metadata jsonb
);


ALTER TABLE reviews."reviewSummation" OWNER TO reviews;

--
-- TOC entry 583 (class 1259 OID 2034027)
-- Name: reviewType; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewType" (
    id character varying(36) DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "isActive" boolean NOT NULL
);


ALTER TABLE reviews."reviewType" OWNER TO reviews;

--
-- TOC entry 600 (class 1259 OID 2066966)
-- Name: review_pending_summary; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews.review_pending_summary (
    "resourceId" text NOT NULL,
    "pendingAppealCount" integer NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE reviews.review_pending_summary OWNER TO reviews;

--
-- TOC entry 570 (class 1259 OID 2033684)
-- Name: scorecard; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews.scorecard (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "challengeTrack" reviews."ChallengeTrack" NOT NULL,
    "challengeType" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "maxScore" double precision NOT NULL,
    "minScore" double precision NOT NULL,
    name text NOT NULL,
    status reviews."ScorecardStatus" NOT NULL,
    type reviews."ScorecardType" NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    version text NOT NULL,
    "legacyId" text,
    "minimumPassingScore" double precision DEFAULT 0 NOT NULL
);


ALTER TABLE reviews.scorecard OWNER TO reviews;

--
-- TOC entry 571 (class 1259 OID 2033742)
-- Name: scorecardGroup; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."scorecardGroup" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "scorecardId" text NOT NULL,
    name text NOT NULL,
    weight double precision NOT NULL,
    "sortOrder" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text
);


ALTER TABLE reviews."scorecardGroup" OWNER TO reviews;

--
-- TOC entry 573 (class 1259 OID 2033760)
-- Name: scorecardQuestion; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."scorecardQuestion" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "scorecardSectionId" text NOT NULL,
    type reviews."QuestionType" NOT NULL,
    description text NOT NULL,
    guidelines text NOT NULL,
    weight double precision NOT NULL,
    "requiresUpload" boolean NOT NULL,
    "sortOrder" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "scaleMin" integer,
    "scaleMax" integer,
    "legacyId" text
);


ALTER TABLE reviews."scorecardQuestion" OWNER TO reviews;

--
-- TOC entry 572 (class 1259 OID 2033751)
-- Name: scorecardSection; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."scorecardSection" (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "scorecardGroupId" text NOT NULL,
    name text NOT NULL,
    weight double precision NOT NULL,
    "sortOrder" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedBy" text,
    "legacyId" text
);


ALTER TABLE reviews."scorecardSection" OWNER TO reviews;

--
-- TOC entry 585 (class 1259 OID 2034044)
-- Name: submission; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews.submission (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    url text,
    "memberId" text,
    "challengeId" text,
    "legacySubmissionId" text,
    "legacyUploadId" text,
    "submissionPhaseId" text,
    "submittedDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text,
    "esId" uuid,
    "fileSize" integer,
    "fileType" text,
    "finalScore" numeric(65,30),
    "initialScore" numeric(65,30),
    "legacyChallengeId" bigint,
    "markForPurchase" boolean,
    placement integer,
    "prizeId" bigint,
    "screeningScore" numeric(65,30),
    status reviews."SubmissionStatus" NOT NULL,
    "systemFileName" text,
    "thurgoodJobId" text,
    "uploadId" character varying(14),
    "userRank" integer,
    "viewCount" integer,
    type reviews."SubmissionType" NOT NULL,
    "virusScan" boolean DEFAULT false NOT NULL,
    "isFileSubmission" boolean DEFAULT false NOT NULL
);


ALTER TABLE reviews.submission OWNER TO reviews;

--
-- TOC entry 596 (class 1259 OID 2034355)
-- Name: submissionAccessAudit; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."submissionAccessAudit" (
    id character varying(36) DEFAULT gen_random_uuid() NOT NULL,
    "submissionId" character varying(14) NOT NULL,
    "downloadedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    handle text NOT NULL
);


ALTER TABLE reviews."submissionAccessAudit" OWNER TO reviews;

--
-- TOC entry 586 (class 1259 OID 2034144)
-- Name: upload; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews.upload (
    id character varying(14) DEFAULT reviews.nanoid() NOT NULL,
    "legacyId" text,
    "projectId" text NOT NULL,
    "resourceId" text NOT NULL,
    type reviews."UploadType" NOT NULL,
    status reviews."UploadStatus" NOT NULL,
    parameter text,
    url text,
    "desc" text,
    "projectPhaseId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" text,
    "updatedAt" timestamp(3) without time zone,
    "updatedBy" text
);


ALTER TABLE reviews.upload OWNER TO reviews;

--
-- TOC entry 410 (class 1259 OID 1477130)
-- Name: SequelizeMeta; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE skills."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 411 (class 1259 OID 1477133)
-- Name: event; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.event (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    topic character varying(255) NOT NULL,
    payload jsonb NOT NULL,
    payload_hash text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE skills.event OWNER TO topcoder;

--
-- TOC entry 412 (class 1259 OID 1477139)
-- Name: legacy_skill_map; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.legacy_skill_map (
    legacy_v5_id uuid NOT NULL,
    skill_id uuid NOT NULL
);


ALTER TABLE skills.legacy_skill_map OWNER TO topcoder;

--
-- TOC entry 413 (class 1259 OID 1477142)
-- Name: prod_challenge_emsi_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_challenge_emsi_skills (
    emsi_skill_id uuid NOT NULL,
    challenge_id uuid NOT NULL
);


ALTER TABLE skills.prod_challenge_emsi_skills OWNER TO topcoder;

--
-- TOC entry 414 (class 1259 OID 1477145)
-- Name: prod_job_emsi_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_job_emsi_skills (
    emsi_skill_id uuid NOT NULL,
    job_id uuid NOT NULL
);


ALTER TABLE skills.prod_job_emsi_skills OWNER TO topcoder;

--
-- TOC entry 415 (class 1259 OID 1477148)
-- Name: prod_user_emsi_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_user_emsi_skills (
    user_id integer NOT NULL,
    skill_id uuid NOT NULL,
    skill_source_ids uuid[] NOT NULL,
    std_skill_id uuid,
    emsi_id text
);


ALTER TABLE skills.prod_user_emsi_skills OWNER TO topcoder;

--
-- TOC entry 416 (class 1259 OID 1477153)
-- Name: prod_v5_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_v5_skills (
    id uuid NOT NULL,
    name character varying(255),
    std_skill_id uuid
);


ALTER TABLE skills.prod_v5_skills OWNER TO topcoder;

--
-- TOC entry 417 (class 1259 OID 1477156)
-- Name: skill; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    category_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    dev_id uuid
);


ALTER TABLE skills.skill OWNER TO topcoder;

--
-- TOC entry 418 (class 1259 OID 1477164)
-- Name: skill_category; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill_category (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE skills.skill_category OWNER TO topcoder;

--
-- TOC entry 419 (class 1259 OID 1477172)
-- Name: skill_event; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill_event (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    event_id uuid NOT NULL,
    user_id integer NOT NULL,
    skill_id uuid NOT NULL,
    skill_event_type_id uuid NOT NULL,
    source_id uuid NOT NULL,
    source_type_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE skills.skill_event OWNER TO topcoder;

--
-- TOC entry 420 (class 1259 OID 1477176)
-- Name: skill_event_type; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill_event_type (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE skills.skill_event_type OWNER TO topcoder;

--
-- TOC entry 421 (class 1259 OID 1477182)
-- Name: skill_replacement; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill_replacement (
    skill_id uuid NOT NULL,
    replacing_skill_id uuid NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE skills.skill_replacement OWNER TO topcoder;

--
-- TOC entry 422 (class 1259 OID 1477187)
-- Name: skill_to_emsi_skill_map; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill_to_emsi_skill_map (
    skill_id uuid NOT NULL,
    emsi_skill_id uuid,
    emsi_id text
);


ALTER TABLE skills.skill_to_emsi_skill_map OWNER TO topcoder;

--
-- TOC entry 423 (class 1259 OID 1477192)
-- Name: source_type; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.source_type (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE skills.source_type OWNER TO topcoder;

--
-- TOC entry 424 (class 1259 OID 1477198)
-- Name: user_skill; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.user_skill (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    skill_id uuid NOT NULL,
    user_skill_level_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_skill_display_mode_id uuid DEFAULT '1555aa05-a764-4f0b-b3e0-51b824382abb'::uuid NOT NULL
);


ALTER TABLE skills.user_skill OWNER TO topcoder;

--
-- TOC entry 425 (class 1259 OID 1477205)
-- Name: user_skill_display_mode; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.user_skill_display_mode (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE skills.user_skill_display_mode OWNER TO topcoder;

--
-- TOC entry 426 (class 1259 OID 1477210)
-- Name: user_skill_level; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.user_skill_level (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE skills.user_skill_level OWNER TO topcoder;

--
-- TOC entry 427 (class 1259 OID 1477216)
-- Name: vw_all_skills_with_category; Type: VIEW; Schema: skills; Owner: topcoder
--

CREATE VIEW skills.vw_all_skills_with_category AS
 SELECT sk.id AS skill_id,
    sk.name AS skill_name,
    sk.description,
    sk.category_id,
    cat.name AS category_name
   FROM (skills.skill sk
     JOIN skills.skill_category cat ON ((cat.id = sk.category_id)))
  WHERE (sk.deleted_at IS NULL)
  ORDER BY cat.name, sk.name;


ALTER VIEW skills.vw_all_skills_with_category OWNER TO topcoder;

--
-- TOC entry 428 (class 1259 OID 1477221)
-- Name: vw_skill_to_emsi_map; Type: VIEW; Schema: skills; Owner: topcoder
--

CREATE VIEW skills.vw_skill_to_emsi_map AS
 SELECT esm.emsi_id,
    esm.emsi_skill_id,
    esm.skill_id AS id,
    sk.name,
    sk.category_id,
    cat.name AS category_name
   FROM ((skills.skill_to_emsi_skill_map esm
     JOIN skills.skill sk ON ((sk.id = esm.skill_id)))
     JOIN skills.skill_category cat ON ((cat.id = sk.category_id)));


ALTER VIEW skills.vw_skill_to_emsi_map OWNER TO topcoder;

--
-- TOC entry 429 (class 1259 OID 1477226)
-- Name: vw_user_AI_skill_counts; Type: VIEW; Schema: skills; Owner: topcoder
--

CREATE VIEW skills."vw_user_AI_skill_counts" AS
 SELECT cat.name AS skill_category,
    usl.name AS skill_level,
    count(DISTINCT us.user_id) AS num_users
   FROM (((skills.user_skill us
     JOIN skills.user_skill_level usl ON ((usl.id = us.user_skill_level_id)))
     JOIN skills.skill sk ON ((sk.id = us.skill_id)))
     JOIN skills.skill_category cat ON ((cat.id = sk.category_id)))
  WHERE ((cat.name)::text = 'Machine Learning and AI'::text)
  GROUP BY cat.name, usl.name;


ALTER VIEW skills."vw_user_AI_skill_counts" OWNER TO topcoder;

--
-- TOC entry 430 (class 1259 OID 1477231)
-- Name: vw_v5_skill_to_std_skill_map; Type: VIEW; Schema: skills; Owner: topcoder
--

CREATE VIEW skills.vw_v5_skill_to_std_skill_map AS
 SELECT pv5s.id AS v5_skill_id,
    lsm.skill_id AS standardized_skill_id
   FROM (skills.prod_v5_skills pv5s
     JOIN skills.legacy_skill_map lsm ON ((lsm.legacy_v5_id = pv5s.id)));


ALTER VIEW skills.vw_v5_skill_to_std_skill_map OWNER TO topcoder;

--
-- TOC entry 431 (class 1259 OID 1477235)
-- Name: work_skill; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.work_skill (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    work_id uuid NOT NULL,
    work_type_id uuid NOT NULL,
    skill_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE skills.work_skill OWNER TO topcoder;

--
-- TOC entry 409 (class 1259 OID 1475979)
-- Name: SequelizeMeta; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE taas."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 398 (class 1259 OID 1475457)
-- Name: interviews; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.interviews (
    id uuid NOT NULL,
    job_candidate_id uuid NOT NULL,
    round integer NOT NULL,
    start_timestamp timestamp with time zone,
    status taas.enum_interviews_status NOT NULL,
    created_by text NOT NULL,
    updated_by text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    duration integer,
    end_timestamp timestamp with time zone,
    nylas_page_id character varying(255) NOT NULL,
    nylas_page_slug character varying(255) NOT NULL,
    nylas_calendar_id character varying(255) NOT NULL,
    host_timezone character varying(255) NOT NULL,
    "availableTime" jsonb NOT NULL,
    "hostUserId" text NOT NULL,
    "expireTimestamp" timestamp with time zone,
    nylas_event_id character varying(255) DEFAULT NULL::character varying,
    nylas_event_edit_hash character varying(255) DEFAULT NULL::character varying,
    guest_timezone character varying(255),
    zoom_account_api_key character varying(255),
    zoom_meeting_id bigint
);


ALTER TABLE taas.interviews OWNER TO topcoder;

--
-- TOC entry 399 (class 1259 OID 1475464)
-- Name: job_candidates; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.job_candidates (
    id uuid NOT NULL,
    job_id uuid NOT NULL,
    user_id text NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    created_by text NOT NULL,
    updated_at timestamp with time zone,
    updated_by text,
    deleted_at timestamp with time zone,
    external_id character varying(255),
    resume character varying(2048),
    remark character varying(255),
    viewed_by_customer boolean DEFAULT false NOT NULL
);


ALTER TABLE taas.job_candidates OWNER TO topcoder;

--
-- TOC entry 400 (class 1259 OID 1475470)
-- Name: jobs; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.jobs (
    id uuid NOT NULL,
    project_id integer NOT NULL,
    external_id character varying(255),
    description text,
    start_date date,
    num_positions integer NOT NULL,
    resource_type character varying(255),
    rate_type character varying(255),
    skills jsonb NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    created_by text NOT NULL,
    updated_at timestamp with time zone,
    updated_by text,
    deleted_at timestamp with time zone,
    title character varying(128) NOT NULL,
    workload character varying(45),
    duration integer,
    is_application_page_active boolean DEFAULT false NOT NULL,
    role_ids uuid[],
    min_salary integer,
    max_salary integer,
    hours_per_week integer,
    job_location character varying(255),
    job_timezone character varying(128),
    currency character varying(30),
    show_in_hot_list boolean DEFAULT false,
    featured boolean DEFAULT false,
    hot_list_excerpt character varying(255) DEFAULT ''::character varying,
    job_tag character varying(30) DEFAULT ''::character varying,
    rcrm_status character varying(255) DEFAULT NULL::character varying,
    rcrm_reason character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE taas.jobs OWNER TO topcoder;

--
-- TOC entry 401 (class 1259 OID 1475482)
-- Name: legacy_skill_map; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.legacy_skill_map (
    legacy_v5_id uuid NOT NULL,
    skill_id uuid NOT NULL
);


ALTER TABLE taas.legacy_skill_map OWNER TO topcoder;

--
-- TOC entry 402 (class 1259 OID 1475485)
-- Name: payment_schedulers; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.payment_schedulers (
    id uuid NOT NULL,
    challenge_id uuid NOT NULL,
    work_period_payment_id uuid NOT NULL,
    step taas.enum_payment_schedulers_step,
    status taas.enum_payment_schedulers_status NOT NULL,
    user_id bigint,
    user_handle character varying(255) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE taas.payment_schedulers OWNER TO topcoder;

--
-- TOC entry 403 (class 1259 OID 1475488)
-- Name: resource_bookings; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.resource_bookings (
    id uuid NOT NULL,
    project_id integer NOT NULL,
    user_id text NOT NULL,
    job_id uuid,
    status character varying(255) NOT NULL,
    start_date date,
    end_date date,
    member_rate double precision,
    customer_rate double precision,
    rate_type character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    created_by text NOT NULL,
    updated_at timestamp with time zone,
    updated_by text,
    deleted_at timestamp with time zone,
    billing_account_id bigint,
    send_weekly_survey boolean DEFAULT true NOT NULL
);


ALTER TABLE taas.resource_bookings OWNER TO topcoder;

--
-- TOC entry 404 (class 1259 OID 1475494)
-- Name: role_search_requests; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.role_search_requests (
    id uuid NOT NULL,
    member_id text,
    previous_role_search_request_id uuid,
    role_id uuid,
    job_description character varying(100000),
    skills uuid[],
    created_by text NOT NULL,
    updated_by text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    job_title character varying(100)
);


ALTER TABLE taas.role_search_requests OWNER TO topcoder;

--
-- TOC entry 405 (class 1259 OID 1475499)
-- Name: roles; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.roles (
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(1000),
    list_of_skills character varying(50)[],
    rates jsonb[] NOT NULL,
    number_of_members numeric,
    number_of_members_available smallint,
    image_url character varying(255),
    time_to_candidate smallint,
    time_to_interview smallint,
    created_by text NOT NULL,
    updated_by text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE taas.roles OWNER TO topcoder;

--
-- TOC entry 406 (class 1259 OID 1475504)
-- Name: user_meeting_settings; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.user_meeting_settings (
    id uuid NOT NULL,
    "defaultAvailableTime" jsonb NOT NULL,
    "defaultTimezone" character varying(255),
    "nylasCalendars" jsonb,
    created_by text NOT NULL,
    updated_by text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE taas.user_meeting_settings OWNER TO topcoder;

--
-- TOC entry 407 (class 1259 OID 1475509)
-- Name: work_period_payments; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.work_period_payments (
    id uuid NOT NULL,
    work_period_id uuid NOT NULL,
    challenge_id uuid,
    amount double precision NOT NULL,
    status taas.enum_work_period_payments_status NOT NULL,
    created_by text NOT NULL,
    updated_by text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    billing_account_id bigint NOT NULL,
    status_details jsonb,
    member_rate double precision NOT NULL,
    customer_rate double precision,
    days integer NOT NULL
);


ALTER TABLE taas.work_period_payments OWNER TO topcoder;

--
-- TOC entry 408 (class 1259 OID 1475514)
-- Name: work_periods; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.work_periods (
    id uuid NOT NULL,
    resource_booking_id uuid NOT NULL,
    user_handle character varying(50) NOT NULL,
    project_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    days_worked integer NOT NULL,
    payment_status character varying(50) NOT NULL,
    created_by text NOT NULL,
    updated_by text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    days_paid integer NOT NULL,
    payment_total double precision NOT NULL,
    sent_survey boolean DEFAULT false NOT NULL,
    sent_survey_error jsonb
);


ALTER TABLE taas.work_periods OWNER TO topcoder;

--
-- TOC entry 373 (class 1259 OID 1363445)
-- Name: DocusignEnvelope; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."DocusignEnvelope" (
    id character varying(255) NOT NULL,
    "docusignTemplateId" character varying(255) NOT NULL,
    "userId" bigint NOT NULL,
    "isCompleted" bigint NOT NULL
);


ALTER TABLE terms."DocusignEnvelope" OWNER TO topcoder;

--
-- TOC entry 374 (class 1259 OID 1363450)
-- Name: TermsForResource; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsForResource" (
    id character varying(255) NOT NULL,
    reference character varying(255) NOT NULL,
    "referenceId" character varying(255) NOT NULL,
    tag character varying(255) NOT NULL,
    "termsOfUseIds" uuid[] NOT NULL,
    created timestamp with time zone NOT NULL,
    "createdBy" character varying(255) NOT NULL,
    updated timestamp with time zone,
    "updatedBy" character varying(255)
);


ALTER TABLE terms."TermsForResource" OWNER TO topcoder;

--
-- TOC entry 375 (class 1259 OID 1363455)
-- Name: TermsOfUse; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUse" (
    id uuid NOT NULL,
    "legacyId" bigint,
    text text,
    "typeId" bigint NOT NULL,
    title character varying(255) NOT NULL,
    url character varying(255),
    "agreeabilityTypeId" uuid DEFAULT '2c78f834-61f4-11ea-bd4f-3c15c2e2c206'::uuid NOT NULL,
    created timestamp with time zone NOT NULL,
    "createdBy" character varying(255),
    updated timestamp with time zone,
    "updatedBy" character varying(255),
    "deletedAt" timestamp with time zone
);


ALTER TABLE terms."TermsOfUse" OWNER TO topcoder;

--
-- TOC entry 376 (class 1259 OID 1363461)
-- Name: TermsOfUseAgreeabilityType; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseAgreeabilityType" (
    id uuid NOT NULL,
    "legacyId" bigint,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL
);


ALTER TABLE terms."TermsOfUseAgreeabilityType" OWNER TO topcoder;

--
-- TOC entry 377 (class 1259 OID 1363466)
-- Name: TermsOfUseDependency; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseDependency" (
    "dependencyTermsOfUseId" uuid NOT NULL,
    "dependentTermsOfUseId" uuid NOT NULL
);


ALTER TABLE terms."TermsOfUseDependency" OWNER TO topcoder;

--
-- TOC entry 378 (class 1259 OID 1363469)
-- Name: TermsOfUseDocusignTemplateXref; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseDocusignTemplateXref" (
    "termsOfUseId" uuid NOT NULL,
    "docusignTemplateId" character varying(255) NOT NULL
);


ALTER TABLE terms."TermsOfUseDocusignTemplateXref" OWNER TO topcoder;

--
-- TOC entry 379 (class 1259 OID 1363472)
-- Name: TermsOfUseType; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseType" (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE terms."TermsOfUseType" OWNER TO topcoder;

--
-- TOC entry 380 (class 1259 OID 1363475)
-- Name: UserTermsOfUseBanXref; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."UserTermsOfUseBanXref" (
    "userId" bigint NOT NULL,
    "termsOfUseId" uuid NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE terms."UserTermsOfUseBanXref" OWNER TO topcoder;

--
-- TOC entry 381 (class 1259 OID 1363478)
-- Name: UserTermsOfUseXref; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."UserTermsOfUseXref" (
    "userId" bigint NOT NULL,
    "termsOfUseId" uuid NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE terms."UserTermsOfUseXref" OWNER TO topcoder;

--
-- TOC entry 342 (class 1259 OID 1352761)
-- Name: events; Type: TABLE; Schema: timeline; Owner: topcoder
--

CREATE TABLE timeline.events (
    id integer NOT NULL,
    title character varying(38) NOT NULL,
    description character varying(240) NOT NULL,
    event_date timestamp with time zone NOT NULL,
    media_files json[],
    status timeline."event-status" NOT NULL,
    rejection_reason character varying(38),
    rejection_note character varying(240),
    created_date timestamp with time zone NOT NULL,
    created_by character varying(100) NOT NULL,
    last_updated_date timestamp with time zone NOT NULL,
    last_updated_by character varying(100) NOT NULL
);


ALTER TABLE timeline.events OWNER TO topcoder;

--
-- TOC entry 343 (class 1259 OID 1352766)
-- Name: events_id_seq; Type: SEQUENCE; Schema: timeline; Owner: topcoder
--

CREATE SEQUENCE timeline.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE timeline.events_id_seq OWNER TO topcoder;

--
-- TOC entry 8159 (class 0 OID 0)
-- Dependencies: 343
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: timeline; Owner: topcoder
--

ALTER SEQUENCE timeline.events_id_seq OWNED BY timeline.events.id;


--
-- TOC entry 5762 (class 2604 OID 1363202)
-- Name: CertificationCategory id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationCategory" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationCategory_id_seq"'::regclass);


--
-- TOC entry 5763 (class 2604 OID 1363203)
-- Name: CertificationEnrollments id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationEnrollments" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationEnrollments_id_seq"'::regclass);


--
-- TOC entry 5765 (class 2604 OID 1363204)
-- Name: CertificationResource id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResource" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationResource_id_seq"'::regclass);


--
-- TOC entry 5766 (class 2604 OID 1363205)
-- Name: CertificationResourceProgresses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResourceProgresses" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationResourceProgresses_id_seq"'::regclass);


--
-- TOC entry 5768 (class 2604 OID 1363206)
-- Name: FccCertificationProgresses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCertificationProgresses" ALTER COLUMN id SET DEFAULT nextval('academy."FccCertificationProgresses_id_seq"'::regclass);


--
-- TOC entry 5769 (class 2604 OID 1363207)
-- Name: FccCourses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCourses" ALTER COLUMN id SET DEFAULT nextval('academy."FccCourses_id_seq"'::regclass);


--
-- TOC entry 5772 (class 2604 OID 1363208)
-- Name: FccModuleProgresses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModuleProgresses" ALTER COLUMN id SET DEFAULT nextval('academy."FccModuleProgresses_id_seq"'::regclass);


--
-- TOC entry 5774 (class 2604 OID 1363209)
-- Name: FccModules id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModules" ALTER COLUMN id SET DEFAULT nextval('academy."FccModules_id_seq"'::regclass);


--
-- TOC entry 5776 (class 2604 OID 1363210)
-- Name: FreeCodeCampCertification id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FreeCodeCampCertification" ALTER COLUMN id SET DEFAULT nextval('academy."FreeCodeCampCertification_id_seq"'::regclass);


--
-- TOC entry 5780 (class 2604 OID 1363211)
-- Name: ResourceProvider id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."ResourceProvider" ALTER COLUMN id SET DEFAULT nextval('academy."ResourceProvider_id_seq"'::regclass);


--
-- TOC entry 5781 (class 2604 OID 1363212)
-- Name: TopcoderCertification id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."TopcoderCertification" ALTER COLUMN id SET DEFAULT nextval('academy."TopcoderCertification_id_seq"'::regclass);


--
-- TOC entry 6072 (class 2604 OID 2069992)
-- Name: BillingAccount id; Type: DEFAULT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."BillingAccount" ALTER COLUMN id SET DEFAULT nextval('"billing-accounts"."BillingAccount_id_seq"'::regclass);


--
-- TOC entry 5786 (class 2604 OID 1363881)
-- Name: Emails id; Type: DEFAULT; Schema: emails; Owner: topcoder
--

ALTER TABLE ONLY emails."Emails" ALTER COLUMN id SET DEFAULT nextval('emails."Emails_id_seq"'::regclass);


--
-- TOC entry 6059 (class 2604 OID 2055333)
-- Name: challenge_lock id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.challenge_lock ALTER COLUMN id SET DEFAULT nextval('finance.challenge_lock_id_seq'::regclass);


--
-- TOC entry 5724 (class 2604 OID 1334536)
-- Name: origin origin_id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.origin ALTER COLUMN origin_id SET DEFAULT nextval('finance.origin_origin_id_seq'::regclass);


--
-- TOC entry 5736 (class 2604 OID 1334566)
-- Name: payment_method payment_method_id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_method ALTER COLUMN payment_method_id SET DEFAULT nextval('finance.payment_method_payment_method_id_seq'::regclass);


--
-- TOC entry 5749 (class 2604 OID 1334755)
-- Name: trolley_recipient id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_recipient ALTER COLUMN id SET DEFAULT nextval('finance.trolley_recipient_id_seq'::regclass);


--
-- TOC entry 5860 (class 2604 OID 1832037)
-- Name: client id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.client ALTER COLUMN id SET DEFAULT nextval('identity.client_id_seq'::regclass);


--
-- TOC entry 5829 (class 2604 OID 1831892)
-- Name: dice_connection id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.dice_connection ALTER COLUMN id SET DEFAULT nextval('identity.dice_connection_id_seq'::regclass);


--
-- TOC entry 5861 (class 2604 OID 1832046)
-- Name: role id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role ALTER COLUMN id SET DEFAULT nextval('identity.role_id_seq'::regclass);


--
-- TOC entry 5862 (class 2604 OID 1832053)
-- Name: role_assignment id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role_assignment ALTER COLUMN id SET DEFAULT nextval('identity.role_assignment_id_seq'::regclass);


--
-- TOC entry 5846 (class 2604 OID 1831972)
-- Name: user_2fa id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_2fa ALTER COLUMN id SET DEFAULT nextval('identity.user_2fa_id_seq'::regclass);


--
-- TOC entry 5854 (class 2604 OID 1831995)
-- Name: user_otp_email id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_otp_email ALTER COLUMN id SET DEFAULT nextval('identity.user_otp_email_id_seq'::regclass);


--
-- TOC entry 5928 (class 2604 OID 2023629)
-- Name: distributionStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."distributionStats" ALTER COLUMN id SET DEFAULT nextval('members."distributionStats_id_seq"'::regclass);


--
-- TOC entry 5924 (class 2604 OID 2023609)
-- Name: memberAddress id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberAddress" ALTER COLUMN id SET DEFAULT nextval('members."memberAddress_id_seq"'::regclass);


--
-- TOC entry 5941 (class 2604 OID 2023689)
-- Name: memberCopilotStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberCopilotStats" ALTER COLUMN id SET DEFAULT nextval('members."memberCopilotStats_id_seq"'::regclass);


--
-- TOC entry 5936 (class 2604 OID 2023668)
-- Name: memberDataScienceHistoryStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceHistoryStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDataScienceHistoryStats_id_seq"'::regclass);


--
-- TOC entry 5951 (class 2604 OID 2023739)
-- Name: memberDataScienceStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDataScienceStats_id_seq"'::regclass);


--
-- TOC entry 5947 (class 2604 OID 2023719)
-- Name: memberDesignStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDesignStats_id_seq"'::regclass);


--
-- TOC entry 5949 (class 2604 OID 2023729)
-- Name: memberDesignStatsItem id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStatsItem" ALTER COLUMN id SET DEFAULT nextval('members."memberDesignStatsItem_id_seq"'::regclass);


--
-- TOC entry 5934 (class 2604 OID 2023658)
-- Name: memberDevelopHistoryStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopHistoryStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDevelopHistoryStats_id_seq"'::regclass);


--
-- TOC entry 5943 (class 2604 OID 2023699)
-- Name: memberDevelopStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDevelopStats_id_seq"'::regclass);


--
-- TOC entry 5945 (class 2604 OID 2023709)
-- Name: memberDevelopStatsItem id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStatsItem" ALTER COLUMN id SET DEFAULT nextval('members."memberDevelopStatsItem_id_seq"'::regclass);


--
-- TOC entry 5931 (class 2604 OID 2023647)
-- Name: memberHistoryStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberHistoryStats" ALTER COLUMN id SET DEFAULT nextval('members."memberHistoryStats_id_seq"'::regclass);


--
-- TOC entry 5959 (class 2604 OID 2023779)
-- Name: memberMarathonStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMarathonStats" ALTER COLUMN id SET DEFAULT nextval('members."memberMarathonStats_id_seq"'::regclass);


--
-- TOC entry 5926 (class 2604 OID 2023619)
-- Name: memberMaxRating id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMaxRating" ALTER COLUMN id SET DEFAULT nextval('members."memberMaxRating_id_seq"'::regclass);


--
-- TOC entry 5955 (class 2604 OID 2023759)
-- Name: memberSrmChallengeDetail id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmChallengeDetail" ALTER COLUMN id SET DEFAULT nextval('members."memberSrmChallengeDetail_id_seq"'::regclass);


--
-- TOC entry 5957 (class 2604 OID 2023769)
-- Name: memberSrmDivisionDetail id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmDivisionDetail" ALTER COLUMN id SET DEFAULT nextval('members."memberSrmDivisionDetail_id_seq"'::regclass);


--
-- TOC entry 5953 (class 2604 OID 2023749)
-- Name: memberSrmStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmStats" ALTER COLUMN id SET DEFAULT nextval('members."memberSrmStats_id_seq"'::regclass);


--
-- TOC entry 5938 (class 2604 OID 2023678)
-- Name: memberStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberStats" ALTER COLUMN id SET DEFAULT nextval('members."memberStats_id_seq"'::regclass);


--
-- TOC entry 5973 (class 2604 OID 2023849)
-- Name: memberTraitBasicInfo id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitBasicInfo" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitBasicInfo_id_seq"'::regclass);


--
-- TOC entry 5981 (class 2604 OID 2023889)
-- Name: memberTraitCommunity id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitCommunity" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitCommunity_id_seq"'::regclass);


--
-- TOC entry 5963 (class 2604 OID 2023799)
-- Name: memberTraitDevice id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitDevice" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitDevice_id_seq"'::regclass);


--
-- TOC entry 5971 (class 2604 OID 2023839)
-- Name: memberTraitEducation id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitEducation" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitEducation_id_seq"'::regclass);


--
-- TOC entry 5975 (class 2604 OID 2023859)
-- Name: memberTraitLanguage id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitLanguage" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitLanguage_id_seq"'::regclass);


--
-- TOC entry 5977 (class 2604 OID 2023869)
-- Name: memberTraitOnboardChecklist id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitOnboardChecklist" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitOnboardChecklist_id_seq"'::regclass);


--
-- TOC entry 5979 (class 2604 OID 2023879)
-- Name: memberTraitPersonalization id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitPersonalization" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitPersonalization_id_seq"'::regclass);


--
-- TOC entry 5967 (class 2604 OID 2023819)
-- Name: memberTraitServiceProvider id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitServiceProvider" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitServiceProvider_id_seq"'::regclass);


--
-- TOC entry 5965 (class 2604 OID 2023809)
-- Name: memberTraitSoftware id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitSoftware" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitSoftware_id_seq"'::regclass);


--
-- TOC entry 5969 (class 2604 OID 2023829)
-- Name: memberTraitWork id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitWork" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitWork_id_seq"'::regclass);


--
-- TOC entry 5961 (class 2604 OID 2023789)
-- Name: memberTraits id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraits" ALTER COLUMN id SET DEFAULT nextval('members."memberTraits_id_seq"'::regclass);


--
-- TOC entry 5753 (class 2604 OID 1348181)
-- Name: email_logs id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.email_logs ALTER COLUMN id SET DEFAULT nextval('messages.email_logs_id_seq'::regclass);


--
-- TOC entry 5754 (class 2604 OID 1348182)
-- Name: post_attachments id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.post_attachments ALTER COLUMN id SET DEFAULT nextval('messages.post_attachments_id_seq'::regclass);


--
-- TOC entry 5755 (class 2604 OID 1348183)
-- Name: posts id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.posts ALTER COLUMN id SET DEFAULT nextval('messages.posts_id_seq'::regclass);


--
-- TOC entry 5757 (class 2604 OID 1348184)
-- Name: topics id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.topics ALTER COLUMN id SET DEFAULT nextval('messages.topics_id_seq'::regclass);


--
-- TOC entry 5787 (class 2604 OID 1436627)
-- Name: NotificationSettings id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."NotificationSettings" ALTER COLUMN id SET DEFAULT nextval('notifications."NotificationSettings_id_seq"'::regclass);


--
-- TOC entry 5788 (class 2604 OID 1436628)
-- Name: Notifications id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."Notifications" ALTER COLUMN id SET DEFAULT nextval('notifications."Notifications_id_seq"'::regclass);


--
-- TOC entry 5789 (class 2604 OID 1436629)
-- Name: ScheduledEvents id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."ScheduledEvents" ALTER COLUMN id SET DEFAULT nextval('notifications."ScheduledEvents_id_seq"'::regclass);


--
-- TOC entry 5790 (class 2604 OID 1436630)
-- Name: ServiceSettings id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."ServiceSettings" ALTER COLUMN id SET DEFAULT nextval('notifications."ServiceSettings_id_seq"'::regclass);


--
-- TOC entry 5791 (class 2604 OID 1436631)
-- Name: bulk_message_user_refs id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_message_user_refs ALTER COLUMN id SET DEFAULT nextval('notifications.bulk_message_user_refs_id_seq'::regclass);


--
-- TOC entry 5792 (class 2604 OID 1436632)
-- Name: bulk_messages id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_messages ALTER COLUMN id SET DEFAULT nextval('notifications.bulk_messages_id_seq'::regclass);


--
-- TOC entry 5649 (class 2604 OID 1324068)
-- Name: building_blocks id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.building_blocks ALTER COLUMN id SET DEFAULT nextval('projects.building_blocks_id_seq'::regclass);


--
-- TOC entry 5719 (class 2604 OID 1332738)
-- Name: copilot_applications id; Type: DEFAULT; Schema: projects; Owner: projects
--

ALTER TABLE ONLY projects.copilot_applications ALTER COLUMN id SET DEFAULT nextval('projects.copilot_applications_id_seq'::regclass);


--
-- TOC entry 5652 (class 2604 OID 1324069)
-- Name: copilot_opportunities id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_opportunities ALTER COLUMN id SET DEFAULT nextval('projects.copilot_opportunities_id_seq'::regclass);


--
-- TOC entry 5653 (class 2604 OID 1324070)
-- Name: copilot_requests id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_requests ALTER COLUMN id SET DEFAULT nextval('projects.copilot_requests_id_seq'::regclass);


--
-- TOC entry 5654 (class 2604 OID 1324071)
-- Name: customer_payments id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.customer_payments ALTER COLUMN id SET DEFAULT nextval('projects.customer_payments_id_seq'::regclass);


--
-- TOC entry 5655 (class 2604 OID 1324072)
-- Name: form id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.form ALTER COLUMN id SET DEFAULT nextval('projects.form_id_seq'::regclass);


--
-- TOC entry 5659 (class 2604 OID 1324073)
-- Name: milestone_templates id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestone_templates ALTER COLUMN id SET DEFAULT nextval('projects.product_milestone_templates_id_seq'::regclass);


--
-- TOC entry 5661 (class 2604 OID 1324074)
-- Name: milestones id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestones ALTER COLUMN id SET DEFAULT nextval('projects.milestones_id_seq'::regclass);


--
-- TOC entry 5663 (class 2604 OID 1324075)
-- Name: org_config id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.org_config ALTER COLUMN id SET DEFAULT nextval('projects.org_config_id_seq'::regclass);


--
-- TOC entry 5664 (class 2604 OID 1324076)
-- Name: phase_products id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_products ALTER COLUMN id SET DEFAULT nextval('projects.phase_products_id_seq'::regclass);


--
-- TOC entry 5669 (class 2604 OID 1324077)
-- Name: plan_config id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.plan_config ALTER COLUMN id SET DEFAULT nextval('projects.plan_config_id_seq'::regclass);


--
-- TOC entry 5673 (class 2604 OID 1324078)
-- Name: price_config id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.price_config ALTER COLUMN id SET DEFAULT nextval('projects.price_config_id_seq'::regclass);


--
-- TOC entry 5679 (class 2604 OID 1324079)
-- Name: product_templates id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.product_templates ALTER COLUMN id SET DEFAULT nextval('projects.product_templates_id_seq'::regclass);


--
-- TOC entry 5683 (class 2604 OID 1324080)
-- Name: project_attachments id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_attachments ALTER COLUMN id SET DEFAULT nextval('projects.project_attachments_id_seq'::regclass);


--
-- TOC entry 5686 (class 2604 OID 1324081)
-- Name: project_estimations id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_estimations ALTER COLUMN id SET DEFAULT nextval('projects.project_estimations_id_seq'::regclass);


--
-- TOC entry 5689 (class 2604 OID 1324082)
-- Name: project_history id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_history ALTER COLUMN id SET DEFAULT nextval('projects.project_history_id_seq'::regclass);


--
-- TOC entry 5690 (class 2604 OID 1324083)
-- Name: project_member_invites id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_member_invites ALTER COLUMN id SET DEFAULT nextval('projects.project_member_invites_id_seq'::regclass);


--
-- TOC entry 5691 (class 2604 OID 1324084)
-- Name: project_members id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_members ALTER COLUMN id SET DEFAULT nextval('projects.project_members_id_seq'::regclass);


--
-- TOC entry 5695 (class 2604 OID 1324085)
-- Name: project_phases id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phases ALTER COLUMN id SET DEFAULT nextval('projects.project_phases_id_seq'::regclass);


--
-- TOC entry 5700 (class 2604 OID 1324086)
-- Name: project_settings id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_settings ALTER COLUMN id SET DEFAULT nextval('projects.project_settings_id_seq'::regclass);


--
-- TOC entry 5704 (class 2604 OID 1324087)
-- Name: project_templates id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_templates ALTER COLUMN id SET DEFAULT nextval('projects.project_templates_id_seq'::regclass);


--
-- TOC entry 5710 (class 2604 OID 1324088)
-- Name: projects id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.projects ALTER COLUMN id SET DEFAULT nextval('projects.projects_id_seq'::regclass);


--
-- TOC entry 5714 (class 2604 OID 1324089)
-- Name: scope_change_requests id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.scope_change_requests ALTER COLUMN id SET DEFAULT nextval('projects.scope_change_requests_id_seq'::regclass);


--
-- TOC entry 5715 (class 2604 OID 1324090)
-- Name: status_history id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.status_history ALTER COLUMN id SET DEFAULT nextval('projects.status_history_id_seq'::regclass);


--
-- TOC entry 5716 (class 2604 OID 1324091)
-- Name: timelines id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.timelines ALTER COLUMN id SET DEFAULT nextval('projects.timelines_id_seq'::regclass);


--
-- TOC entry 5717 (class 2604 OID 1324092)
-- Name: work_management_permissions id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.work_management_permissions ALTER COLUMN id SET DEFAULT nextval('projects.work_management_permissions_id_seq'::regclass);


--
-- TOC entry 5718 (class 2604 OID 1324093)
-- Name: work_streams id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.work_streams ALTER COLUMN id SET DEFAULT nextval('projects.work_streams_id_seq'::regclass);


--
-- TOC entry 5761 (class 2604 OID 1352767)
-- Name: events id; Type: DEFAULT; Schema: timeline; Owner: topcoder
--

ALTER TABLE ONLY timeline.events ALTER COLUMN id SET DEFAULT nextval('timeline.events_id_seq'::regclass);


--
-- TOC entry 6257 (class 2606 OID 1363214)
-- Name: CertificationCategory CertificationCategory_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationCategory"
    ADD CONSTRAINT "CertificationCategory_pkey" PRIMARY KEY (id);


--
-- TOC entry 6260 (class 2606 OID 1363216)
-- Name: CertificationEnrollments CertificationEnrollments_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationEnrollments"
    ADD CONSTRAINT "CertificationEnrollments_pkey" PRIMARY KEY (id);


--
-- TOC entry 6265 (class 2606 OID 1363218)
-- Name: CertificationResourceProgresses CertificationResourceProgresses_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResourceProgresses"
    ADD CONSTRAINT "CertificationResourceProgresses_pkey" PRIMARY KEY (id);


--
-- TOC entry 6263 (class 2606 OID 1363220)
-- Name: CertificationResource CertificationResource_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResource"
    ADD CONSTRAINT "CertificationResource_pkey" PRIMARY KEY (id);


--
-- TOC entry 6267 (class 2606 OID 1363222)
-- Name: DataVersion DataVersion_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."DataVersion"
    ADD CONSTRAINT "DataVersion_pkey" PRIMARY KEY (version);


--
-- TOC entry 6269 (class 2606 OID 1363224)
-- Name: FccCertificationProgresses FccCertificationProgresses_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCertificationProgresses"
    ADD CONSTRAINT "FccCertificationProgresses_pkey" PRIMARY KEY (id);


--
-- TOC entry 6272 (class 2606 OID 1363226)
-- Name: FccCompletedLessons FccCompletedLessons_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCompletedLessons"
    ADD CONSTRAINT "FccCompletedLessons_pkey" PRIMARY KEY (id, "fccModuleProgressId");


--
-- TOC entry 6274 (class 2606 OID 1363228)
-- Name: FccCourses FccCourses_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCourses"
    ADD CONSTRAINT "FccCourses_pkey" PRIMARY KEY (id);


--
-- TOC entry 6276 (class 2606 OID 1363230)
-- Name: FccLessons FccLessons_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccLessons"
    ADD CONSTRAINT "FccLessons_pkey" PRIMARY KEY (id);


--
-- TOC entry 6278 (class 2606 OID 1363232)
-- Name: FccModuleProgresses FccModuleProgresses_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModuleProgresses"
    ADD CONSTRAINT "FccModuleProgresses_pkey" PRIMARY KEY (id);


--
-- TOC entry 6280 (class 2606 OID 1363234)
-- Name: FccModules FccModules_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModules"
    ADD CONSTRAINT "FccModules_pkey" PRIMARY KEY (id);


--
-- TOC entry 6284 (class 2606 OID 1363236)
-- Name: FreeCodeCampCertification FreeCodeCampCertification_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FreeCodeCampCertification"
    ADD CONSTRAINT "FreeCodeCampCertification_pkey" PRIMARY KEY (id);


--
-- TOC entry 6288 (class 2606 OID 1363238)
-- Name: ResourceProvider ResourceProvider_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."ResourceProvider"
    ADD CONSTRAINT "ResourceProvider_pkey" PRIMARY KEY (id);


--
-- TOC entry 6290 (class 2606 OID 1363240)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 6292 (class 2606 OID 1363242)
-- Name: TopcoderCertification TopcoderCertification_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."TopcoderCertification"
    ADD CONSTRAINT "TopcoderCertification_pkey" PRIMARY KEY (id);


--
-- TOC entry 6295 (class 2606 OID 1363244)
-- Name: TopcoderUdemyCourse TopcoderUdemyCourse_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."TopcoderUdemyCourse"
    ADD CONSTRAINT "TopcoderUdemyCourse_pkey" PRIMARY KEY (id);


--
-- TOC entry 6297 (class 2606 OID 1363246)
-- Name: UdemyCourse UdemyCourse_pkey; Type: CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."UdemyCourse"
    ADD CONSTRAINT "UdemyCourse_pkey" PRIMARY KEY (id, data_version);


--
-- TOC entry 6925 (class 2606 OID 2061248)
-- Name: actions actions_pkey; Type: CONSTRAINT; Schema: autopilot; Owner: autopilot
--

ALTER TABLE ONLY autopilot.actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- TOC entry 6954 (class 2606 OID 2069956)
-- Name: BillingAccountAccess BillingAccountAccess_pkey; Type: CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."BillingAccountAccess"
    ADD CONSTRAINT "BillingAccountAccess_pkey" PRIMARY KEY (id);


--
-- TOC entry 6941 (class 2606 OID 2069994)
-- Name: BillingAccount BillingAccount_pkey; Type: CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."BillingAccount"
    ADD CONSTRAINT "BillingAccount_pkey" PRIMARY KEY (id);


--
-- TOC entry 6935 (class 2606 OID 2069921)
-- Name: Client Client_pkey; Type: CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."Client"
    ADD CONSTRAINT "Client_pkey" PRIMARY KEY (id);


--
-- TOC entry 6951 (class 2606 OID 2069948)
-- Name: ConsumedAmount ConsumedAmount_pkey; Type: CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."ConsumedAmount"
    ADD CONSTRAINT "ConsumedAmount_pkey" PRIMARY KEY (id);


--
-- TOC entry 6947 (class 2606 OID 2069940)
-- Name: LockedAmount LockedAmount_pkey; Type: CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."LockedAmount"
    ADD CONSTRAINT "LockedAmount_pkey" PRIMARY KEY (id);


--
-- TOC entry 6931 (class 2606 OID 2069900)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6542 (class 2606 OID 2004952)
-- Name: Attachment Attachment_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Attachment"
    ADD CONSTRAINT "Attachment_pkey" PRIMARY KEY (id);


--
-- TOC entry 6540 (class 2606 OID 2004944)
-- Name: AuditLog AuditLog_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."AuditLog"
    ADD CONSTRAINT "AuditLog_pkey" PRIMARY KEY (id);


--
-- TOC entry 6560 (class 2606 OID 2005000)
-- Name: ChallengeBilling ChallengeBilling_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeBilling"
    ADD CONSTRAINT "ChallengeBilling_pkey" PRIMARY KEY (id);


--
-- TOC entry 6576 (class 2606 OID 2005048)
-- Name: ChallengeConstraint ChallengeConstraint_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeConstraint"
    ADD CONSTRAINT "ChallengeConstraint_pkey" PRIMARY KEY (id);


--
-- TOC entry 6573 (class 2606 OID 2005039)
-- Name: ChallengeDiscussionOption ChallengeDiscussionOption_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeDiscussionOption"
    ADD CONSTRAINT "ChallengeDiscussionOption_pkey" PRIMARY KEY (id);


--
-- TOC entry 6571 (class 2606 OID 2005031)
-- Name: ChallengeDiscussion ChallengeDiscussion_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeDiscussion"
    ADD CONSTRAINT "ChallengeDiscussion_pkey" PRIMARY KEY (id);


--
-- TOC entry 6568 (class 2606 OID 2005023)
-- Name: ChallengeEvent ChallengeEvent_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeEvent"
    ADD CONSTRAINT "ChallengeEvent_pkey" PRIMARY KEY (id);


--
-- TOC entry 6565 (class 2606 OID 2005015)
-- Name: ChallengeLegacy ChallengeLegacy_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeLegacy"
    ADD CONSTRAINT "ChallengeLegacy_pkey" PRIMARY KEY (id);


--
-- TOC entry 6545 (class 2606 OID 2004960)
-- Name: ChallengeMetadata ChallengeMetadata_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeMetadata"
    ADD CONSTRAINT "ChallengeMetadata_pkey" PRIMARY KEY (id);


--
-- TOC entry 6589 (class 2606 OID 2005073)
-- Name: ChallengePhaseConstraint ChallengePhaseConstraint_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePhaseConstraint"
    ADD CONSTRAINT "ChallengePhaseConstraint_pkey" PRIMARY KEY (id);


--
-- TOC entry 6584 (class 2606 OID 2005065)
-- Name: ChallengePhase ChallengePhase_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePhase"
    ADD CONSTRAINT "ChallengePhase_pkey" PRIMARY KEY (id);


--
-- TOC entry 6593 (class 2606 OID 2005081)
-- Name: ChallengePrizeSet ChallengePrizeSet_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePrizeSet"
    ADD CONSTRAINT "ChallengePrizeSet_pkey" PRIMARY KEY (id);


--
-- TOC entry 6606 (class 2606 OID 2005258)
-- Name: ChallengeReviewer ChallengeReviewer_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeReviewer"
    ADD CONSTRAINT "ChallengeReviewer_pkey" PRIMARY KEY (id);


--
-- TOC entry 6557 (class 2606 OID 2004992)
-- Name: ChallengeSkill ChallengeSkill_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeSkill"
    ADD CONSTRAINT "ChallengeSkill_pkey" PRIMARY KEY (id);


--
-- TOC entry 6555 (class 2606 OID 2004984)
-- Name: ChallengeTerm ChallengeTerm_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTerm"
    ADD CONSTRAINT "ChallengeTerm_pkey" PRIMARY KEY (id);


--
-- TOC entry 6536 (class 2606 OID 2004936)
-- Name: ChallengeTimelineTemplate ChallengeTimelineTemplate_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTimelineTemplate"
    ADD CONSTRAINT "ChallengeTimelineTemplate_pkey" PRIMARY KEY (id);


--
-- TOC entry 6534 (class 2606 OID 2004927)
-- Name: ChallengeTrack ChallengeTrack_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTrack"
    ADD CONSTRAINT "ChallengeTrack_pkey" PRIMARY KEY (id);


--
-- TOC entry 6531 (class 2606 OID 2004919)
-- Name: ChallengeType ChallengeType_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeType"
    ADD CONSTRAINT "ChallengeType_pkey" PRIMARY KEY (id);


--
-- TOC entry 6553 (class 2606 OID 2004976)
-- Name: ChallengeWinner ChallengeWinner_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeWinner"
    ADD CONSTRAINT "ChallengeWinner_pkey" PRIMARY KEY (id);


--
-- TOC entry 6512 (class 2606 OID 2004909)
-- Name: Challenge Challenge_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Challenge"
    ADD CONSTRAINT "Challenge_pkey" PRIMARY KEY (id);


--
-- TOC entry 6610 (class 2606 OID 2005300)
-- Name: DefaultChallengeReviewer DefaultChallengeReviewer_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."DefaultChallengeReviewer"
    ADD CONSTRAINT "DefaultChallengeReviewer_pkey" PRIMARY KEY (id);


--
-- TOC entry 6579 (class 2606 OID 2005056)
-- Name: Phase Phase_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Phase"
    ADD CONSTRAINT "Phase_pkey" PRIMARY KEY (id);


--
-- TOC entry 6548 (class 2606 OID 2004968)
-- Name: Prize Prize_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Prize"
    ADD CONSTRAINT "Prize_pkey" PRIMARY KEY (id);


--
-- TOC entry 6599 (class 2606 OID 2005098)
-- Name: TimelineTemplatePhase TimelineTemplatePhase_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."TimelineTemplatePhase"
    ADD CONSTRAINT "TimelineTemplatePhase_pkey" PRIMARY KEY (id);


--
-- TOC entry 6597 (class 2606 OID 2005090)
-- Name: TimelineTemplate TimelineTemplate_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."TimelineTemplate"
    ADD CONSTRAINT "TimelineTemplate_pkey" PRIMARY KEY (id);


--
-- TOC entry 6507 (class 2606 OID 2004836)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6328 (class 2606 OID 1363883)
-- Name: Emails Emails_pkey; Type: CONSTRAINT; Schema: emails; Owner: topcoder
--

ALTER TABLE ONLY emails."Emails"
    ADD CONSTRAINT "Emails_pkey" PRIMARY KEY (id);


--
-- TOC entry 6160 (class 2606 OID 1334280)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6162 (class 2606 OID 1334525)
-- Name: audit audit_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (id);


--
-- TOC entry 6921 (class 2606 OID 2055340)
-- Name: challenge_lock challenge_lock_external_id_key; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.challenge_lock
    ADD CONSTRAINT challenge_lock_external_id_key UNIQUE (external_id);


--
-- TOC entry 6923 (class 2606 OID 2055338)
-- Name: challenge_lock challenge_lock_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.challenge_lock
    ADD CONSTRAINT challenge_lock_pkey PRIMARY KEY (id);


--
-- TOC entry 6164 (class 2606 OID 1334538)
-- Name: origin origin_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.origin
    ADD CONSTRAINT origin_pkey PRIMARY KEY (origin_id);


--
-- TOC entry 6166 (class 2606 OID 1334549)
-- Name: otp otp_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.otp
    ADD CONSTRAINT otp_pkey PRIMARY KEY (id);


--
-- TOC entry 6178 (class 2606 OID 1334570)
-- Name: payment_method payment_method_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (payment_method_id);


--
-- TOC entry 6175 (class 2606 OID 1334561)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 6180 (class 2606 OID 1334575)
-- Name: payment_release_associations payment_release_associations_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_release_associations
    ADD CONSTRAINT payment_release_associations_pkey PRIMARY KEY (payment_release_id, payment_id);


--
-- TOC entry 6182 (class 2606 OID 1334586)
-- Name: payment_releases payment_releases_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_releases
    ADD CONSTRAINT payment_releases_pkey PRIMARY KEY (payment_release_id);


--
-- TOC entry 6205 (class 2606 OID 1334784)
-- Name: trolley_recipient_payment_method trolley_recipient_payment_method_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_recipient_payment_method
    ADD CONSTRAINT trolley_recipient_payment_method_pkey PRIMARY KEY (id);


--
-- TOC entry 6199 (class 2606 OID 1334757)
-- Name: trolley_recipient trolley_recipient_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_recipient
    ADD CONSTRAINT trolley_recipient_pkey PRIMARY KEY (id);


--
-- TOC entry 6197 (class 2606 OID 1334749)
-- Name: trolley_webhook_log trolley_webhook_log_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_webhook_log
    ADD CONSTRAINT trolley_webhook_log_pkey PRIMARY KEY (id);


--
-- TOC entry 6431 (class 2606 OID 1771176)
-- Name: user_identity_verification_associations user_identity_verification_associations_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.user_identity_verification_associations
    ADD CONSTRAINT user_identity_verification_associations_pkey PRIMARY KEY (id);


--
-- TOC entry 6184 (class 2606 OID 1334639)
-- Name: user_payment_methods user_payment_methods_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.user_payment_methods
    ADD CONSTRAINT user_payment_methods_pkey PRIMARY KEY (id);


--
-- TOC entry 6203 (class 2606 OID 1334778)
-- Name: user_tax_form_associations user_tax_form_associations_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.user_tax_form_associations
    ADD CONSTRAINT user_tax_form_associations_pkey PRIMARY KEY (id);


--
-- TOC entry 6194 (class 2606 OID 1334657)
-- Name: winnings winnings_pkey; Type: CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.winnings
    ADD CONSTRAINT winnings_pkey PRIMARY KEY (winning_id);


--
-- TOC entry 6208 (class 2606 OID 1347897)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 6210 (class 2606 OID 1347899)
-- Name: badge_custom_fields badge_custom_fields_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.badge_custom_fields
    ADD CONSTRAINT badge_custom_fields_pkey PRIMARY KEY (field_def_id);


--
-- TOC entry 6216 (class 2606 OID 1347901)
-- Name: member_badges badge_per_user; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.member_badges
    ADD CONSTRAINT badge_per_user PRIMARY KEY (user_id, org_badge_id);


--
-- TOC entry 6222 (class 2606 OID 1347903)
-- Name: organization_badges org_badge_name; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges
    ADD CONSTRAINT org_badge_name UNIQUE (organization_id, badge_name);


--
-- TOC entry 6224 (class 2606 OID 1347905)
-- Name: organization_badges org_badge_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges
    ADD CONSTRAINT org_badge_pkey PRIMARY KEY (id);


--
-- TOC entry 6226 (class 2606 OID 1347907)
-- Name: organization_badges org_badge_unique_key; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges
    ADD CONSTRAINT org_badge_unique_key UNIQUE (id, organization_id);


--
-- TOC entry 6212 (class 2606 OID 1347909)
-- Name: badge_custom_fields org_field; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.badge_custom_fields
    ADD CONSTRAINT org_field UNIQUE (organization_id, name);


--
-- TOC entry 6218 (class 2606 OID 1347911)
-- Name: organization org_name; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization
    ADD CONSTRAINT org_name UNIQUE (name);


--
-- TOC entry 6220 (class 2606 OID 1347913)
-- Name: organization org_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization
    ADD CONSTRAINT org_pkey PRIMARY KEY (id);


--
-- TOC entry 6232 (class 2606 OID 1347915)
-- Name: tags org_tag; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.tags
    ADD CONSTRAINT org_tag UNIQUE (organization_id, tag_value);


--
-- TOC entry 6228 (class 2606 OID 1347917)
-- Name: organization_badges_custom_fields organization_badges_custom_fields_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges_custom_fields
    ADD CONSTRAINT organization_badges_custom_fields_pkey PRIMARY KEY (badges_id, custom_field_id);


--
-- TOC entry 6230 (class 2606 OID 1347919)
-- Name: organization_badges_tags organization_badges_tags_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges_tags
    ADD CONSTRAINT organization_badges_tags_pkey PRIMARY KEY (organization_badges_id, tags_id);


--
-- TOC entry 6234 (class 2606 OID 1347921)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 6236 (class 2606 OID 1347923)
-- Name: tags tags_unique_key; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.tags
    ADD CONSTRAINT tags_unique_key UNIQUE (id, organization_id);


--
-- TOC entry 6214 (class 2606 OID 1347925)
-- Name: badge_custom_fields unique_defs; Type: CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.badge_custom_fields
    ADD CONSTRAINT unique_defs UNIQUE (organization_id, field_def_id);


--
-- TOC entry 6973 (class 2606 OID 2070292)
-- Name: GroupMember GroupMember_pkey; Type: CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."GroupMember"
    ADD CONSTRAINT "GroupMember_pkey" PRIMARY KEY (id);


--
-- TOC entry 6963 (class 2606 OID 2070284)
-- Name: Group Group_pkey; Type: CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."Group"
    ADD CONSTRAINT "Group_pkey" PRIMARY KEY (id);


--
-- TOC entry 6975 (class 2606 OID 2070300)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- TOC entry 6978 (class 2606 OID 2070307)
-- Name: _ParentSubGroups _ParentSubGroups_AB_pkey; Type: CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."_ParentSubGroups"
    ADD CONSTRAINT "_ParentSubGroups_AB_pkey" PRIMARY KEY ("A", "B");


--
-- TOC entry 6957 (class 2606 OID 2070270)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6433 (class 2606 OID 1831874)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6435 (class 2606 OID 1831881)
-- Name: achievement_type_lu achv_type_lu_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.achievement_type_lu
    ADD CONSTRAINT achv_type_lu_pkey PRIMARY KEY (achievement_type_id);


--
-- TOC entry 6497 (class 2606 OID 1832041)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- TOC entry 6437 (class 2606 OID 1831887)
-- Name: country country_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_code);


--
-- TOC entry 6440 (class 2606 OID 1831896)
-- Name: dice_connection dice_connection_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.dice_connection
    ADD CONSTRAINT dice_connection_pk PRIMARY KEY (id);


--
-- TOC entry 6446 (class 2606 OID 1831911)
-- Name: email_status_lu email_status_lu_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.email_status_lu
    ADD CONSTRAINT email_status_lu_pk PRIMARY KEY (status_id);


--
-- TOC entry 6448 (class 2606 OID 1831918)
-- Name: email_type_lu email_type_lu_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.email_type_lu
    ADD CONSTRAINT email_type_lu_pk PRIMARY KEY (email_type_id);


--
-- TOC entry 6450 (class 2606 OID 1831924)
-- Name: id_sequences id_sequences_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.id_sequences
    ADD CONSTRAINT id_sequences_pkey PRIMARY KEY (name);


--
-- TOC entry 6452 (class 2606 OID 1831929)
-- Name: invalid_handles pk_invalid_hand556; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.invalid_handles
    ADD CONSTRAINT pk_invalid_hand556 PRIMARY KEY (invalid_handle_id);


--
-- TOC entry 6454 (class 2606 OID 1831935)
-- Name: security_groups pk_security_groups; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.security_groups
    ADD CONSTRAINT pk_security_groups PRIMARY KEY (group_id);


--
-- TOC entry 6458 (class 2606 OID 1831945)
-- Name: security_user pk_security_user; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.security_user
    ADD CONSTRAINT pk_security_user PRIMARY KEY (login_id);


--
-- TOC entry 6476 (class 2606 OID 1831990)
-- Name: user_group_xref pk_user_group_xref; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_group_xref
    ADD CONSTRAINT pk_user_group_xref PRIMARY KEY (user_group_id);


--
-- TOC entry 6502 (class 2606 OID 1832056)
-- Name: role_assignment role_assignment_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role_assignment
    ADD CONSTRAINT role_assignment_pkey PRIMARY KEY (id);


--
-- TOC entry 6500 (class 2606 OID 1832048)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 6456 (class 2606 OID 1831940)
-- Name: security_status_lu securitystatuslu_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.security_status_lu
    ADD CONSTRAINT securitystatuslu_pkey PRIMARY KEY (security_status_id);


--
-- TOC entry 6461 (class 2606 OID 1831950)
-- Name: social_login_provider social_provider_prkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.social_login_provider
    ADD CONSTRAINT social_provider_prkey PRIMARY KEY (social_login_provider_id);


--
-- TOC entry 6463 (class 2606 OID 1831957)
-- Name: sso_login_provider sso_provider_prkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.sso_login_provider
    ADD CONSTRAINT sso_provider_prkey PRIMARY KEY (sso_login_provider_id);


--
-- TOC entry 6444 (class 2606 OID 1831904)
-- Name: email u110_23; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.email
    ADD CONSTRAINT u110_23 PRIMARY KEY (email_id);


--
-- TOC entry 6489 (class 2606 OID 1832020)
-- Name: user_status_lu u113_26; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_status_lu
    ADD CONSTRAINT u113_26 PRIMARY KEY (user_status_id);


--
-- TOC entry 6465 (class 2606 OID 1831967)
-- Name: user u175_45; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity."user"
    ADD CONSTRAINT u175_45 PRIMARY KEY (user_id);


--
-- TOC entry 6471 (class 2606 OID 1831978)
-- Name: user_2fa user_2fa_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_2fa
    ADD CONSTRAINT user_2fa_pk PRIMARY KEY (id);


--
-- TOC entry 6474 (class 2606 OID 1831984)
-- Name: user_achievement user_achievement_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_achievement
    ADD CONSTRAINT user_achievement_pkey PRIMARY KEY (user_id, achievement_type_id);


--
-- TOC entry 6494 (class 2606 OID 1832032)
-- Name: user_email_xref user_email_xref_pkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_email_xref
    ADD CONSTRAINT user_email_xref_pkey PRIMARY KEY (user_id, email_id);


--
-- TOC entry 6479 (class 2606 OID 1831999)
-- Name: user_otp_email user_otp_email_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_otp_email
    ADD CONSTRAINT user_otp_email_pk PRIMARY KEY (id);


--
-- TOC entry 6482 (class 2606 OID 1832005)
-- Name: user_social_login user_social_prkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_social_login
    ADD CONSTRAINT user_social_prkey PRIMARY KEY (user_id, social_login_provider_id);


--
-- TOC entry 6485 (class 2606 OID 1832010)
-- Name: user_sso_login user_sso_prkey; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_sso_login
    ADD CONSTRAINT user_sso_prkey PRIMARY KEY (user_id, provider_id);


--
-- TOC entry 6487 (class 2606 OID 1832015)
-- Name: user_status userstatus_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_status
    ADD CONSTRAINT userstatus_pk PRIMARY KEY (user_id, user_status_type_id);


--
-- TOC entry 6491 (class 2606 OID 1832025)
-- Name: user_status_type_lu userstatustypelu_pk; Type: CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_status_type_lu
    ADD CONSTRAINT userstatustypelu_pk PRIMARY KEY (user_status_type_id);


--
-- TOC entry 6764 (class 2606 OID 2029900)
-- Name: Country Country_pkey; Type: CONSTRAINT; Schema: lookups; Owner: lookups
--

ALTER TABLE ONLY lookups."Country"
    ADD CONSTRAINT "Country_pkey" PRIMARY KEY (id);


--
-- TOC entry 6766 (class 2606 OID 2029909)
-- Name: Device Device_pkey; Type: CONSTRAINT; Schema: lookups; Owner: lookups
--

ALTER TABLE ONLY lookups."Device"
    ADD CONSTRAINT "Device_pkey" PRIMARY KEY (id);


--
-- TOC entry 6770 (class 2606 OID 2029918)
-- Name: EducationalInstitution EducationalInstitution_pkey; Type: CONSTRAINT; Schema: lookups; Owner: lookups
--

ALTER TABLE ONLY lookups."EducationalInstitution"
    ADD CONSTRAINT "EducationalInstitution_pkey" PRIMARY KEY (id);


--
-- TOC entry 6760 (class 2606 OID 2029891)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: lookups; Owner: lookups
--

ALTER TABLE ONLY lookups._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6631 (class 2606 OID 2023512)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6749 (class 2606 OID 2023918)
-- Name: displayMode displayMode_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."displayMode"
    ADD CONSTRAINT "displayMode_pkey" PRIMARY KEY (id);


--
-- TOC entry 6652 (class 2606 OID 2023634)
-- Name: distributionStats distributionStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."distributionStats"
    ADD CONSTRAINT "distributionStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6644 (class 2606 OID 2023614)
-- Name: memberAddress memberAddress_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberAddress"
    ADD CONSTRAINT "memberAddress_pkey" PRIMARY KEY (id);


--
-- TOC entry 6674 (class 2606 OID 2023694)
-- Name: memberCopilotStats memberCopilotStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberCopilotStats"
    ADD CONSTRAINT "memberCopilotStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6666 (class 2606 OID 2023673)
-- Name: memberDataScienceHistoryStats memberDataScienceHistoryStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceHistoryStats"
    ADD CONSTRAINT "memberDataScienceHistoryStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6694 (class 2606 OID 2023744)
-- Name: memberDataScienceStats memberDataScienceStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceStats"
    ADD CONSTRAINT "memberDataScienceStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6690 (class 2606 OID 2023734)
-- Name: memberDesignStatsItem memberDesignStatsItem_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStatsItem"
    ADD CONSTRAINT "memberDesignStatsItem_pkey" PRIMARY KEY (id);


--
-- TOC entry 6686 (class 2606 OID 2023724)
-- Name: memberDesignStats memberDesignStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStats"
    ADD CONSTRAINT "memberDesignStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6663 (class 2606 OID 2023663)
-- Name: memberDevelopHistoryStats memberDevelopHistoryStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopHistoryStats"
    ADD CONSTRAINT "memberDevelopHistoryStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6682 (class 2606 OID 2023714)
-- Name: memberDevelopStatsItem memberDevelopStatsItem_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStatsItem"
    ADD CONSTRAINT "memberDevelopStatsItem_pkey" PRIMARY KEY (id);


--
-- TOC entry 6678 (class 2606 OID 2023704)
-- Name: memberDevelopStats memberDevelopStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStats"
    ADD CONSTRAINT "memberDevelopStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6655 (class 2606 OID 2023642)
-- Name: memberFinancial memberFinancial_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberFinancial"
    ADD CONSTRAINT "memberFinancial_pkey" PRIMARY KEY ("userId");


--
-- TOC entry 6658 (class 2606 OID 2023653)
-- Name: memberHistoryStats memberHistoryStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberHistoryStats"
    ADD CONSTRAINT "memberHistoryStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6708 (class 2606 OID 2023784)
-- Name: memberMarathonStats memberMarathonStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMarathonStats"
    ADD CONSTRAINT "memberMarathonStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6648 (class 2606 OID 2023624)
-- Name: memberMaxRating memberMaxRating_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMaxRating"
    ADD CONSTRAINT "memberMaxRating_pkey" PRIMARY KEY (id);


--
-- TOC entry 6758 (class 2606 OID 2023942)
-- Name: memberSkillLevel memberSkillLevel_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkillLevel"
    ADD CONSTRAINT "memberSkillLevel_pkey" PRIMARY KEY ("memberSkillId", "skillLevelId");


--
-- TOC entry 6753 (class 2606 OID 2023934)
-- Name: memberSkill memberSkill_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkill"
    ADD CONSTRAINT "memberSkill_pkey" PRIMARY KEY (id);


--
-- TOC entry 6700 (class 2606 OID 2023764)
-- Name: memberSrmChallengeDetail memberSrmChallengeDetail_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmChallengeDetail"
    ADD CONSTRAINT "memberSrmChallengeDetail_pkey" PRIMARY KEY (id);


--
-- TOC entry 6703 (class 2606 OID 2023774)
-- Name: memberSrmDivisionDetail memberSrmDivisionDetail_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmDivisionDetail"
    ADD CONSTRAINT "memberSrmDivisionDetail_pkey" PRIMARY KEY (id);


--
-- TOC entry 6698 (class 2606 OID 2023754)
-- Name: memberSrmStats memberSrmStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmStats"
    ADD CONSTRAINT "memberSrmStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6668 (class 2606 OID 2023684)
-- Name: memberStats memberStats_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberStats"
    ADD CONSTRAINT "memberStats_pkey" PRIMARY KEY (id);


--
-- TOC entry 6731 (class 2606 OID 2023854)
-- Name: memberTraitBasicInfo memberTraitBasicInfo_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitBasicInfo"
    ADD CONSTRAINT "memberTraitBasicInfo_pkey" PRIMARY KEY (id);


--
-- TOC entry 6743 (class 2606 OID 2023894)
-- Name: memberTraitCommunity memberTraitCommunity_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitCommunity"
    ADD CONSTRAINT "memberTraitCommunity_pkey" PRIMARY KEY (id);


--
-- TOC entry 6715 (class 2606 OID 2023804)
-- Name: memberTraitDevice memberTraitDevice_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitDevice"
    ADD CONSTRAINT "memberTraitDevice_pkey" PRIMARY KEY (id);


--
-- TOC entry 6727 (class 2606 OID 2023844)
-- Name: memberTraitEducation memberTraitEducation_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitEducation"
    ADD CONSTRAINT "memberTraitEducation_pkey" PRIMARY KEY (id);


--
-- TOC entry 6734 (class 2606 OID 2023864)
-- Name: memberTraitLanguage memberTraitLanguage_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitLanguage"
    ADD CONSTRAINT "memberTraitLanguage_pkey" PRIMARY KEY (id);


--
-- TOC entry 6737 (class 2606 OID 2023874)
-- Name: memberTraitOnboardChecklist memberTraitOnboardChecklist_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitOnboardChecklist"
    ADD CONSTRAINT "memberTraitOnboardChecklist_pkey" PRIMARY KEY (id);


--
-- TOC entry 6740 (class 2606 OID 2023884)
-- Name: memberTraitPersonalization memberTraitPersonalization_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitPersonalization"
    ADD CONSTRAINT "memberTraitPersonalization_pkey" PRIMARY KEY (id);


--
-- TOC entry 6721 (class 2606 OID 2023824)
-- Name: memberTraitServiceProvider memberTraitServiceProvider_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitServiceProvider"
    ADD CONSTRAINT "memberTraitServiceProvider_pkey" PRIMARY KEY (id);


--
-- TOC entry 6718 (class 2606 OID 2023814)
-- Name: memberTraitSoftware memberTraitSoftware_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitSoftware"
    ADD CONSTRAINT "memberTraitSoftware_pkey" PRIMARY KEY (id);


--
-- TOC entry 6724 (class 2606 OID 2023834)
-- Name: memberTraitWork memberTraitWork_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitWork"
    ADD CONSTRAINT "memberTraitWork_pkey" PRIMARY KEY (id);


--
-- TOC entry 6710 (class 2606 OID 2023794)
-- Name: memberTraits memberTraits_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraits"
    ADD CONSTRAINT "memberTraits_pkey" PRIMARY KEY (id);


--
-- TOC entry 6640 (class 2606 OID 2023604)
-- Name: member member_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members.member
    ADD CONSTRAINT member_pkey PRIMARY KEY ("userId");


--
-- TOC entry 6745 (class 2606 OID 2023902)
-- Name: skillCategory skillCategory_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."skillCategory"
    ADD CONSTRAINT "skillCategory_pkey" PRIMARY KEY (id);


--
-- TOC entry 6751 (class 2606 OID 2023926)
-- Name: skillLevel skillLevel_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."skillLevel"
    ADD CONSTRAINT "skillLevel_pkey" PRIMARY KEY (id);


--
-- TOC entry 6747 (class 2606 OID 2023910)
-- Name: skill skill_pkey; Type: CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members.skill
    ADD CONSTRAINT skill_pkey PRIMARY KEY (id);


--
-- TOC entry 6238 (class 2606 OID 1352653)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 6240 (class 2606 OID 1352655)
-- Name: email_logs email_logs_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.email_logs
    ADD CONSTRAINT email_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 6242 (class 2606 OID 1352657)
-- Name: post_attachments post_attachments_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.post_attachments
    ADD CONSTRAINT post_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 6244 (class 2606 OID 1352659)
-- Name: post_user_stats post_user_stats_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.post_user_stats
    ADD CONSTRAINT post_user_stats_pkey PRIMARY KEY ("postId", action);


--
-- TOC entry 6246 (class 2606 OID 1352661)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 6249 (class 2606 OID 1352663)
-- Name: reference_lookups reference_lookups_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.reference_lookups
    ADD CONSTRAINT reference_lookups_pkey PRIMARY KEY (reference);


--
-- TOC entry 6252 (class 2606 OID 1352665)
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- TOC entry 6330 (class 2606 OID 1436634)
-- Name: NotificationSettings NotificationSettings_pkey; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."NotificationSettings"
    ADD CONSTRAINT "NotificationSettings_pkey" PRIMARY KEY (id);


--
-- TOC entry 6332 (class 2606 OID 1436636)
-- Name: Notifications Notifications_pkey; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."Notifications"
    ADD CONSTRAINT "Notifications_pkey" PRIMARY KEY (id);


--
-- TOC entry 6335 (class 2606 OID 1436638)
-- Name: ScheduledEvents ScheduledEvents_pkey; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."ScheduledEvents"
    ADD CONSTRAINT "ScheduledEvents_pkey" PRIMARY KEY (id);


--
-- TOC entry 6337 (class 2606 OID 1436640)
-- Name: ServiceSettings ServiceSettings_pkey; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."ServiceSettings"
    ADD CONSTRAINT "ServiceSettings_pkey" PRIMARY KEY (id);


--
-- TOC entry 6339 (class 2606 OID 1436642)
-- Name: bulk_message_user_refs bulk_message_user_refs_bulk_message_id_user_id_key; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_message_user_refs
    ADD CONSTRAINT bulk_message_user_refs_bulk_message_id_user_id_key UNIQUE (bulk_message_id, user_id);


--
-- TOC entry 6341 (class 2606 OID 1436644)
-- Name: bulk_message_user_refs bulk_message_user_refs_pkey; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_message_user_refs
    ADD CONSTRAINT bulk_message_user_refs_pkey PRIMARY KEY (id);


--
-- TOC entry 6343 (class 2606 OID 1436646)
-- Name: bulk_messages bulk_messages_pkey; Type: CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_messages
    ADD CONSTRAINT bulk_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 6082 (class 2606 OID 1324095)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 6084 (class 2606 OID 1324097)
-- Name: building_blocks building_blocks_key_uniq; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.building_blocks
    ADD CONSTRAINT building_blocks_key_uniq UNIQUE (key);


--
-- TOC entry 6086 (class 2606 OID 1324099)
-- Name: building_blocks building_blocks_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.building_blocks
    ADD CONSTRAINT building_blocks_pkey PRIMARY KEY (id);


--
-- TOC entry 6158 (class 2606 OID 1332742)
-- Name: copilot_applications copilot_applications_pkey; Type: CONSTRAINT; Schema: projects; Owner: projects
--

ALTER TABLE ONLY projects.copilot_applications
    ADD CONSTRAINT copilot_applications_pkey PRIMARY KEY (id);


--
-- TOC entry 6088 (class 2606 OID 1324101)
-- Name: copilot_opportunities copilot_opportunities_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_opportunities
    ADD CONSTRAINT copilot_opportunities_pkey PRIMARY KEY (id);


--
-- TOC entry 6090 (class 2606 OID 1324103)
-- Name: copilot_requests copilot_requests_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_requests
    ADD CONSTRAINT copilot_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 6092 (class 2606 OID 1324105)
-- Name: customer_payments customer_payments_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.customer_payments
    ADD CONSTRAINT customer_payments_pkey PRIMARY KEY (id);


--
-- TOC entry 6094 (class 2606 OID 1324107)
-- Name: form form_key_version_revision; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.form
    ADD CONSTRAINT form_key_version_revision UNIQUE (key, version, revision);


--
-- TOC entry 6098 (class 2606 OID 1324109)
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- TOC entry 6100 (class 2606 OID 1324111)
-- Name: phase_products phase_products_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_products
    ADD CONSTRAINT phase_products_pkey PRIMARY KEY (id);


--
-- TOC entry 6102 (class 2606 OID 1324113)
-- Name: phase_work_streams phase_work_streams_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_work_streams
    ADD CONSTRAINT phase_work_streams_pkey PRIMARY KEY ("workStreamId", "phaseId");


--
-- TOC entry 6104 (class 2606 OID 1324115)
-- Name: plan_config plan_config_key_version_revision; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.plan_config
    ADD CONSTRAINT plan_config_key_version_revision UNIQUE (key, version, revision);


--
-- TOC entry 6106 (class 2606 OID 1324117)
-- Name: price_config price_config_key_version_revision; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.price_config
    ADD CONSTRAINT price_config_key_version_revision UNIQUE (key, version, revision);


--
-- TOC entry 6108 (class 2606 OID 1324119)
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (key);


--
-- TOC entry 6096 (class 2606 OID 1324121)
-- Name: milestone_templates product_milestone_templates_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestone_templates
    ADD CONSTRAINT product_milestone_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 6110 (class 2606 OID 1324123)
-- Name: product_templates product_templates_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.product_templates
    ADD CONSTRAINT product_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 6112 (class 2606 OID 1324125)
-- Name: project_attachments project_attachments_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_attachments
    ADD CONSTRAINT project_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 6114 (class 2606 OID 1324127)
-- Name: project_estimation_items project_estimation_items_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_estimation_items
    ADD CONSTRAINT project_estimation_items_pkey PRIMARY KEY (id);


--
-- TOC entry 6116 (class 2606 OID 1324129)
-- Name: project_estimations project_estimations_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_estimations
    ADD CONSTRAINT project_estimations_pkey PRIMARY KEY (id);


--
-- TOC entry 6118 (class 2606 OID 1324131)
-- Name: project_history project_history_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_history
    ADD CONSTRAINT project_history_pkey PRIMARY KEY (id);


--
-- TOC entry 6121 (class 2606 OID 1324133)
-- Name: project_member_invites project_member_invites_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_member_invites
    ADD CONSTRAINT project_member_invites_pkey PRIMARY KEY (id);


--
-- TOC entry 6124 (class 2606 OID 1324135)
-- Name: project_members project_members_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_members
    ADD CONSTRAINT project_members_pkey PRIMARY KEY (id);


--
-- TOC entry 6128 (class 2606 OID 1324137)
-- Name: project_phase_approval project_phase_approval_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phase_approval
    ADD CONSTRAINT project_phase_approval_pkey PRIMARY KEY (id);


--
-- TOC entry 6130 (class 2606 OID 1324139)
-- Name: project_phase_member project_phase_member_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phase_member
    ADD CONSTRAINT project_phase_member_pkey PRIMARY KEY (id);


--
-- TOC entry 6132 (class 2606 OID 1324141)
-- Name: project_phases project_phases_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phases
    ADD CONSTRAINT project_phases_pkey PRIMARY KEY (id);


--
-- TOC entry 6134 (class 2606 OID 1324143)
-- Name: project_settings project_settings_key_project_id; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_settings
    ADD CONSTRAINT project_settings_key_project_id UNIQUE (key, "projectId");


--
-- TOC entry 6136 (class 2606 OID 1324145)
-- Name: project_settings project_settings_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_settings
    ADD CONSTRAINT project_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 6138 (class 2606 OID 1324147)
-- Name: project_templates project_templates_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_templates
    ADD CONSTRAINT project_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 6140 (class 2606 OID 1324149)
-- Name: project_types project_types_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_types
    ADD CONSTRAINT project_types_pkey PRIMARY KEY (key);


--
-- TOC entry 6146 (class 2606 OID 1324151)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- TOC entry 6150 (class 2606 OID 1324153)
-- Name: scope_change_requests scope_change_requests_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.scope_change_requests
    ADD CONSTRAINT scope_change_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 6152 (class 2606 OID 1324155)
-- Name: status_history status_history_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.status_history
    ADD CONSTRAINT status_history_pkey PRIMARY KEY (id);


--
-- TOC entry 6154 (class 2606 OID 1324157)
-- Name: timelines timelines_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.timelines
    ADD CONSTRAINT timelines_pkey PRIMARY KEY (id);


--
-- TOC entry 6156 (class 2606 OID 1324159)
-- Name: work_streams work_streams_pkey; Type: CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.work_streams
    ADD CONSTRAINT work_streams_pkey PRIMARY KEY (id);


--
-- TOC entry 6628 (class 2606 OID 2015726)
-- Name: ResourceRolePhaseDependency ResourceRolePhaseDependency_pkey; Type: CONSTRAINT; Schema: resources; Owner: resources
--

ALTER TABLE ONLY resources."ResourceRolePhaseDependency"
    ADD CONSTRAINT "ResourceRolePhaseDependency_pkey" PRIMARY KEY (id);


--
-- TOC entry 6616 (class 2606 OID 2015710)
-- Name: ResourceRole ResourceRole_pkey; Type: CONSTRAINT; Schema: resources; Owner: resources
--

ALTER TABLE ONLY resources."ResourceRole"
    ADD CONSTRAINT "ResourceRole_pkey" PRIMARY KEY (id);


--
-- TOC entry 6620 (class 2606 OID 2015718)
-- Name: Resource Resource_pkey; Type: CONSTRAINT; Schema: resources; Owner: resources
--

ALTER TABLE ONLY resources."Resource"
    ADD CONSTRAINT "Resource_pkey" PRIMARY KEY (id);


--
-- TOC entry 6614 (class 2606 OID 2015686)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: resources; Owner: resources
--

ALTER TABLE ONLY resources._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6772 (class 2606 OID 2033645)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6910 (class 2606 OID 2034263)
-- Name: aiWorkflowRunItemComment aiWorkflowRunItemComment_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRunItemComment"
    ADD CONSTRAINT "aiWorkflowRunItemComment_pkey" PRIMARY KEY (id);


--
-- TOC entry 6908 (class 2606 OID 2034254)
-- Name: aiWorkflowRunItem aiWorkflowRunItem_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRunItem"
    ADD CONSTRAINT "aiWorkflowRunItem_pkey" PRIMARY KEY (id);


--
-- TOC entry 6904 (class 2606 OID 2034244)
-- Name: aiWorkflowRun aiWorkflowRun_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRun"
    ADD CONSTRAINT "aiWorkflowRun_pkey" PRIMARY KEY (id);


--
-- TOC entry 6902 (class 2606 OID 2034236)
-- Name: aiWorkflow aiWorkflow_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflow"
    ADD CONSTRAINT "aiWorkflow_pkey" PRIMARY KEY (id);


--
-- TOC entry 6838 (class 2606 OID 2033815)
-- Name: appealResponse appealResponse_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."appealResponse"
    ADD CONSTRAINT "appealResponse_pkey" PRIMARY KEY (id);


--
-- TOC entry 6829 (class 2606 OID 2033806)
-- Name: appeal appeal_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.appeal
    ADD CONSTRAINT appeal_pkey PRIMARY KEY (id);


--
-- TOC entry 6843 (class 2606 OID 2033823)
-- Name: challengeResult challengeResult_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."challengeResult"
    ADD CONSTRAINT "challengeResult_pkey" PRIMARY KEY ("challengeId", "userId");


--
-- TOC entry 6849 (class 2606 OID 2033832)
-- Name: contactRequest contactRequest_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."contactRequest"
    ADD CONSTRAINT "contactRequest_pkey" PRIMARY KEY (id);


--
-- TOC entry 6893 (class 2606 OID 2034200)
-- Name: gitWebhookLog gitWebhookLog_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."gitWebhookLog"
    ADD CONSTRAINT "gitWebhookLog_pkey" PRIMARY KEY (id);


--
-- TOC entry 6899 (class 2606 OID 2034227)
-- Name: llmModel llmModel_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."llmModel"
    ADD CONSTRAINT "llmModel_pkey" PRIMARY KEY (id);


--
-- TOC entry 6896 (class 2606 OID 2034218)
-- Name: llmProvider llmProvider_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."llmProvider"
    ADD CONSTRAINT "llmProvider_pkey" PRIMARY KEY (id);


--
-- TOC entry 6888 (class 2606 OID 2034161)
-- Name: resourceSubmission resourceSubmission_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."resourceSubmission"
    ADD CONSTRAINT "resourceSubmission_pkey" PRIMARY KEY (id);


--
-- TOC entry 6861 (class 2606 OID 2034004)
-- Name: reviewApplication reviewApplication_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewApplication"
    ADD CONSTRAINT "reviewApplication_pkey" PRIMARY KEY (id);


--
-- TOC entry 6912 (class 2606 OID 2034340)
-- Name: reviewAudit reviewAudit_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewAudit"
    ADD CONSTRAINT "reviewAudit_pkey" PRIMARY KEY (id);


--
-- TOC entry 6820 (class 2606 OID 2033797)
-- Name: reviewItemComment reviewItemComment_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewItemComment"
    ADD CONSTRAINT "reviewItemComment_pkey" PRIMARY KEY (id);


--
-- TOC entry 6815 (class 2606 OID 2033787)
-- Name: reviewItem reviewItem_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewItem"
    ADD CONSTRAINT "reviewItem_pkey" PRIMARY KEY (id);


--
-- TOC entry 6855 (class 2606 OID 2033994)
-- Name: reviewOpportunity reviewOpportunity_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewOpportunity"
    ADD CONSTRAINT "reviewOpportunity_pkey" PRIMARY KEY (id);


--
-- TOC entry 6869 (class 2606 OID 2034043)
-- Name: reviewSummation reviewSummation_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewSummation"
    ADD CONSTRAINT "reviewSummation_pkey" PRIMARY KEY (id);


--
-- TOC entry 6867 (class 2606 OID 2034034)
-- Name: reviewType reviewType_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewType"
    ADD CONSTRAINT "reviewType_pkey" PRIMARY KEY (id);


--
-- TOC entry 6928 (class 2606 OID 2066973)
-- Name: review_pending_summary review_pending_summary_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.review_pending_summary
    ADD CONSTRAINT review_pending_summary_pkey PRIMARY KEY ("resourceId");


--
-- TOC entry 6801 (class 2606 OID 2034019)
-- Name: review review_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- TOC entry 6783 (class 2606 OID 2033750)
-- Name: scorecardGroup scorecardGroup_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."scorecardGroup"
    ADD CONSTRAINT "scorecardGroup_pkey" PRIMARY KEY (id);


--
-- TOC entry 6793 (class 2606 OID 2033768)
-- Name: scorecardQuestion scorecardQuestion_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."scorecardQuestion"
    ADD CONSTRAINT "scorecardQuestion_pkey" PRIMARY KEY (id);


--
-- TOC entry 6788 (class 2606 OID 2033759)
-- Name: scorecardSection scorecardSection_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."scorecardSection"
    ADD CONSTRAINT "scorecardSection_pkey" PRIMARY KEY (id);


--
-- TOC entry 6778 (class 2606 OID 2033689)
-- Name: scorecard scorecard_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.scorecard
    ADD CONSTRAINT scorecard_pkey PRIMARY KEY (id);


--
-- TOC entry 6917 (class 2606 OID 2034363)
-- Name: submissionAccessAudit submissionAccessAudit_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."submissionAccessAudit"
    ADD CONSTRAINT "submissionAccessAudit_pkey" PRIMARY KEY (id);


--
-- TOC entry 6880 (class 2606 OID 2034136)
-- Name: submission submission_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.submission
    ADD CONSTRAINT submission_pkey PRIMARY KEY (id);


--
-- TOC entry 6884 (class 2606 OID 2034152)
-- Name: upload upload_pkey; Type: CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- TOC entry 6371 (class 2606 OID 1477242)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 6379 (class 2606 OID 1477244)
-- Name: prod_challenge_emsi_skills challenge_emsi_skills_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.prod_challenge_emsi_skills
    ADD CONSTRAINT challenge_emsi_skills_pkey PRIMARY KEY (emsi_skill_id, challenge_id);


--
-- TOC entry 6373 (class 2606 OID 1477246)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- TOC entry 6381 (class 2606 OID 1477248)
-- Name: prod_job_emsi_skills job_emsi_skills_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.prod_job_emsi_skills
    ADD CONSTRAINT job_emsi_skills_pkey PRIMARY KEY (emsi_skill_id, job_id);


--
-- TOC entry 6377 (class 2606 OID 1477250)
-- Name: legacy_skill_map pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.legacy_skill_map
    ADD CONSTRAINT pkey PRIMARY KEY (legacy_v5_id, skill_id);


--
-- TOC entry 6383 (class 2606 OID 1477252)
-- Name: prod_user_emsi_skills prod_user_emsi_skills_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.prod_user_emsi_skills
    ADD CONSTRAINT prod_user_emsi_skills_pkey PRIMARY KEY (skill_id, user_id);


--
-- TOC entry 6392 (class 2606 OID 1477254)
-- Name: skill_category skill_category_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_category
    ADD CONSTRAINT skill_category_pkey PRIMARY KEY (id);


--
-- TOC entry 6399 (class 2606 OID 1477256)
-- Name: skill_event skill_event_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event
    ADD CONSTRAINT skill_event_pkey PRIMARY KEY (id);


--
-- TOC entry 6403 (class 2606 OID 1477258)
-- Name: skill_event_type skill_event_type_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event_type
    ADD CONSTRAINT skill_event_type_pkey PRIMARY KEY (id);


--
-- TOC entry 6388 (class 2606 OID 1477260)
-- Name: skill skill_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill
    ADD CONSTRAINT skill_pkey PRIMARY KEY (id);


--
-- TOC entry 6407 (class 2606 OID 1477262)
-- Name: skill_replacement skill_replacement_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_replacement
    ADD CONSTRAINT skill_replacement_pkey PRIMARY KEY (skill_id);


--
-- TOC entry 6409 (class 2606 OID 1477264)
-- Name: source_type source_type_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.source_type
    ADD CONSTRAINT source_type_pkey PRIMARY KEY (id);


--
-- TOC entry 6385 (class 2606 OID 1477266)
-- Name: prod_v5_skills temp_prod_v5_skills_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.prod_v5_skills
    ADD CONSTRAINT temp_prod_v5_skills_pkey PRIMARY KEY (id);


--
-- TOC entry 6394 (class 2606 OID 1477268)
-- Name: skill_category uniq_category_name; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_category
    ADD CONSTRAINT uniq_category_name UNIQUE (name);


--
-- TOC entry 6405 (class 2606 OID 1477270)
-- Name: skill_event_type uniq_event_type_name; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event_type
    ADD CONSTRAINT uniq_event_type_name UNIQUE (name);


--
-- TOC entry 6375 (class 2606 OID 1477272)
-- Name: event uniq_payload_hash; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.event
    ADD CONSTRAINT uniq_payload_hash UNIQUE (payload_hash);


--
-- TOC entry 6423 (class 2606 OID 1477274)
-- Name: user_skill_level uniq_skill_level_name; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill_level
    ADD CONSTRAINT uniq_skill_level_name UNIQUE (name);


--
-- TOC entry 6390 (class 2606 OID 1477276)
-- Name: skill uniq_skill_name; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill
    ADD CONSTRAINT uniq_skill_name UNIQUE (name);


--
-- TOC entry 6401 (class 2606 OID 1477278)
-- Name: skill_event uniq_skill_source_id; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event
    ADD CONSTRAINT uniq_skill_source_id UNIQUE (skill_id, skill_event_type_id, source_id, user_id);


--
-- TOC entry 6411 (class 2606 OID 1477280)
-- Name: source_type uniq_source_type_name; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.source_type
    ADD CONSTRAINT uniq_source_type_name UNIQUE (name);


--
-- TOC entry 6415 (class 2606 OID 1477282)
-- Name: user_skill uniq_user_skill_type; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill
    ADD CONSTRAINT uniq_user_skill_type UNIQUE (user_id, skill_id, user_skill_level_id);


--
-- TOC entry 6427 (class 2606 OID 1477284)
-- Name: work_skill uniq_work_skill; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.work_skill
    ADD CONSTRAINT uniq_work_skill UNIQUE (work_id, work_type_id, skill_id);


--
-- TOC entry 6419 (class 2606 OID 1477286)
-- Name: user_skill_display_mode user_skill_display_mode_name_key; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill_display_mode
    ADD CONSTRAINT user_skill_display_mode_name_key UNIQUE (name);


--
-- TOC entry 6421 (class 2606 OID 1477288)
-- Name: user_skill_display_mode user_skill_display_mode_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill_display_mode
    ADD CONSTRAINT user_skill_display_mode_pkey PRIMARY KEY (id);


--
-- TOC entry 6425 (class 2606 OID 1477290)
-- Name: user_skill_level user_skill_level_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill_level
    ADD CONSTRAINT user_skill_level_pkey PRIMARY KEY (id);


--
-- TOC entry 6417 (class 2606 OID 1477292)
-- Name: user_skill user_skill_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill
    ADD CONSTRAINT user_skill_pkey PRIMARY KEY (id);


--
-- TOC entry 6429 (class 2606 OID 1477294)
-- Name: work_skill work_skill_pkey; Type: CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.work_skill
    ADD CONSTRAINT work_skill_pkey PRIMARY KEY (id);


--
-- TOC entry 6369 (class 2606 OID 1475983)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 6345 (class 2606 OID 1475521)
-- Name: interviews interviews_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.interviews
    ADD CONSTRAINT interviews_pkey PRIMARY KEY (id);


--
-- TOC entry 6347 (class 2606 OID 1475523)
-- Name: job_candidates job_candidates_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.job_candidates
    ADD CONSTRAINT job_candidates_pkey PRIMARY KEY (id);


--
-- TOC entry 6349 (class 2606 OID 1475525)
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 6353 (class 2606 OID 1475527)
-- Name: payment_schedulers payment_schedulers_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.payment_schedulers
    ADD CONSTRAINT payment_schedulers_pkey PRIMARY KEY (id);


--
-- TOC entry 6351 (class 2606 OID 1475529)
-- Name: legacy_skill_map pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.legacy_skill_map
    ADD CONSTRAINT pkey PRIMARY KEY (legacy_v5_id, skill_id);


--
-- TOC entry 6355 (class 2606 OID 1475531)
-- Name: resource_bookings resource_bookings_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.resource_bookings
    ADD CONSTRAINT resource_bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 6357 (class 2606 OID 1475533)
-- Name: role_search_requests role_search_requests_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.role_search_requests
    ADD CONSTRAINT role_search_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 6360 (class 2606 OID 1475535)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 6362 (class 2606 OID 1475537)
-- Name: user_meeting_settings user_meeting_settings_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.user_meeting_settings
    ADD CONSTRAINT user_meeting_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 6364 (class 2606 OID 1475539)
-- Name: work_period_payments work_period_payments_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.work_period_payments
    ADD CONSTRAINT work_period_payments_pkey PRIMARY KEY (id);


--
-- TOC entry 6366 (class 2606 OID 1475541)
-- Name: work_periods work_periods_pkey; Type: CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.work_periods
    ADD CONSTRAINT work_periods_pkey PRIMARY KEY (id);


--
-- TOC entry 6299 (class 2606 OID 1363482)
-- Name: DocusignEnvelope DocusignEnvelope_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."DocusignEnvelope"
    ADD CONSTRAINT "DocusignEnvelope_pkey" PRIMARY KEY (id);


--
-- TOC entry 6301 (class 2606 OID 1363484)
-- Name: TermsForResource TermsForResource_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsForResource"
    ADD CONSTRAINT "TermsForResource_pkey" PRIMARY KEY (id);


--
-- TOC entry 6308 (class 2606 OID 1363486)
-- Name: TermsOfUseAgreeabilityType TermsOfUseAgreeabilityType_legacyId_key; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUseAgreeabilityType"
    ADD CONSTRAINT "TermsOfUseAgreeabilityType_legacyId_key" UNIQUE ("legacyId");


--
-- TOC entry 6310 (class 2606 OID 1363488)
-- Name: TermsOfUseAgreeabilityType TermsOfUseAgreeabilityType_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUseAgreeabilityType"
    ADD CONSTRAINT "TermsOfUseAgreeabilityType_pkey" PRIMARY KEY (id);


--
-- TOC entry 6312 (class 2606 OID 1363490)
-- Name: TermsOfUseDependency TermsOfUseDependency_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUseDependency"
    ADD CONSTRAINT "TermsOfUseDependency_pkey" PRIMARY KEY ("dependencyTermsOfUseId", "dependentTermsOfUseId");


--
-- TOC entry 6316 (class 2606 OID 1363492)
-- Name: TermsOfUseDocusignTemplateXref TermsOfUseDocusignTemplateXref_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUseDocusignTemplateXref"
    ADD CONSTRAINT "TermsOfUseDocusignTemplateXref_pkey" PRIMARY KEY ("termsOfUseId");


--
-- TOC entry 6304 (class 2606 OID 1363494)
-- Name: TermsOfUse TermsOfUse_legacyId_key; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUse"
    ADD CONSTRAINT "TermsOfUse_legacyId_key" UNIQUE ("legacyId");


--
-- TOC entry 6306 (class 2606 OID 1363496)
-- Name: TermsOfUse TermsOfUse_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUse"
    ADD CONSTRAINT "TermsOfUse_pkey" PRIMARY KEY (id);


--
-- TOC entry 6320 (class 2606 OID 1363498)
-- Name: UserTermsOfUseBanXref UserTermsOfUseBanXref_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."UserTermsOfUseBanXref"
    ADD CONSTRAINT "UserTermsOfUseBanXref_pkey" PRIMARY KEY ("userId", "termsOfUseId");


--
-- TOC entry 6324 (class 2606 OID 1363500)
-- Name: UserTermsOfUseXref UserTermsOfUseXref_pkey; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."UserTermsOfUseXref"
    ADD CONSTRAINT "UserTermsOfUseXref_pkey" PRIMARY KEY ("userId", "termsOfUseId");


--
-- TOC entry 6318 (class 2606 OID 1363502)
-- Name: TermsOfUseType termsofusetype_pk; Type: CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUseType"
    ADD CONSTRAINT termsofusetype_pk PRIMARY KEY (id);


--
-- TOC entry 6254 (class 2606 OID 1352769)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: timeline; Owner: topcoder
--

ALTER TABLE ONLY timeline.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 6255 (class 1259 OID 1363247)
-- Name: CertificationCategory_category_key; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX "CertificationCategory_category_key" ON academy."CertificationCategory" USING btree (category);


--
-- TOC entry 6258 (class 1259 OID 1363248)
-- Name: CertificationEnrollments_completionUuid; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX "CertificationEnrollments_completionUuid" ON academy."CertificationEnrollments" USING btree ("completionUuid");


--
-- TOC entry 6282 (class 1259 OID 1363249)
-- Name: FreeCodeCampCertification_fccId_key; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX "FreeCodeCampCertification_fccId_key" ON academy."FreeCodeCampCertification" USING btree ("fccId");


--
-- TOC entry 6285 (class 1259 OID 1363250)
-- Name: FreeCodeCampCertification_title_key; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX "FreeCodeCampCertification_title_key" ON academy."FreeCodeCampCertification" USING btree (title);


--
-- TOC entry 6286 (class 1259 OID 1363251)
-- Name: ResourceProvider_name_key; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX "ResourceProvider_name_key" ON academy."ResourceProvider" USING btree (name);


--
-- TOC entry 6293 (class 1259 OID 1363252)
-- Name: TopcoderCertification_title_key; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX "TopcoderCertification_title_key" ON academy."TopcoderCertification" USING btree (title);


--
-- TOC entry 6261 (class 1259 OID 1363253)
-- Name: certification_enrollments_topcoder_certification_id_user_id; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX certification_enrollments_topcoder_certification_id_user_id ON academy."CertificationEnrollments" USING btree ("topcoderCertificationId", "userId");


--
-- TOC entry 6270 (class 1259 OID 1363254)
-- Name: fcc_certification_progresses_fcc_certification_id_user_id; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX fcc_certification_progresses_fcc_certification_id_user_id ON academy."FccCertificationProgresses" USING btree ("fccCertificationId", "userId");


--
-- TOC entry 6281 (class 1259 OID 1363255)
-- Name: fcc_modules_key; Type: INDEX; Schema: academy; Owner: topcoder
--

CREATE UNIQUE INDEX fcc_modules_key ON academy."FccModules" USING btree (key);


--
-- TOC entry 6926 (class 1259 OID 2061249)
-- Name: idx_autopilot_actions_challenge; Type: INDEX; Schema: autopilot; Owner: autopilot
--

CREATE INDEX idx_autopilot_actions_challenge ON autopilot.actions USING btree ("challengeId");


--
-- TOC entry 6952 (class 1259 OID 2070005)
-- Name: BillingAccountAccess_billingAccountId_userId_key; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE UNIQUE INDEX "BillingAccountAccess_billingAccountId_userId_key" ON "billing-accounts"."BillingAccountAccess" USING btree ("billingAccountId", "userId");


--
-- TOC entry 6955 (class 1259 OID 2069969)
-- Name: BillingAccountAccess_userId_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "BillingAccountAccess_userId_idx" ON "billing-accounts"."BillingAccountAccess" USING btree ("userId");


--
-- TOC entry 6938 (class 1259 OID 2069961)
-- Name: BillingAccount_clientId_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "BillingAccount_clientId_idx" ON "billing-accounts"."BillingAccount" USING btree ("clientId");


--
-- TOC entry 6939 (class 1259 OID 2069964)
-- Name: BillingAccount_createdBy_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "BillingAccount_createdBy_idx" ON "billing-accounts"."BillingAccount" USING btree ("createdBy");


--
-- TOC entry 6942 (class 1259 OID 2069963)
-- Name: BillingAccount_startDate_endDate_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "BillingAccount_startDate_endDate_idx" ON "billing-accounts"."BillingAccount" USING btree ("startDate", "endDate");


--
-- TOC entry 6943 (class 1259 OID 2069962)
-- Name: BillingAccount_status_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "BillingAccount_status_idx" ON "billing-accounts"."BillingAccount" USING btree (status);


--
-- TOC entry 6932 (class 1259 OID 2069958)
-- Name: Client_codeName_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "Client_codeName_idx" ON "billing-accounts"."Client" USING btree ("codeName");


--
-- TOC entry 6933 (class 1259 OID 2069957)
-- Name: Client_name_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "Client_name_idx" ON "billing-accounts"."Client" USING btree (name);


--
-- TOC entry 6936 (class 1259 OID 2069960)
-- Name: Client_startDate_endDate_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "Client_startDate_endDate_idx" ON "billing-accounts"."Client" USING btree ("startDate", "endDate");


--
-- TOC entry 6937 (class 1259 OID 2069959)
-- Name: Client_status_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "Client_status_idx" ON "billing-accounts"."Client" USING btree (status);


--
-- TOC entry 6948 (class 1259 OID 2070007)
-- Name: ConsumedAmount_billingAccountId_challengeId_key; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE UNIQUE INDEX "ConsumedAmount_billingAccountId_challengeId_key" ON "billing-accounts"."ConsumedAmount" USING btree ("billingAccountId", "challengeId");


--
-- TOC entry 6949 (class 1259 OID 2070006)
-- Name: ConsumedAmount_billingAccountId_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "ConsumedAmount_billingAccountId_idx" ON "billing-accounts"."ConsumedAmount" USING btree ("billingAccountId");


--
-- TOC entry 6944 (class 1259 OID 2070009)
-- Name: LockedAmount_billingAccountId_challengeId_key; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE UNIQUE INDEX "LockedAmount_billingAccountId_challengeId_key" ON "billing-accounts"."LockedAmount" USING btree ("billingAccountId", "challengeId");


--
-- TOC entry 6945 (class 1259 OID 2070008)
-- Name: LockedAmount_billingAccountId_idx; Type: INDEX; Schema: billing-accounts; Owner: billingaccounts
--

CREATE INDEX "LockedAmount_billingAccountId_idx" ON "billing-accounts"."LockedAmount" USING btree ("billingAccountId");


--
-- TOC entry 6538 (class 1259 OID 2005104)
-- Name: AuditLog_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "AuditLog_challengeId_idx" ON challenges."AuditLog" USING btree ("challengeId");


--
-- TOC entry 6558 (class 1259 OID 2005107)
-- Name: ChallengeBilling_challengeId_key; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE UNIQUE INDEX "ChallengeBilling_challengeId_key" ON challenges."ChallengeBilling" USING btree ("challengeId");


--
-- TOC entry 6574 (class 1259 OID 2005111)
-- Name: ChallengeConstraint_challengeId_key; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE UNIQUE INDEX "ChallengeConstraint_challengeId_key" ON challenges."ChallengeConstraint" USING btree ("challengeId");


--
-- TOC entry 6569 (class 1259 OID 2005110)
-- Name: ChallengeDiscussion_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeDiscussion_challengeId_idx" ON challenges."ChallengeDiscussion" USING btree ("challengeId");


--
-- TOC entry 6566 (class 1259 OID 2005109)
-- Name: ChallengeEvent_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeEvent_challengeId_idx" ON challenges."ChallengeEvent" USING btree ("challengeId");


--
-- TOC entry 6563 (class 1259 OID 2005108)
-- Name: ChallengeLegacy_challengeId_key; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE UNIQUE INDEX "ChallengeLegacy_challengeId_key" ON challenges."ChallengeLegacy" USING btree ("challengeId");


--
-- TOC entry 6543 (class 1259 OID 2005105)
-- Name: ChallengeMetadata_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeMetadata_challengeId_idx" ON challenges."ChallengeMetadata" USING btree ("challengeId");


--
-- TOC entry 6587 (class 1259 OID 2005114)
-- Name: ChallengePhaseConstraint_challengePhaseId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengePhaseConstraint_challengePhaseId_idx" ON challenges."ChallengePhaseConstraint" USING btree ("challengePhaseId");


--
-- TOC entry 6580 (class 1259 OID 2005113)
-- Name: ChallengePhase_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengePhase_challengeId_idx" ON challenges."ChallengePhase" USING btree ("challengeId");


--
-- TOC entry 6581 (class 1259 OID 2108445)
-- Name: ChallengePhase_challengeId_isOpen_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengePhase_challengeId_isOpen_idx" ON challenges."ChallengePhase" USING btree ("challengeId", "isOpen");


--
-- TOC entry 6582 (class 1259 OID 2108446)
-- Name: ChallengePhase_challengeId_name_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengePhase_challengeId_name_idx" ON challenges."ChallengePhase" USING btree ("challengeId", name);


--
-- TOC entry 6590 (class 1259 OID 2005115)
-- Name: ChallengePrizeSet_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengePrizeSet_challengeId_idx" ON challenges."ChallengePrizeSet" USING btree ("challengeId");


--
-- TOC entry 6591 (class 1259 OID 2108447)
-- Name: ChallengePrizeSet_challengeId_type_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengePrizeSet_challengeId_type_idx" ON challenges."ChallengePrizeSet" USING btree ("challengeId", type);


--
-- TOC entry 6602 (class 1259 OID 2005259)
-- Name: ChallengeReviewer_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeReviewer_challengeId_idx" ON challenges."ChallengeReviewer" USING btree ("challengeId");


--
-- TOC entry 6603 (class 1259 OID 2108448)
-- Name: ChallengeReviewer_challengeId_phaseId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeReviewer_challengeId_phaseId_idx" ON challenges."ChallengeReviewer" USING btree ("challengeId", "phaseId");


--
-- TOC entry 6604 (class 1259 OID 2005260)
-- Name: ChallengeReviewer_phaseId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeReviewer_phaseId_idx" ON challenges."ChallengeReviewer" USING btree ("phaseId");


--
-- TOC entry 6537 (class 1259 OID 2005103)
-- Name: ChallengeTimelineTemplate_typeId_trackId_timelineTemplateId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeTimelineTemplate_typeId_trackId_timelineTemplateId_idx" ON challenges."ChallengeTimelineTemplate" USING btree ("typeId", "trackId", "timelineTemplateId");


--
-- TOC entry 6532 (class 1259 OID 2005102)
-- Name: ChallengeTrack_legacyId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeTrack_legacyId_idx" ON challenges."ChallengeTrack" USING btree ("legacyId");


--
-- TOC entry 6529 (class 1259 OID 2005101)
-- Name: ChallengeType_abbreviation_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeType_abbreviation_idx" ON challenges."ChallengeType" USING btree (abbreviation);


--
-- TOC entry 6550 (class 1259 OID 2005106)
-- Name: ChallengeWinner_challengeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeWinner_challengeId_idx" ON challenges."ChallengeWinner" USING btree ("challengeId");


--
-- TOC entry 6551 (class 1259 OID 2108449)
-- Name: ChallengeWinner_challengeId_type_placement_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "ChallengeWinner_challengeId_type_placement_idx" ON challenges."ChallengeWinner" USING btree ("challengeId", type, placement);


--
-- TOC entry 6508 (class 1259 OID 2005261)
-- Name: Challenge_createdAt_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_createdAt_idx" ON challenges."Challenge" USING btree ("createdAt");


--
-- TOC entry 6509 (class 1259 OID 2005270)
-- Name: Challenge_endDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_endDate_idx" ON challenges."Challenge" USING btree ("endDate");


--
-- TOC entry 6510 (class 1259 OID 2108443)
-- Name: Challenge_legacyId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_legacyId_idx" ON challenges."Challenge" USING btree ("legacyId");


--
-- TOC entry 6513 (class 1259 OID 2005099)
-- Name: Challenge_projectId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_projectId_idx" ON challenges."Challenge" USING btree ("projectId");


--
-- TOC entry 6514 (class 1259 OID 2108444)
-- Name: Challenge_projectId_status_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_projectId_status_idx" ON challenges."Challenge" USING btree ("projectId", status);


--
-- TOC entry 6515 (class 1259 OID 2005268)
-- Name: Challenge_registrationEndDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_registrationEndDate_idx" ON challenges."Challenge" USING btree ("registrationEndDate");


--
-- TOC entry 6516 (class 1259 OID 2005267)
-- Name: Challenge_registrationStartDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_registrationStartDate_idx" ON challenges."Challenge" USING btree ("registrationStartDate");


--
-- TOC entry 6517 (class 1259 OID 2005269)
-- Name: Challenge_startDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_startDate_idx" ON challenges."Challenge" USING btree ("startDate");


--
-- TOC entry 6518 (class 1259 OID 2005100)
-- Name: Challenge_status_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_status_idx" ON challenges."Challenge" USING btree (status);


--
-- TOC entry 6519 (class 1259 OID 2108441)
-- Name: Challenge_status_startDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_status_startDate_idx" ON challenges."Challenge" USING btree (status, "startDate");


--
-- TOC entry 6520 (class 1259 OID 2005266)
-- Name: Challenge_submissionEndDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_submissionEndDate_idx" ON challenges."Challenge" USING btree ("submissionEndDate");


--
-- TOC entry 6521 (class 1259 OID 2005265)
-- Name: Challenge_submissionStartDate_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_submissionStartDate_idx" ON challenges."Challenge" USING btree ("submissionStartDate");


--
-- TOC entry 6522 (class 1259 OID 2005264)
-- Name: Challenge_trackId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_trackId_idx" ON challenges."Challenge" USING btree ("trackId");


--
-- TOC entry 6523 (class 1259 OID 2108442)
-- Name: Challenge_trackId_typeId_status_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_trackId_typeId_status_idx" ON challenges."Challenge" USING btree ("trackId", "typeId", status);


--
-- TOC entry 6524 (class 1259 OID 2005263)
-- Name: Challenge_typeId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_typeId_idx" ON challenges."Challenge" USING btree ("typeId");


--
-- TOC entry 6525 (class 1259 OID 2005262)
-- Name: Challenge_updatedAt_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "Challenge_updatedAt_idx" ON challenges."Challenge" USING btree ("updatedAt");


--
-- TOC entry 6608 (class 1259 OID 2005332)
-- Name: DefaultChallengeReviewer_phaseId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "DefaultChallengeReviewer_phaseId_idx" ON challenges."DefaultChallengeReviewer" USING btree ("phaseId");


--
-- TOC entry 6611 (class 1259 OID 2005301)
-- Name: DefaultChallengeReviewer_typeId_trackId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "DefaultChallengeReviewer_typeId_trackId_idx" ON challenges."DefaultChallengeReviewer" USING btree ("typeId", "trackId");


--
-- TOC entry 6612 (class 1259 OID 2005347)
-- Name: DefaultChallengeReviewer_typeId_trackId_timelineTemplateId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "DefaultChallengeReviewer_typeId_trackId_timelineTemplateId_idx" ON challenges."DefaultChallengeReviewer" USING btree ("typeId", "trackId", "timelineTemplateId");


--
-- TOC entry 6577 (class 1259 OID 2005112)
-- Name: Phase_name_key; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE UNIQUE INDEX "Phase_name_key" ON challenges."Phase" USING btree (name);


--
-- TOC entry 6600 (class 1259 OID 2005117)
-- Name: TimelineTemplatePhase_timelineTemplateId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "TimelineTemplatePhase_timelineTemplateId_idx" ON challenges."TimelineTemplatePhase" USING btree ("timelineTemplateId");


--
-- TOC entry 6601 (class 1259 OID 2108450)
-- Name: TimelineTemplatePhase_timelineTemplateId_phaseId_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX "TimelineTemplatePhase_timelineTemplateId_phaseId_idx" ON challenges."TimelineTemplatePhase" USING btree ("timelineTemplateId", "phaseId");


--
-- TOC entry 6595 (class 1259 OID 2005116)
-- Name: TimelineTemplate_name_key; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE UNIQUE INDEX "TimelineTemplate_name_key" ON challenges."TimelineTemplate" USING btree (name);


--
-- TOC entry 6526 (class 1259 OID 2110947)
-- Name: challenge_groups_gin_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challenge_groups_gin_idx ON challenges."Challenge" USING gin (groups);


--
-- TOC entry 6527 (class 1259 OID 2067393)
-- Name: challenge_past_status_end_date_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challenge_past_status_end_date_idx ON challenges."Challenge" USING btree ("endDate" DESC NULLS LAST, "createdAt" DESC NULLS LAST, name) WHERE (status = ANY (ARRAY['COMPLETED'::challenges."ChallengeStatusEnum", 'CANCELLED'::challenges."ChallengeStatusEnum", 'CANCELLED_FAILED_REVIEW'::challenges."ChallengeStatusEnum", 'CANCELLED_FAILED_SCREENING'::challenges."ChallengeStatusEnum", 'CANCELLED_ZERO_SUBMISSIONS'::challenges."ChallengeStatusEnum", 'CANCELLED_CLIENT_REQUEST'::challenges."ChallengeStatusEnum"]));


--
-- TOC entry 6585 (class 1259 OID 2108453)
-- Name: challenge_phase_challenge_open_end_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challenge_phase_challenge_open_end_idx ON challenges."ChallengePhase" USING btree ("challengeId", "isOpen", "scheduledEndDate", "actualEndDate");


--
-- TOC entry 6586 (class 1259 OID 2066783)
-- Name: challenge_phase_challengeid_isopen_dates_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challenge_phase_challengeid_isopen_dates_idx ON challenges."ChallengePhase" USING btree ("challengeId", "isOpen", "scheduledEndDate", "actualEndDate", name);


--
-- TOC entry 6607 (class 1259 OID 2066784)
-- Name: challenge_reviewer_ai_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challenge_reviewer_ai_idx ON challenges."ChallengeReviewer" USING btree ("challengeId") WHERE ("aiWorkflowId" IS NOT NULL);


--
-- TOC entry 6528 (class 1259 OID 2108451)
-- Name: challenge_status_type_track_created_at_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challenge_status_type_track_created_at_idx ON challenges."Challenge" USING btree (status, "typeId", "trackId", "createdAt" DESC);


--
-- TOC entry 6561 (class 1259 OID 2071823)
-- Name: challengebilling_baid_challenge_idx; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX challengebilling_baid_challenge_idx ON challenges."ChallengeBilling" USING btree ("billingAccountId", "challengeId");


--
-- TOC entry 6546 (class 1259 OID 2071997)
-- Name: idx_challenge_metadata_name_challenge; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX idx_challenge_metadata_name_challenge ON challenges."ChallengeMetadata" USING btree (name, "challengeId") WHERE (name = ANY (ARRAY['onsite_efforts'::text, 'offsite_efforts'::text]));


--
-- TOC entry 6594 (class 1259 OID 2072099)
-- Name: idx_challenge_prize_set_challenge; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX idx_challenge_prize_set_challenge ON challenges."ChallengePrizeSet" USING btree ("challengeId");


--
-- TOC entry 6562 (class 1259 OID 2071791)
-- Name: idx_challengebilling_baid_challenge_id; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX idx_challengebilling_baid_challenge_id ON challenges."ChallengeBilling" USING btree ("billingAccountId", "challengeId");


--
-- TOC entry 6549 (class 1259 OID 2072098)
-- Name: idx_prize_prize_set_id; Type: INDEX; Schema: challenges; Owner: challenges
--

CREATE INDEX idx_prize_prize_set_id ON challenges."Prize" USING btree ("prizeSetId");


--
-- TOC entry 6167 (class 1259 OID 2021429)
-- Name: idx_payment_installment_number; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_installment_number ON finance.payment USING btree (installment_number);


--
-- TOC entry 6168 (class 1259 OID 2021456)
-- Name: idx_payment_installment_status_version; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_installment_status_version ON finance.payment USING btree (installment_number, payment_status, winnings_id, version DESC);


--
-- TOC entry 6169 (class 1259 OID 2021322)
-- Name: idx_payment_status_winnings; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_status_winnings ON finance.payment USING btree (payment_status, winnings_id);


--
-- TOC entry 6170 (class 1259 OID 2021406)
-- Name: idx_payment_win_inst_status; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_win_inst_status ON finance.payment USING btree (winnings_id, installment_number, payment_status);


--
-- TOC entry 6171 (class 1259 OID 2021433)
-- Name: idx_payment_winnings_id; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_winnings_id ON finance.payment USING btree (winnings_id);


--
-- TOC entry 6172 (class 1259 OID 2021383)
-- Name: idx_payment_winnings_installment; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_winnings_installment ON finance.payment USING btree (winnings_id, installment_number);


--
-- TOC entry 6173 (class 1259 OID 2021291)
-- Name: idx_payment_winnings_installment1_status; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_payment_winnings_installment1_status ON finance.payment USING btree (winnings_id, payment_status) WHERE (installment_number = 1);


--
-- TOC entry 6186 (class 1259 OID 2021405)
-- Name: idx_winnings_category_created_at; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_winnings_category_created_at ON finance.winnings USING btree (category, created_at DESC);


--
-- TOC entry 6187 (class 1259 OID 2021403)
-- Name: idx_winnings_created_at; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_winnings_created_at ON finance.winnings USING btree (created_at DESC);


--
-- TOC entry 6188 (class 1259 OID 2021290)
-- Name: idx_winnings_external_id; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_winnings_external_id ON finance.winnings USING btree (external_id) WHERE (external_id IS NOT NULL);


--
-- TOC entry 6189 (class 1259 OID 2021289)
-- Name: idx_winnings_winner_created_at; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_winnings_winner_created_at ON finance.winnings USING btree (winner_id, created_at DESC);


--
-- TOC entry 6190 (class 1259 OID 2021372)
-- Name: idx_winnings_winner_id_only; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX idx_winnings_winner_id_only ON finance.winnings USING btree (winner_id) INCLUDE (winning_id);


--
-- TOC entry 6176 (class 1259 OID 1334658)
-- Name: payment_method_payment_method_type_key; Type: INDEX; Schema: finance; Owner: finance
--

CREATE UNIQUE INDEX payment_method_payment_method_type_key ON finance.payment_method USING btree (payment_method_type);


--
-- TOC entry 6206 (class 1259 OID 1334785)
-- Name: trolley_recipient_payment_method_recipient_account_id_key; Type: INDEX; Schema: finance; Owner: finance
--

CREATE UNIQUE INDEX trolley_recipient_payment_method_recipient_account_id_key ON finance.trolley_recipient_payment_method USING btree (recipient_account_id);


--
-- TOC entry 6200 (class 1259 OID 1334759)
-- Name: trolley_recipient_trolley_id_key; Type: INDEX; Schema: finance; Owner: finance
--

CREATE UNIQUE INDEX trolley_recipient_trolley_id_key ON finance.trolley_recipient USING btree (trolley_id);


--
-- TOC entry 6201 (class 1259 OID 1334758)
-- Name: trolley_recipient_user_id_key; Type: INDEX; Schema: finance; Owner: finance
--

CREATE UNIQUE INDEX trolley_recipient_user_id_key ON finance.trolley_recipient USING btree (user_id);


--
-- TOC entry 6195 (class 1259 OID 1334750)
-- Name: trolley_webhook_log_event_id_key; Type: INDEX; Schema: finance; Owner: finance
--

CREATE UNIQUE INDEX trolley_webhook_log_event_id_key ON finance.trolley_webhook_log USING btree (event_id);


--
-- TOC entry 6185 (class 1259 OID 1334661)
-- Name: user_payment_methods_user_id_payment_method_id_key; Type: INDEX; Schema: finance; Owner: finance
--

CREATE UNIQUE INDEX user_payment_methods_user_id_payment_method_id_key ON finance.user_payment_methods USING btree (user_id, payment_method_id);


--
-- TOC entry 6191 (class 1259 OID 2071795)
-- Name: winnings_external_id_created_idx; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX winnings_external_id_created_idx ON finance.winnings USING btree (external_id, created_at);


--
-- TOC entry 6192 (class 1259 OID 2071826)
-- Name: winnings_external_winner_idx; Type: INDEX; Schema: finance; Owner: finance
--

CREATE INDEX winnings_external_winner_idx ON finance.winnings USING btree (external_id, winner_id);


--
-- TOC entry 6968 (class 1259 OID 2070312)
-- Name: GroupMember_groupId_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "GroupMember_groupId_idx" ON groups."GroupMember" USING btree ("groupId");


--
-- TOC entry 6969 (class 1259 OID 2070314)
-- Name: GroupMember_groupId_memberId_key; Type: INDEX; Schema: groups; Owner: groups
--

CREATE UNIQUE INDEX "GroupMember_groupId_memberId_key" ON groups."GroupMember" USING btree ("groupId", "memberId");


--
-- TOC entry 6970 (class 1259 OID 2070313)
-- Name: GroupMember_memberId_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "GroupMember_memberId_idx" ON groups."GroupMember" USING btree ("memberId");


--
-- TOC entry 6971 (class 1259 OID 2070335)
-- Name: GroupMember_memberId_membershipType_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "GroupMember_memberId_membershipType_idx" ON groups."GroupMember" USING btree ("memberId", "membershipType");


--
-- TOC entry 6958 (class 1259 OID 2070332)
-- Name: Group_domain_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_domain_idx" ON groups."Group" USING btree (domain);


--
-- TOC entry 6959 (class 1259 OID 2070309)
-- Name: Group_name_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_name_idx" ON groups."Group" USING btree (name);


--
-- TOC entry 6960 (class 1259 OID 2070308)
-- Name: Group_name_key; Type: INDEX; Schema: groups; Owner: groups
--

CREATE UNIQUE INDEX "Group_name_key" ON groups."Group" USING btree (name);


--
-- TOC entry 6961 (class 1259 OID 2070311)
-- Name: Group_oldId_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_oldId_idx" ON groups."Group" USING btree ("oldId");


--
-- TOC entry 6964 (class 1259 OID 2070334)
-- Name: Group_privateGroup_status_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_privateGroup_status_idx" ON groups."Group" USING btree ("privateGroup", status);


--
-- TOC entry 6965 (class 1259 OID 2070333)
-- Name: Group_ssoId_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_ssoId_idx" ON groups."Group" USING btree ("ssoId");


--
-- TOC entry 6966 (class 1259 OID 2070310)
-- Name: Group_status_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_status_idx" ON groups."Group" USING btree (status);


--
-- TOC entry 6967 (class 1259 OID 2070331)
-- Name: Group_status_organizationId_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "Group_status_organizationId_idx" ON groups."Group" USING btree (status, "organizationId");


--
-- TOC entry 6976 (class 1259 OID 2070336)
-- Name: User_universalUID_idx; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "User_universalUID_idx" ON groups."User" USING btree ("universalUID");


--
-- TOC entry 6979 (class 1259 OID 2070315)
-- Name: _ParentSubGroups_B_index; Type: INDEX; Schema: groups; Owner: groups
--

CREATE INDEX "_ParentSubGroups_B_index" ON groups."_ParentSubGroups" USING btree ("B");


--
-- TOC entry 6495 (class 1259 OID 1832072)
-- Name: client_client_id_key; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX client_client_id_key ON identity.client USING btree (client_id);


--
-- TOC entry 6438 (class 1259 OID 1832058)
-- Name: dice_connection_connection_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX dice_connection_connection_idx ON identity.dice_connection USING btree (connection);


--
-- TOC entry 6441 (class 1259 OID 1832057)
-- Name: dice_connection_user_id_key; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX dice_connection_user_id_key ON identity.dice_connection USING btree (user_id);


--
-- TOC entry 6442 (class 1259 OID 1832060)
-- Name: email_user_id_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX email_user_id_idx ON identity.email USING btree (user_id, primary_ind);


--
-- TOC entry 6483 (class 1259 OID 1832070)
-- Name: idx_user_social_login_sso_user_id_provider_id; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX idx_user_social_login_sso_user_id_provider_id ON identity.user_sso_login USING btree (sso_user_id, provider_id);


--
-- TOC entry 6503 (class 1259 OID 1832075)
-- Name: role_id_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX role_id_idx ON identity.role_assignment USING btree (role_id);


--
-- TOC entry 6498 (class 1259 OID 1832073)
-- Name: role_name_key; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX role_name_key ON identity.role USING btree (name);


--
-- TOC entry 6504 (class 1259 OID 1832076)
-- Name: role_subject_id_subject_type; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX role_subject_id_subject_type ON identity.role_assignment USING btree (role_id, subject_id, subject_type);


--
-- TOC entry 6459 (class 1259 OID 1832061)
-- Name: security_user_i2; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX security_user_i2 ON identity.security_user USING btree (user_id);


--
-- TOC entry 6505 (class 1259 OID 1832074)
-- Name: subject_id_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX subject_id_idx ON identity.role_assignment USING btree (subject_id);


--
-- TOC entry 6472 (class 1259 OID 1832067)
-- Name: user_2fa_user_id_key; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX user_2fa_user_id_key ON identity.user_2fa USING btree (user_id);


--
-- TOC entry 6466 (class 1259 OID 1832062)
-- Name: user_activ_code_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX user_activ_code_idx ON identity."user" USING btree (activation_code);


--
-- TOC entry 6492 (class 1259 OID 1832071)
-- Name: user_email_xref_email_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX user_email_xref_email_idx ON identity.user_email_xref USING btree (email_id);


--
-- TOC entry 6477 (class 1259 OID 1832068)
-- Name: user_grp_xref_i2; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX user_grp_xref_i2 ON identity.user_group_xref USING btree (login_id, group_id);


--
-- TOC entry 6467 (class 1259 OID 1832063)
-- Name: user_handle_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX user_handle_idx ON identity."user" USING btree (handle);


--
-- TOC entry 6468 (class 1259 OID 1832064)
-- Name: user_lower_handle_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX user_lower_handle_idx ON identity."user" USING btree (handle_lower);


--
-- TOC entry 6469 (class 1259 OID 1832065)
-- Name: user_open_id_idx; Type: INDEX; Schema: identity; Owner: identity
--

CREATE INDEX user_open_id_idx ON identity."user" USING btree (open_id);


--
-- TOC entry 6480 (class 1259 OID 1832069)
-- Name: user_otp_email_user_id_mode_key; Type: INDEX; Schema: identity; Owner: identity
--

CREATE UNIQUE INDEX user_otp_email_user_id_mode_key ON identity.user_otp_email USING btree (user_id, mode);


--
-- TOC entry 6761 (class 1259 OID 2029922)
-- Name: Country_countryCode_key; Type: INDEX; Schema: lookups; Owner: lookups
--

CREATE UNIQUE INDEX "Country_countryCode_key" ON lookups."Country" USING btree ("countryCode");


--
-- TOC entry 6762 (class 1259 OID 2029919)
-- Name: Country_name_key; Type: INDEX; Schema: lookups; Owner: lookups
--

CREATE UNIQUE INDEX "Country_name_key" ON lookups."Country" USING btree (name);


--
-- TOC entry 6767 (class 1259 OID 2029920)
-- Name: Device_type_manufacturer_model_operatingSystem_operatingSys_key; Type: INDEX; Schema: lookups; Owner: lookups
--

CREATE UNIQUE INDEX "Device_type_manufacturer_model_operatingSystem_operatingSys_key" ON lookups."Device" USING btree (type, manufacturer, model, "operatingSystem", "operatingSystemVersion");


--
-- TOC entry 6768 (class 1259 OID 2029921)
-- Name: EducationalInstitution_name_key; Type: INDEX; Schema: lookups; Owner: lookups
--

CREATE UNIQUE INDEX "EducationalInstitution_name_key" ON lookups."EducationalInstitution" USING btree (name);


--
-- TOC entry 6653 (class 1259 OID 2023950)
-- Name: distributionStats_track_subTrack_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "distributionStats_track_subTrack_key" ON members."distributionStats" USING btree (track, "subTrack");


--
-- TOC entry 6632 (class 1259 OID 2072054)
-- Name: idx_member_userid_text; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX idx_member_userid_text ON members.member USING btree ((("userId")::text));


--
-- TOC entry 6645 (class 1259 OID 2023947)
-- Name: memberAddress_userId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberAddress_userId_idx" ON members."memberAddress" USING btree ("userId");


--
-- TOC entry 6646 (class 1259 OID 2028538)
-- Name: memberAddress_userId_type_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberAddress_userId_type_idx" ON members."memberAddress" USING btree ("userId", type);


--
-- TOC entry 6671 (class 1259 OID 2023956)
-- Name: memberCopilotStats_memberStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberCopilotStats_memberStatsId_idx" ON members."memberCopilotStats" USING btree ("memberStatsId");


--
-- TOC entry 6672 (class 1259 OID 2023957)
-- Name: memberCopilotStats_memberStatsId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberCopilotStats_memberStatsId_key" ON members."memberCopilotStats" USING btree ("memberStatsId");


--
-- TOC entry 6664 (class 1259 OID 2023954)
-- Name: memberDataScienceHistoryStats_historyStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDataScienceHistoryStats_historyStatsId_idx" ON members."memberDataScienceHistoryStats" USING btree ("historyStatsId");


--
-- TOC entry 6691 (class 1259 OID 2023967)
-- Name: memberDataScienceStats_memberStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDataScienceStats_memberStatsId_idx" ON members."memberDataScienceStats" USING btree ("memberStatsId");


--
-- TOC entry 6692 (class 1259 OID 2023966)
-- Name: memberDataScienceStats_memberStatsId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberDataScienceStats_memberStatsId_key" ON members."memberDataScienceStats" USING btree ("memberStatsId");


--
-- TOC entry 6687 (class 1259 OID 2023964)
-- Name: memberDesignStatsItem_designStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDesignStatsItem_designStatsId_idx" ON members."memberDesignStatsItem" USING btree ("designStatsId");


--
-- TOC entry 6688 (class 1259 OID 2023965)
-- Name: memberDesignStatsItem_designStatsId_name_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberDesignStatsItem_designStatsId_name_key" ON members."memberDesignStatsItem" USING btree ("designStatsId", name);


--
-- TOC entry 6683 (class 1259 OID 2023962)
-- Name: memberDesignStats_memberStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDesignStats_memberStatsId_idx" ON members."memberDesignStats" USING btree ("memberStatsId");


--
-- TOC entry 6684 (class 1259 OID 2023963)
-- Name: memberDesignStats_memberStatsId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberDesignStats_memberStatsId_key" ON members."memberDesignStats" USING btree ("memberStatsId");


--
-- TOC entry 6661 (class 1259 OID 2023953)
-- Name: memberDevelopHistoryStats_historyStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDevelopHistoryStats_historyStatsId_idx" ON members."memberDevelopHistoryStats" USING btree ("historyStatsId");


--
-- TOC entry 6679 (class 1259 OID 2023960)
-- Name: memberDevelopStatsItem_developStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDevelopStatsItem_developStatsId_idx" ON members."memberDevelopStatsItem" USING btree ("developStatsId");


--
-- TOC entry 6680 (class 1259 OID 2023961)
-- Name: memberDevelopStatsItem_developStatsId_name_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberDevelopStatsItem_developStatsId_name_key" ON members."memberDevelopStatsItem" USING btree ("developStatsId", name);


--
-- TOC entry 6675 (class 1259 OID 2023958)
-- Name: memberDevelopStats_memberStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberDevelopStats_memberStatsId_idx" ON members."memberDevelopStats" USING btree ("memberStatsId");


--
-- TOC entry 6676 (class 1259 OID 2023959)
-- Name: memberDevelopStats_memberStatsId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberDevelopStats_memberStatsId_key" ON members."memberDevelopStats" USING btree ("memberStatsId");


--
-- TOC entry 6656 (class 1259 OID 2023952)
-- Name: memberHistoryStats_groupId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberHistoryStats_groupId_idx" ON members."memberHistoryStats" USING btree ("groupId");


--
-- TOC entry 6659 (class 1259 OID 2023951)
-- Name: memberHistoryStats_userId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberHistoryStats_userId_idx" ON members."memberHistoryStats" USING btree ("userId");


--
-- TOC entry 6660 (class 1259 OID 2028537)
-- Name: memberHistoryStats_userId_isPrivate_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberHistoryStats_userId_isPrivate_idx" ON members."memberHistoryStats" USING btree ("userId", "isPrivate");


--
-- TOC entry 6705 (class 1259 OID 2023972)
-- Name: memberMarathonStats_dataScienceStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberMarathonStats_dataScienceStatsId_idx" ON members."memberMarathonStats" USING btree ("dataScienceStatsId");


--
-- TOC entry 6706 (class 1259 OID 2023973)
-- Name: memberMarathonStats_dataScienceStatsId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberMarathonStats_dataScienceStatsId_key" ON members."memberMarathonStats" USING btree ("dataScienceStatsId");


--
-- TOC entry 6649 (class 1259 OID 2023948)
-- Name: memberMaxRating_userId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberMaxRating_userId_idx" ON members."memberMaxRating" USING btree ("userId");


--
-- TOC entry 6650 (class 1259 OID 2023949)
-- Name: memberMaxRating_userId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberMaxRating_userId_key" ON members."memberMaxRating" USING btree ("userId");


--
-- TOC entry 6754 (class 1259 OID 2023988)
-- Name: memberSkill_skillId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberSkill_skillId_idx" ON members."memberSkill" USING btree ("skillId");


--
-- TOC entry 6755 (class 1259 OID 2023987)
-- Name: memberSkill_userId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberSkill_userId_idx" ON members."memberSkill" USING btree ("userId");


--
-- TOC entry 6756 (class 1259 OID 2023989)
-- Name: memberSkill_userId_skillId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberSkill_userId_skillId_key" ON members."memberSkill" USING btree ("userId", "skillId");


--
-- TOC entry 6701 (class 1259 OID 2023970)
-- Name: memberSrmChallengeDetail_srmStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberSrmChallengeDetail_srmStatsId_idx" ON members."memberSrmChallengeDetail" USING btree ("srmStatsId");


--
-- TOC entry 6704 (class 1259 OID 2023971)
-- Name: memberSrmDivisionDetail_srmStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberSrmDivisionDetail_srmStatsId_idx" ON members."memberSrmDivisionDetail" USING btree ("srmStatsId");


--
-- TOC entry 6695 (class 1259 OID 2023968)
-- Name: memberSrmStats_dataScienceStatsId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberSrmStats_dataScienceStatsId_idx" ON members."memberSrmStats" USING btree ("dataScienceStatsId");


--
-- TOC entry 6696 (class 1259 OID 2023969)
-- Name: memberSrmStats_dataScienceStatsId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberSrmStats_dataScienceStatsId_key" ON members."memberSrmStats" USING btree ("dataScienceStatsId");


--
-- TOC entry 6669 (class 1259 OID 2028536)
-- Name: memberStats_userId_groupId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberStats_userId_groupId_idx" ON members."memberStats" USING btree ("userId", "groupId");


--
-- TOC entry 6670 (class 1259 OID 2023955)
-- Name: memberStats_userId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberStats_userId_idx" ON members."memberStats" USING btree ("userId");


--
-- TOC entry 6728 (class 1259 OID 2023981)
-- Name: memberTraitBasicInfo_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitBasicInfo_memberTraitId_idx" ON members."memberTraitBasicInfo" USING btree ("memberTraitId");


--
-- TOC entry 6729 (class 1259 OID 2023982)
-- Name: memberTraitBasicInfo_memberTraitId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberTraitBasicInfo_memberTraitId_key" ON members."memberTraitBasicInfo" USING btree ("memberTraitId");


--
-- TOC entry 6741 (class 1259 OID 2023986)
-- Name: memberTraitCommunity_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitCommunity_memberTraitId_idx" ON members."memberTraitCommunity" USING btree ("memberTraitId");


--
-- TOC entry 6713 (class 1259 OID 2023976)
-- Name: memberTraitDevice_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitDevice_memberTraitId_idx" ON members."memberTraitDevice" USING btree ("memberTraitId");


--
-- TOC entry 6725 (class 1259 OID 2023980)
-- Name: memberTraitEducation_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitEducation_memberTraitId_idx" ON members."memberTraitEducation" USING btree ("memberTraitId");


--
-- TOC entry 6732 (class 1259 OID 2023983)
-- Name: memberTraitLanguage_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitLanguage_memberTraitId_idx" ON members."memberTraitLanguage" USING btree ("memberTraitId");


--
-- TOC entry 6735 (class 1259 OID 2023984)
-- Name: memberTraitOnboardChecklist_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitOnboardChecklist_memberTraitId_idx" ON members."memberTraitOnboardChecklist" USING btree ("memberTraitId");


--
-- TOC entry 6738 (class 1259 OID 2023985)
-- Name: memberTraitPersonalization_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitPersonalization_memberTraitId_idx" ON members."memberTraitPersonalization" USING btree ("memberTraitId");


--
-- TOC entry 6719 (class 1259 OID 2023978)
-- Name: memberTraitServiceProvider_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitServiceProvider_memberTraitId_idx" ON members."memberTraitServiceProvider" USING btree ("memberTraitId");


--
-- TOC entry 6716 (class 1259 OID 2023977)
-- Name: memberTraitSoftware_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitSoftware_memberTraitId_idx" ON members."memberTraitSoftware" USING btree ("memberTraitId");


--
-- TOC entry 6722 (class 1259 OID 2023979)
-- Name: memberTraitWork_memberTraitId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraitWork_memberTraitId_idx" ON members."memberTraitWork" USING btree ("memberTraitId");


--
-- TOC entry 6711 (class 1259 OID 2023974)
-- Name: memberTraits_userId_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "memberTraits_userId_idx" ON members."memberTraits" USING btree ("userId");


--
-- TOC entry 6712 (class 1259 OID 2023975)
-- Name: memberTraits_userId_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "memberTraits_userId_key" ON members."memberTraits" USING btree ("userId");


--
-- TOC entry 6633 (class 1259 OID 2028534)
-- Name: member_availableForGigs_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "member_availableForGigs_idx" ON members.member USING btree ("availableForGigs");


--
-- TOC entry 6634 (class 1259 OID 2023946)
-- Name: member_email_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX member_email_idx ON members.member USING btree (email);


--
-- TOC entry 6635 (class 1259 OID 2023944)
-- Name: member_email_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX member_email_key ON members.member USING btree (email);


--
-- TOC entry 6636 (class 1259 OID 2023945)
-- Name: member_handleLower_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "member_handleLower_idx" ON members.member USING btree ("handleLower");


--
-- TOC entry 6637 (class 1259 OID 2023943)
-- Name: member_handleLower_key; Type: INDEX; Schema: members; Owner: members
--

CREATE UNIQUE INDEX "member_handleLower_key" ON members.member USING btree ("handleLower");


--
-- TOC entry 6638 (class 1259 OID 2028533)
-- Name: member_lastLoginDate_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "member_lastLoginDate_idx" ON members.member USING btree ("lastLoginDate");


--
-- TOC entry 6641 (class 1259 OID 2028532)
-- Name: member_status_handleLower_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX "member_status_handleLower_idx" ON members.member USING btree (status, "handleLower");


--
-- TOC entry 6642 (class 1259 OID 2071825)
-- Name: member_userid_email_idx; Type: INDEX; Schema: members; Owner: members
--

CREATE INDEX member_userid_email_idx ON members.member USING btree ((("userId")::text)) WHERE (email IS NOT NULL);


--
-- TOC entry 6250 (class 1259 OID 1352666)
-- Name: reference_idx; Type: INDEX; Schema: messages; Owner: topcoder
--

CREATE INDEX reference_idx ON messages.topics USING btree (reference, "referenceId");


--
-- TOC entry 6247 (class 1259 OID 1352667)
-- Name: topicId_idx; Type: INDEX; Schema: messages; Owner: topcoder
--

CREATE INDEX "topicId_idx" ON messages.posts USING btree ("topicId");


--
-- TOC entry 6333 (class 1259 OID 1436647)
-- Name: notification_user_id; Type: INDEX; Schema: notifications; Owner: topcoder
--

CREATE INDEX notification_user_id ON notifications."Notifications" USING btree ("userId");


--
-- TOC entry 6119 (class 1259 OID 1324160)
-- Name: project_history_project_id; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX project_history_project_id ON projects.project_history USING btree ("projectId");


--
-- TOC entry 6122 (class 1259 OID 1324161)
-- Name: project_members_deleted_at; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX project_members_deleted_at ON projects.project_members USING btree ("deletedAt");


--
-- TOC entry 6125 (class 1259 OID 1324162)
-- Name: project_members_role; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX project_members_role ON projects.project_members USING btree (role);


--
-- TOC entry 6126 (class 1259 OID 1324163)
-- Name: project_members_user_id; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX project_members_user_id ON projects.project_members USING btree ("userId");


--
-- TOC entry 6141 (class 1259 OID 1324164)
-- Name: project_text_search_idx; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX project_text_search_idx ON projects.projects USING gin ("projectFullText" gin_trgm_ops);


--
-- TOC entry 6142 (class 1259 OID 1324165)
-- Name: projects_created_at; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX projects_created_at ON projects.projects USING btree ("createdAt");


--
-- TOC entry 6143 (class 1259 OID 1324166)
-- Name: projects_direct_project_id; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX projects_direct_project_id ON projects.projects USING btree ("directProjectId");


--
-- TOC entry 6144 (class 1259 OID 1324167)
-- Name: projects_name; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX projects_name ON projects.projects USING btree (name);


--
-- TOC entry 6147 (class 1259 OID 1324168)
-- Name: projects_status; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX projects_status ON projects.projects USING btree (status);


--
-- TOC entry 6148 (class 1259 OID 1324169)
-- Name: projects_type; Type: INDEX; Schema: projects; Owner: topcoder
--

CREATE INDEX projects_type ON projects.projects USING btree (type);


--
-- TOC entry 6621 (class 1259 OID 2071998)
-- Name: idx_resource_challenge_role; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX idx_resource_challenge_role ON resources."Resource" USING btree ("challengeId", "roleId");


--
-- TOC entry 6622 (class 1259 OID 2072078)
-- Name: idx_resource_challenge_role_member; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX idx_resource_challenge_role_member ON resources."Resource" USING btree ("challengeId", "roleId") INCLUDE ("memberId");


--
-- TOC entry 6623 (class 1259 OID 2015731)
-- Name: resource-challengeIdMemberId-index; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX "resource-challengeIdMemberId-index" ON resources."Resource" USING btree ("challengeId", "memberId");


--
-- TOC entry 6624 (class 1259 OID 2015732)
-- Name: resource-memberIdRoleId-index; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX "resource-memberIdRoleId-index" ON resources."Resource" USING btree ("memberId", "roleId");


--
-- TOC entry 6625 (class 1259 OID 2071794)
-- Name: resource_challengeid_roleid_idx; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX resource_challengeid_roleid_idx ON resources."Resource" USING btree ("challengeId", "roleId");


--
-- TOC entry 6626 (class 1259 OID 2071798)
-- Name: resource_challengeid_roleid_memberid_idx; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX resource_challengeid_roleid_memberid_idx ON resources."Resource" USING btree ("challengeId", "roleId", "memberId");


--
-- TOC entry 6617 (class 1259 OID 2015730)
-- Name: resourcerole-nameLower-index; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX "resourcerole-nameLower-index" ON resources."ResourceRole" USING btree ("nameLower");


--
-- TOC entry 6618 (class 1259 OID 2071828)
-- Name: resourcerole_name_trgm_idx; Type: INDEX; Schema: resources; Owner: resources
--

CREATE INDEX resourcerole_name_trgm_idx ON resources."ResourceRole" USING gin (COALESCE("nameLower", lower(name)) gin_trgm_ops);


--
-- TOC entry 6629 (class 1259 OID 2015733)
-- Name: resourcerolephase-phaseId-resourceRoleId-unique; Type: INDEX; Schema: resources; Owner: resources
--

CREATE UNIQUE INDEX "resourcerolephase-phaseId-resourceRoleId-unique" ON resources."ResourceRolePhaseDependency" USING btree ("phaseId", "resourceRoleId");


--
-- TOC entry 6905 (class 1259 OID 2034373)
-- Name: aiWorkflowRun_submissionId_status_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "aiWorkflowRun_submissionId_status_idx" ON reviews."aiWorkflowRun" USING btree ("submissionId", status);


--
-- TOC entry 6906 (class 1259 OID 2034374)
-- Name: aiWorkflowRun_workflowId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "aiWorkflowRun_workflowId_idx" ON reviews."aiWorkflowRun" USING btree ("workflowId");


--
-- TOC entry 6900 (class 1259 OID 2034266)
-- Name: aiWorkflow_name_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "aiWorkflow_name_key" ON reviews."aiWorkflow" USING btree (name);


--
-- TOC entry 6834 (class 1259 OID 2033908)
-- Name: appealResponse_appealId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "appealResponse_appealId_idx" ON reviews."appealResponse" USING btree ("appealId");


--
-- TOC entry 6835 (class 1259 OID 2033838)
-- Name: appealResponse_appealId_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "appealResponse_appealId_key" ON reviews."appealResponse" USING btree ("appealId");


--
-- TOC entry 6836 (class 1259 OID 2033907)
-- Name: appealResponse_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "appealResponse_id_idx" ON reviews."appealResponse" USING btree (id);


--
-- TOC entry 6839 (class 1259 OID 2033909)
-- Name: appealResponse_resourceId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "appealResponse_resourceId_idx" ON reviews."appealResponse" USING btree ("resourceId");


--
-- TOC entry 6826 (class 1259 OID 2064280)
-- Name: appeal_comment_resource_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX appeal_comment_resource_idx ON reviews.appeal USING btree ("reviewItemCommentId", "resourceId");


--
-- TOC entry 6827 (class 1259 OID 2033905)
-- Name: appeal_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX appeal_id_idx ON reviews.appeal USING btree (id);


--
-- TOC entry 6830 (class 1259 OID 2033837)
-- Name: appeal_resourceId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "appeal_resourceId_idx" ON reviews.appeal USING btree ("resourceId");


--
-- TOC entry 6840 (class 1259 OID 2064082)
-- Name: appeal_response_appeal_resource_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX appeal_response_appeal_resource_idx ON reviews."appealResponse" USING btree ("appealId", "resourceId");


--
-- TOC entry 6831 (class 1259 OID 2033906)
-- Name: appeal_reviewItemCommentId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "appeal_reviewItemCommentId_idx" ON reviews.appeal USING btree ("reviewItemCommentId");


--
-- TOC entry 6832 (class 1259 OID 2033836)
-- Name: appeal_reviewItemCommentId_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "appeal_reviewItemCommentId_key" ON reviews.appeal USING btree ("reviewItemCommentId");


--
-- TOC entry 6833 (class 1259 OID 2066856)
-- Name: appeal_reviewitemcommentid_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX appeal_reviewitemcommentid_idx ON reviews.appeal USING btree ("reviewItemCommentId");


--
-- TOC entry 6841 (class 1259 OID 2033910)
-- Name: challengeResult_challengeId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "challengeResult_challengeId_idx" ON reviews."challengeResult" USING btree ("challengeId");


--
-- TOC entry 6844 (class 1259 OID 2033912)
-- Name: challengeResult_submissionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "challengeResult_submissionId_idx" ON reviews."challengeResult" USING btree ("submissionId");


--
-- TOC entry 6845 (class 1259 OID 2033911)
-- Name: challengeResult_userId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "challengeResult_userId_idx" ON reviews."challengeResult" USING btree ("userId");


--
-- TOC entry 6846 (class 1259 OID 2033915)
-- Name: contactRequest_challengeId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "contactRequest_challengeId_idx" ON reviews."contactRequest" USING btree ("challengeId");


--
-- TOC entry 6847 (class 1259 OID 2033913)
-- Name: contactRequest_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "contactRequest_id_idx" ON reviews."contactRequest" USING btree (id);


--
-- TOC entry 6850 (class 1259 OID 2033914)
-- Name: contactRequest_resourceId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "contactRequest_resourceId_idx" ON reviews."contactRequest" USING btree ("resourceId");


--
-- TOC entry 6889 (class 1259 OID 2034203)
-- Name: gitWebhookLog_createdAt_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "gitWebhookLog_createdAt_idx" ON reviews."gitWebhookLog" USING btree ("createdAt");


--
-- TOC entry 6890 (class 1259 OID 2034201)
-- Name: gitWebhookLog_eventId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "gitWebhookLog_eventId_idx" ON reviews."gitWebhookLog" USING btree ("eventId");


--
-- TOC entry 6891 (class 1259 OID 2034202)
-- Name: gitWebhookLog_event_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "gitWebhookLog_event_idx" ON reviews."gitWebhookLog" USING btree (event);


--
-- TOC entry 6873 (class 1259 OID 2072077)
-- Name: idx_submission_challenge_submitted_member; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX idx_submission_challenge_submitted_member ON reviews.submission USING btree ("challengeId", "submittedDate") INCLUDE ("memberId", placement) WHERE ("memberId" IS NOT NULL);


--
-- TOC entry 6897 (class 1259 OID 2034265)
-- Name: llmModel_name_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "llmModel_name_key" ON reviews."llmModel" USING btree (name);


--
-- TOC entry 6894 (class 1259 OID 2034264)
-- Name: llmProvider_name_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "llmProvider_name_key" ON reviews."llmProvider" USING btree (name);


--
-- TOC entry 6857 (class 1259 OID 2034008)
-- Name: reviewApplication_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewApplication_id_idx" ON reviews."reviewApplication" USING btree (id);


--
-- TOC entry 6858 (class 1259 OID 2034204)
-- Name: reviewApplication_opportunityId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewApplication_opportunityId_idx" ON reviews."reviewApplication" USING btree ("opportunityId");


--
-- TOC entry 6859 (class 1259 OID 2034205)
-- Name: reviewApplication_opportunityId_userId_role_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "reviewApplication_opportunityId_userId_role_key" ON reviews."reviewApplication" USING btree ("opportunityId", "userId", role);


--
-- TOC entry 6862 (class 1259 OID 2034009)
-- Name: reviewApplication_userId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewApplication_userId_idx" ON reviews."reviewApplication" USING btree ("userId");


--
-- TOC entry 6913 (class 1259 OID 2034341)
-- Name: reviewAudit_reviewId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewAudit_reviewId_idx" ON reviews."reviewAudit" USING btree ("reviewId");


--
-- TOC entry 6914 (class 1259 OID 2034342)
-- Name: reviewAudit_submissionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewAudit_submissionId_idx" ON reviews."reviewAudit" USING btree ("submissionId");


--
-- TOC entry 6818 (class 1259 OID 2033904)
-- Name: reviewItemComment_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItemComment_id_idx" ON reviews."reviewItemComment" USING btree (id);


--
-- TOC entry 6821 (class 1259 OID 2033920)
-- Name: reviewItemComment_resourceId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItemComment_resourceId_idx" ON reviews."reviewItemComment" USING btree ("resourceId");


--
-- TOC entry 6822 (class 1259 OID 2033903)
-- Name: reviewItemComment_reviewItemId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItemComment_reviewItemId_idx" ON reviews."reviewItemComment" USING btree ("reviewItemId");


--
-- TOC entry 6823 (class 1259 OID 2063857)
-- Name: reviewItemComment_reviewItemId_sortOrder_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItemComment_reviewItemId_sortOrder_id_idx" ON reviews."reviewItemComment" USING btree ("reviewItemId", "sortOrder", id);


--
-- TOC entry 6824 (class 1259 OID 2033921)
-- Name: reviewItemComment_type_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItemComment_type_idx" ON reviews."reviewItemComment" USING btree (type);


--
-- TOC entry 6813 (class 1259 OID 2033902)
-- Name: reviewItem_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItem_id_idx" ON reviews."reviewItem" USING btree (id);


--
-- TOC entry 6816 (class 1259 OID 2033901)
-- Name: reviewItem_reviewId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItem_reviewId_idx" ON reviews."reviewItem" USING btree ("reviewId");


--
-- TOC entry 6817 (class 1259 OID 2033919)
-- Name: reviewItem_scorecardQuestionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewItem_scorecardQuestionId_idx" ON reviews."reviewItem" USING btree ("scorecardQuestionId");


--
-- TOC entry 6851 (class 1259 OID 2034006)
-- Name: reviewOpportunity_challengeId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewOpportunity_challengeId_idx" ON reviews."reviewOpportunity" USING btree ("challengeId");


--
-- TOC entry 6852 (class 1259 OID 2034007)
-- Name: reviewOpportunity_challengeId_type_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "reviewOpportunity_challengeId_type_key" ON reviews."reviewOpportunity" USING btree ("challengeId", type);


--
-- TOC entry 6853 (class 1259 OID 2034005)
-- Name: reviewOpportunity_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewOpportunity_id_idx" ON reviews."reviewOpportunity" USING btree (id);


--
-- TOC entry 6856 (class 1259 OID 2034377)
-- Name: reviewOpportunity_status_challengeId_type_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewOpportunity_status_challengeId_type_idx" ON reviews."reviewOpportunity" USING btree (status, "challengeId", type);


--
-- TOC entry 6870 (class 1259 OID 2034058)
-- Name: reviewSummation_scorecardId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewSummation_scorecardId_idx" ON reviews."reviewSummation" USING btree ("scorecardId");


--
-- TOC entry 6871 (class 1259 OID 2034125)
-- Name: reviewSummation_submissionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewSummation_submissionId_idx" ON reviews."reviewSummation" USING btree ("submissionId");


--
-- TOC entry 6872 (class 1259 OID 2034378)
-- Name: reviewSummation_submissionId_isPassing_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewSummation_submissionId_isPassing_idx" ON reviews."reviewSummation" USING btree ("submissionId", "isPassing");


--
-- TOC entry 6863 (class 1259 OID 2034053)
-- Name: reviewType_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewType_id_idx" ON reviews."reviewType" USING btree (id);


--
-- TOC entry 6864 (class 1259 OID 2034055)
-- Name: reviewType_isActive_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewType_isActive_idx" ON reviews."reviewType" USING btree ("isActive");


--
-- TOC entry 6865 (class 1259 OID 2034054)
-- Name: reviewType_name_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "reviewType_name_idx" ON reviews."reviewType" USING btree (name);


--
-- TOC entry 6797 (class 1259 OID 2033833)
-- Name: review_committed_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX review_committed_idx ON reviews.review USING btree (committed);


--
-- TOC entry 6929 (class 1259 OID 2066974)
-- Name: review_pending_summary_updated_at_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX review_pending_summary_updated_at_idx ON reviews.review_pending_summary USING btree ("updatedAt");


--
-- TOC entry 6798 (class 1259 OID 2063856)
-- Name: review_phaseId_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_phaseId_id_idx" ON reviews.review USING btree ("phaseId", id);


--
-- TOC entry 6799 (class 1259 OID 2033917)
-- Name: review_phaseId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_phaseId_idx" ON reviews.review USING btree ("phaseId");


--
-- TOC entry 6802 (class 1259 OID 2033835)
-- Name: review_resourceId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_resourceId_idx" ON reviews.review USING btree ("resourceId");


--
-- TOC entry 6803 (class 1259 OID 2034376)
-- Name: review_resourceId_status_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_resourceId_status_idx" ON reviews.review USING btree ("resourceId", status);


--
-- TOC entry 6804 (class 1259 OID 2034330)
-- Name: review_resourceId_submissionId_scorecardId_key; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE UNIQUE INDEX "review_resourceId_submissionId_scorecardId_key" ON reviews.review USING btree ("resourceId", "submissionId", "scorecardId");


--
-- TOC entry 6805 (class 1259 OID 2066776)
-- Name: review_resource_status_partial_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX review_resource_status_partial_idx ON reviews.review USING btree ("resourceId", "phaseId") WHERE (status IS DISTINCT FROM 'COMPLETED'::reviews."ReviewStatus");


--
-- TOC entry 6806 (class 1259 OID 2064083)
-- Name: review_resource_status_phase_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX review_resource_status_phase_idx ON reviews.review USING btree ("resourceId", status, "phaseId");


--
-- TOC entry 6807 (class 1259 OID 2066780)
-- Name: review_resourceid_status_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX review_resourceid_status_idx ON reviews.review USING btree ("resourceId", status);


--
-- TOC entry 6808 (class 1259 OID 2033918)
-- Name: review_scorecardId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_scorecardId_idx" ON reviews.review USING btree ("scorecardId");


--
-- TOC entry 6809 (class 1259 OID 2034327)
-- Name: review_status_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX review_status_idx ON reviews.review USING btree (status);


--
-- TOC entry 6810 (class 1259 OID 2034375)
-- Name: review_status_phaseId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_status_phaseId_idx" ON reviews.review USING btree (status, "phaseId");


--
-- TOC entry 6811 (class 1259 OID 2063855)
-- Name: review_submissionId_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_submissionId_id_idx" ON reviews.review USING btree ("submissionId", id);


--
-- TOC entry 6812 (class 1259 OID 2034111)
-- Name: review_submissionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "review_submissionId_idx" ON reviews.review USING btree ("submissionId");


--
-- TOC entry 6825 (class 1259 OID 2066900)
-- Name: reviewitemcomment_reviewitemid_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX reviewitemcomment_reviewitemid_idx ON reviews."reviewItemComment" USING btree ("reviewItemId");


--
-- TOC entry 6781 (class 1259 OID 2033925)
-- Name: scorecardGroup_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardGroup_id_idx" ON reviews."scorecardGroup" USING btree (id);


--
-- TOC entry 6784 (class 1259 OID 2033926)
-- Name: scorecardGroup_scorecardId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardGroup_scorecardId_idx" ON reviews."scorecardGroup" USING btree ("scorecardId");


--
-- TOC entry 6785 (class 1259 OID 2033927)
-- Name: scorecardGroup_sortOrder_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardGroup_sortOrder_idx" ON reviews."scorecardGroup" USING btree ("sortOrder");


--
-- TOC entry 6791 (class 1259 OID 2033928)
-- Name: scorecardQuestion_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardQuestion_id_idx" ON reviews."scorecardQuestion" USING btree (id);


--
-- TOC entry 6794 (class 1259 OID 2033929)
-- Name: scorecardQuestion_scorecardSectionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardQuestion_scorecardSectionId_idx" ON reviews."scorecardQuestion" USING btree ("scorecardSectionId");


--
-- TOC entry 6795 (class 1259 OID 2033931)
-- Name: scorecardQuestion_sortOrder_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardQuestion_sortOrder_idx" ON reviews."scorecardQuestion" USING btree ("sortOrder");


--
-- TOC entry 6796 (class 1259 OID 2033930)
-- Name: scorecardQuestion_type_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardQuestion_type_idx" ON reviews."scorecardQuestion" USING btree (type);


--
-- TOC entry 6786 (class 1259 OID 2033932)
-- Name: scorecardSection_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardSection_id_idx" ON reviews."scorecardSection" USING btree (id);


--
-- TOC entry 6789 (class 1259 OID 2033933)
-- Name: scorecardSection_scorecardGroupId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardSection_scorecardGroupId_idx" ON reviews."scorecardSection" USING btree ("scorecardGroupId");


--
-- TOC entry 6790 (class 1259 OID 2033934)
-- Name: scorecardSection_sortOrder_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecardSection_sortOrder_idx" ON reviews."scorecardSection" USING btree ("sortOrder");


--
-- TOC entry 6773 (class 1259 OID 2033839)
-- Name: scorecard_challengeTrack_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecard_challengeTrack_idx" ON reviews.scorecard USING btree ("challengeTrack");


--
-- TOC entry 6774 (class 1259 OID 2033840)
-- Name: scorecard_challengeType_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "scorecard_challengeType_idx" ON reviews.scorecard USING btree ("challengeType");


--
-- TOC entry 6775 (class 1259 OID 2033922)
-- Name: scorecard_id_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX scorecard_id_idx ON reviews.scorecard USING btree (id);


--
-- TOC entry 6776 (class 1259 OID 2033841)
-- Name: scorecard_name_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX scorecard_name_idx ON reviews.scorecard USING btree (name);


--
-- TOC entry 6779 (class 1259 OID 2033924)
-- Name: scorecard_status_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX scorecard_status_idx ON reviews.scorecard USING btree (status);


--
-- TOC entry 6780 (class 1259 OID 2033923)
-- Name: scorecard_type_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX scorecard_type_idx ON reviews.scorecard USING btree (type);


--
-- TOC entry 6915 (class 1259 OID 2034365)
-- Name: submissionAccessAudit_downloadedAt_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submissionAccessAudit_downloadedAt_idx" ON reviews."submissionAccessAudit" USING btree ("downloadedAt");


--
-- TOC entry 6918 (class 1259 OID 2034366)
-- Name: submissionAccessAudit_submissionId_downloadedAt_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submissionAccessAudit_submissionId_downloadedAt_idx" ON reviews."submissionAccessAudit" USING btree ("submissionId", "downloadedAt");


--
-- TOC entry 6919 (class 1259 OID 2034364)
-- Name: submissionAccessAudit_submissionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submissionAccessAudit_submissionId_idx" ON reviews."submissionAccessAudit" USING btree ("submissionId");


--
-- TOC entry 6874 (class 1259 OID 2034165)
-- Name: submission_challengeId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submission_challengeId_idx" ON reviews.submission USING btree ("challengeId");


--
-- TOC entry 6875 (class 1259 OID 2034379)
-- Name: submission_challengeId_memberId_status_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submission_challengeId_memberId_status_idx" ON reviews.submission USING btree ("challengeId", "memberId", status);


--
-- TOC entry 6876 (class 1259 OID 2071792)
-- Name: submission_challengeid_submitteddate_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX submission_challengeid_submitteddate_idx ON reviews.submission USING btree ("challengeId", "submittedDate" DESC);


--
-- TOC entry 6877 (class 1259 OID 2034166)
-- Name: submission_legacySubmissionId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submission_legacySubmissionId_idx" ON reviews.submission USING btree ("legacySubmissionId");


--
-- TOC entry 6878 (class 1259 OID 2034164)
-- Name: submission_memberId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submission_memberId_idx" ON reviews.submission USING btree ("memberId");


--
-- TOC entry 6881 (class 1259 OID 2034380)
-- Name: submission_submittedDate_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "submission_submittedDate_idx" ON reviews.submission USING btree ("submittedDate");


--
-- TOC entry 6882 (class 1259 OID 2034163)
-- Name: upload_legacyId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "upload_legacyId_idx" ON reviews.upload USING btree ("legacyId");


--
-- TOC entry 6885 (class 1259 OID 2034162)
-- Name: upload_projectId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "upload_projectId_idx" ON reviews.upload USING btree ("projectId");


--
-- TOC entry 6886 (class 1259 OID 2034381)
-- Name: upload_projectId_resourceId_idx; Type: INDEX; Schema: reviews; Owner: reviews
--

CREATE INDEX "upload_projectId_resourceId_idx" ON reviews.upload USING btree ("projectId", "resourceId");


--
-- TOC entry 6395 (class 1259 OID 1477295)
-- Name: fki_fk_event; Type: INDEX; Schema: skills; Owner: topcoder
--

CREATE INDEX fki_fk_event ON skills.skill_event USING btree (event_id);


--
-- TOC entry 6412 (class 1259 OID 1477296)
-- Name: fki_fk_skill; Type: INDEX; Schema: skills; Owner: topcoder
--

CREATE INDEX fki_fk_skill ON skills.user_skill USING btree (skill_id);


--
-- TOC entry 6386 (class 1259 OID 1477297)
-- Name: fki_fk_skill_category; Type: INDEX; Schema: skills; Owner: topcoder
--

CREATE INDEX fki_fk_skill_category ON skills.skill USING btree (category_id);


--
-- TOC entry 6396 (class 1259 OID 1477298)
-- Name: fki_fk_skill_event_type; Type: INDEX; Schema: skills; Owner: topcoder
--

CREATE INDEX fki_fk_skill_event_type ON skills.skill_event USING btree (skill_event_type_id);


--
-- TOC entry 6397 (class 1259 OID 1477299)
-- Name: fki_fk_source_type; Type: INDEX; Schema: skills; Owner: topcoder
--

CREATE INDEX fki_fk_source_type ON skills.skill_event USING btree (source_type_id);


--
-- TOC entry 6413 (class 1259 OID 1477300)
-- Name: fki_fk_user_skill_level; Type: INDEX; Schema: skills; Owner: topcoder
--

CREATE INDEX fki_fk_user_skill_level ON skills.user_skill USING btree (user_skill_level_id);


--
-- TOC entry 6358 (class 1259 OID 1475542)
-- Name: roles_name; Type: INDEX; Schema: taas; Owner: topcoder
--

CREATE UNIQUE INDEX roles_name ON taas.roles USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 6367 (class 1259 OID 1475543)
-- Name: work_periods_resource_booking_id_start_date_end_date; Type: INDEX; Schema: taas; Owner: topcoder
--

CREATE UNIQUE INDEX work_periods_resource_booking_id_start_date_end_date ON taas.work_periods USING btree (resource_booking_id, start_date, end_date) WHERE (deleted_at IS NULL);


--
-- TOC entry 6302 (class 1259 OID 1363503)
-- Name: terms_for_resource_reference_reference_id_tag; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX terms_for_resource_reference_reference_id_tag ON terms."TermsForResource" USING btree (reference, "referenceId", tag);


--
-- TOC entry 6313 (class 1259 OID 1363504)
-- Name: terms_of_use_dependency_dependency_terms_of_use_id; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX terms_of_use_dependency_dependency_terms_of_use_id ON terms."TermsOfUseDependency" USING btree ("dependencyTermsOfUseId");


--
-- TOC entry 6314 (class 1259 OID 1363505)
-- Name: terms_of_use_dependency_dependent_terms_of_use_id; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX terms_of_use_dependency_dependent_terms_of_use_id ON terms."TermsOfUseDependency" USING btree ("dependentTermsOfUseId");


--
-- TOC entry 6321 (class 1259 OID 1363506)
-- Name: user_terms_of_use_ban_xref_terms_of_use_id; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX user_terms_of_use_ban_xref_terms_of_use_id ON terms."UserTermsOfUseBanXref" USING btree ("termsOfUseId");


--
-- TOC entry 6322 (class 1259 OID 1363507)
-- Name: user_terms_of_use_ban_xref_user_id; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX user_terms_of_use_ban_xref_user_id ON terms."UserTermsOfUseBanXref" USING btree ("userId");


--
-- TOC entry 6325 (class 1259 OID 1363508)
-- Name: user_terms_of_use_xref_terms_of_use_id; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX user_terms_of_use_xref_terms_of_use_id ON terms."UserTermsOfUseXref" USING btree ("termsOfUseId");


--
-- TOC entry 6326 (class 1259 OID 1363509)
-- Name: user_terms_of_use_xref_user_id; Type: INDEX; Schema: terms; Owner: topcoder
--

CREATE INDEX user_terms_of_use_xref_user_id ON terms."UserTermsOfUseXref" USING btree ("userId");


--
-- TOC entry 7174 (class 2620 OID 1324170)
-- Name: projects project_text_update; Type: TRIGGER; Schema: projects; Owner: topcoder
--

CREATE TRIGGER project_text_update BEFORE INSERT OR UPDATE ON projects.projects FOR EACH ROW EXECUTE FUNCTION projects.project_text_update_trigger();


--
-- TOC entry 7175 (class 2620 OID 2066979)
-- Name: appeal appeal_pending_maintainer; Type: TRIGGER; Schema: reviews; Owner: reviews
--

CREATE TRIGGER appeal_pending_maintainer AFTER INSERT OR DELETE OR UPDATE ON reviews.appeal FOR EACH ROW EXECUTE FUNCTION reviews.handle_appeal_change();


--
-- TOC entry 7176 (class 2620 OID 2066981)
-- Name: appealResponse appeal_response_pending_maintainer; Type: TRIGGER; Schema: reviews; Owner: reviews
--

CREATE TRIGGER appeal_response_pending_maintainer AFTER INSERT OR DELETE OR UPDATE ON reviews."appealResponse" FOR EACH ROW EXECUTE FUNCTION reviews.handle_appeal_response_change();


--
-- TOC entry 7016 (class 2606 OID 1363256)
-- Name: CertificationEnrollments CertificationEnrollments_topcoderCertificationId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationEnrollments"
    ADD CONSTRAINT "CertificationEnrollments_topcoderCertificationId_fkey" FOREIGN KEY ("topcoderCertificationId") REFERENCES academy."TopcoderCertification"(id);


--
-- TOC entry 7018 (class 2606 OID 1363261)
-- Name: CertificationResourceProgresses CertificationResourceProgresses_certificationEnrollmentId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResourceProgresses"
    ADD CONSTRAINT "CertificationResourceProgresses_certificationEnrollmentId_fkey" FOREIGN KEY ("certificationEnrollmentId") REFERENCES academy."CertificationEnrollments"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7019 (class 2606 OID 1363266)
-- Name: CertificationResourceProgresses CertificationResourceProgresses_certificationResourceId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResourceProgresses"
    ADD CONSTRAINT "CertificationResourceProgresses_certificationResourceId_fkey" FOREIGN KEY ("certificationResourceId") REFERENCES academy."CertificationResource"(id);


--
-- TOC entry 7017 (class 2606 OID 1363271)
-- Name: CertificationResource CertificationResource_resourceProviderId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResource"
    ADD CONSTRAINT "CertificationResource_resourceProviderId_fkey" FOREIGN KEY ("resourceProviderId") REFERENCES academy."ResourceProvider"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7020 (class 2606 OID 1363276)
-- Name: FccCertificationProgresses FccCertificationProgresses_fccCertificationId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCertificationProgresses"
    ADD CONSTRAINT "FccCertificationProgresses_fccCertificationId_fkey" FOREIGN KEY ("fccCertificationId") REFERENCES academy."FreeCodeCampCertification"(id);


--
-- TOC entry 7021 (class 2606 OID 1363281)
-- Name: FccCertificationProgresses FccCertificationProgresses_fccCourseId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCertificationProgresses"
    ADD CONSTRAINT "FccCertificationProgresses_fccCourseId_fkey" FOREIGN KEY ("fccCourseId") REFERENCES academy."FccCourses"(id);


--
-- TOC entry 7022 (class 2606 OID 1363286)
-- Name: FccCompletedLessons FccCompletedLessons_fccModuleProgressId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCompletedLessons"
    ADD CONSTRAINT "FccCompletedLessons_fccModuleProgressId_fkey" FOREIGN KEY ("fccModuleProgressId") REFERENCES academy."FccModuleProgresses"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7023 (class 2606 OID 1363291)
-- Name: FccCourses FccCourses_certificationId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCourses"
    ADD CONSTRAINT "FccCourses_certificationId_fkey" FOREIGN KEY ("certificationId") REFERENCES academy."FreeCodeCampCertification"(id);


--
-- TOC entry 7024 (class 2606 OID 1363296)
-- Name: FccCourses FccCourses_providerId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCourses"
    ADD CONSTRAINT "FccCourses_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES academy."ResourceProvider"(id);


--
-- TOC entry 7025 (class 2606 OID 1363301)
-- Name: FccLessons FccLessons_fccModuleId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccLessons"
    ADD CONSTRAINT "FccLessons_fccModuleId_fkey" FOREIGN KEY ("fccModuleId") REFERENCES academy."FccModules"(id);


--
-- TOC entry 7026 (class 2606 OID 1363306)
-- Name: FccModuleProgresses FccModuleProgresses_fccCertificationProgressId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModuleProgresses"
    ADD CONSTRAINT "FccModuleProgresses_fccCertificationProgressId_fkey" FOREIGN KEY ("fccCertificationProgressId") REFERENCES academy."FccCertificationProgresses"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7027 (class 2606 OID 1363311)
-- Name: FccModules FccModules_fccCourseId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModules"
    ADD CONSTRAINT "FccModules_fccCourseId_fkey" FOREIGN KEY ("fccCourseId") REFERENCES academy."FccCourses"(id);


--
-- TOC entry 7028 (class 2606 OID 1363316)
-- Name: FreeCodeCampCertification FreeCodeCampCertification_certificationCategoryId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FreeCodeCampCertification"
    ADD CONSTRAINT "FreeCodeCampCertification_certificationCategoryId_fkey" FOREIGN KEY ("certificationCategoryId") REFERENCES academy."CertificationCategory"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7029 (class 2606 OID 1363321)
-- Name: FreeCodeCampCertification FreeCodeCampCertification_resourceProviderId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FreeCodeCampCertification"
    ADD CONSTRAINT "FreeCodeCampCertification_resourceProviderId_fkey" FOREIGN KEY ("resourceProviderId") REFERENCES academy."ResourceProvider"(id);


--
-- TOC entry 7030 (class 2606 OID 1363326)
-- Name: TopcoderCertification TopcoderCertification_certificationCategoryId_fkey; Type: FK CONSTRAINT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."TopcoderCertification"
    ADD CONSTRAINT "TopcoderCertification_certificationCategoryId_fkey" FOREIGN KEY ("certificationCategoryId") REFERENCES academy."CertificationCategory"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7170 (class 2606 OID 2070020)
-- Name: BillingAccountAccess BillingAccountAccess_billingAccountId_fkey; Type: FK CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."BillingAccountAccess"
    ADD CONSTRAINT "BillingAccountAccess_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing-accounts"."BillingAccount"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7167 (class 2606 OID 2069971)
-- Name: BillingAccount BillingAccount_clientId_fkey; Type: FK CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."BillingAccount"
    ADD CONSTRAINT "BillingAccount_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "billing-accounts"."Client"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7169 (class 2606 OID 2070015)
-- Name: ConsumedAmount ConsumedAmount_billingAccountId_fkey; Type: FK CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."ConsumedAmount"
    ADD CONSTRAINT "ConsumedAmount_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing-accounts"."BillingAccount"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7168 (class 2606 OID 2070010)
-- Name: LockedAmount LockedAmount_billingAccountId_fkey; Type: FK CONSTRAINT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."LockedAmount"
    ADD CONSTRAINT "LockedAmount_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing-accounts"."BillingAccount"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7081 (class 2606 OID 2005153)
-- Name: Attachment Attachment_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Attachment"
    ADD CONSTRAINT "Attachment_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7080 (class 2606 OID 2005148)
-- Name: AuditLog AuditLog_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."AuditLog"
    ADD CONSTRAINT "AuditLog_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7087 (class 2606 OID 2005183)
-- Name: ChallengeBilling ChallengeBilling_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeBilling"
    ADD CONSTRAINT "ChallengeBilling_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7092 (class 2606 OID 2005208)
-- Name: ChallengeConstraint ChallengeConstraint_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeConstraint"
    ADD CONSTRAINT "ChallengeConstraint_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7091 (class 2606 OID 2005203)
-- Name: ChallengeDiscussionOption ChallengeDiscussionOption_discussionId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeDiscussionOption"
    ADD CONSTRAINT "ChallengeDiscussionOption_discussionId_fkey" FOREIGN KEY ("discussionId") REFERENCES challenges."ChallengeDiscussion"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7090 (class 2606 OID 2005198)
-- Name: ChallengeDiscussion ChallengeDiscussion_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeDiscussion"
    ADD CONSTRAINT "ChallengeDiscussion_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7089 (class 2606 OID 2005193)
-- Name: ChallengeEvent ChallengeEvent_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeEvent"
    ADD CONSTRAINT "ChallengeEvent_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7088 (class 2606 OID 2005188)
-- Name: ChallengeLegacy ChallengeLegacy_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeLegacy"
    ADD CONSTRAINT "ChallengeLegacy_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7082 (class 2606 OID 2005158)
-- Name: ChallengeMetadata ChallengeMetadata_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeMetadata"
    ADD CONSTRAINT "ChallengeMetadata_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7095 (class 2606 OID 2005223)
-- Name: ChallengePhaseConstraint ChallengePhaseConstraint_challengePhaseId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePhaseConstraint"
    ADD CONSTRAINT "ChallengePhaseConstraint_challengePhaseId_fkey" FOREIGN KEY ("challengePhaseId") REFERENCES challenges."ChallengePhase"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7093 (class 2606 OID 2005213)
-- Name: ChallengePhase ChallengePhase_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePhase"
    ADD CONSTRAINT "ChallengePhase_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7094 (class 2606 OID 2005218)
-- Name: ChallengePhase ChallengePhase_phaseId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePhase"
    ADD CONSTRAINT "ChallengePhase_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES challenges."Phase"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7096 (class 2606 OID 2005228)
-- Name: ChallengePrizeSet ChallengePrizeSet_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengePrizeSet"
    ADD CONSTRAINT "ChallengePrizeSet_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7098 (class 2606 OID 2005271)
-- Name: ChallengeReviewer ChallengeReviewer_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeReviewer"
    ADD CONSTRAINT "ChallengeReviewer_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7099 (class 2606 OID 2005276)
-- Name: ChallengeReviewer ChallengeReviewer_phaseId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeReviewer"
    ADD CONSTRAINT "ChallengeReviewer_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES challenges."Phase"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7086 (class 2606 OID 2005178)
-- Name: ChallengeSkill ChallengeSkill_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeSkill"
    ADD CONSTRAINT "ChallengeSkill_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7085 (class 2606 OID 2005173)
-- Name: ChallengeTerm ChallengeTerm_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTerm"
    ADD CONSTRAINT "ChallengeTerm_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7077 (class 2606 OID 2005133)
-- Name: ChallengeTimelineTemplate ChallengeTimelineTemplate_timelineTemplateId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTimelineTemplate"
    ADD CONSTRAINT "ChallengeTimelineTemplate_timelineTemplateId_fkey" FOREIGN KEY ("timelineTemplateId") REFERENCES challenges."TimelineTemplate"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7078 (class 2606 OID 2005138)
-- Name: ChallengeTimelineTemplate ChallengeTimelineTemplate_trackId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTimelineTemplate"
    ADD CONSTRAINT "ChallengeTimelineTemplate_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES challenges."ChallengeTrack"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7079 (class 2606 OID 2005143)
-- Name: ChallengeTimelineTemplate ChallengeTimelineTemplate_typeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeTimelineTemplate"
    ADD CONSTRAINT "ChallengeTimelineTemplate_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES challenges."ChallengeType"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7084 (class 2606 OID 2005168)
-- Name: ChallengeWinner ChallengeWinner_challengeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."ChallengeWinner"
    ADD CONSTRAINT "ChallengeWinner_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES challenges."Challenge"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7074 (class 2606 OID 2005128)
-- Name: Challenge Challenge_timelineTemplateId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Challenge"
    ADD CONSTRAINT "Challenge_timelineTemplateId_fkey" FOREIGN KEY ("timelineTemplateId") REFERENCES challenges."TimelineTemplate"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7075 (class 2606 OID 2005123)
-- Name: Challenge Challenge_trackId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Challenge"
    ADD CONSTRAINT "Challenge_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES challenges."ChallengeTrack"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7076 (class 2606 OID 2005118)
-- Name: Challenge Challenge_typeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Challenge"
    ADD CONSTRAINT "Challenge_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES challenges."ChallengeType"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7100 (class 2606 OID 2005338)
-- Name: DefaultChallengeReviewer DefaultChallengeReviewer_phaseId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."DefaultChallengeReviewer"
    ADD CONSTRAINT "DefaultChallengeReviewer_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES challenges."Phase"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7101 (class 2606 OID 2005348)
-- Name: DefaultChallengeReviewer DefaultChallengeReviewer_timelineTemplateId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."DefaultChallengeReviewer"
    ADD CONSTRAINT "DefaultChallengeReviewer_timelineTemplateId_fkey" FOREIGN KEY ("timelineTemplateId") REFERENCES challenges."TimelineTemplate"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7102 (class 2606 OID 2005307)
-- Name: DefaultChallengeReviewer DefaultChallengeReviewer_trackId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."DefaultChallengeReviewer"
    ADD CONSTRAINT "DefaultChallengeReviewer_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES challenges."ChallengeTrack"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7103 (class 2606 OID 2005302)
-- Name: DefaultChallengeReviewer DefaultChallengeReviewer_typeId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."DefaultChallengeReviewer"
    ADD CONSTRAINT "DefaultChallengeReviewer_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES challenges."ChallengeType"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7083 (class 2606 OID 2005163)
-- Name: Prize Prize_prizeSetId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."Prize"
    ADD CONSTRAINT "Prize_prizeSetId_fkey" FOREIGN KEY ("prizeSetId") REFERENCES challenges."ChallengePrizeSet"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7097 (class 2606 OID 2005233)
-- Name: TimelineTemplatePhase TimelineTemplatePhase_timelineTemplateId_fkey; Type: FK CONSTRAINT; Schema: challenges; Owner: challenges
--

ALTER TABLE ONLY challenges."TimelineTemplatePhase"
    ADD CONSTRAINT "TimelineTemplatePhase_timelineTemplateId_fkey" FOREIGN KEY ("timelineTemplateId") REFERENCES challenges."TimelineTemplate"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6998 (class 2606 OID 1334662)
-- Name: audit audit_winnings_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.audit
    ADD CONSTRAINT audit_winnings_id_fkey FOREIGN KEY (winnings_id) REFERENCES finance.winnings(winning_id);


--
-- TOC entry 7007 (class 2606 OID 1334786)
-- Name: trolley_recipient_payment_method fk_trolley_recipient_trolley_recipient_payment_method; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_recipient_payment_method
    ADD CONSTRAINT fk_trolley_recipient_trolley_recipient_payment_method FOREIGN KEY (trolley_recipient_id) REFERENCES finance.trolley_recipient(id) ON DELETE CASCADE;


--
-- TOC entry 7006 (class 2606 OID 1334760)
-- Name: trolley_recipient fk_trolley_user_payment_method; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_recipient
    ADD CONSTRAINT fk_trolley_user_payment_method FOREIGN KEY (user_payment_method_id) REFERENCES finance.user_payment_methods(id) ON DELETE CASCADE;


--
-- TOC entry 7004 (class 2606 OID 1334717)
-- Name: user_payment_methods fk_user_payment_method; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.user_payment_methods
    ADD CONSTRAINT fk_user_payment_method FOREIGN KEY (payment_method_id) REFERENCES finance.payment_method(payment_method_id);


--
-- TOC entry 6999 (class 2606 OID 1334672)
-- Name: payment payment_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES finance.payment_method(payment_method_id);


--
-- TOC entry 7001 (class 2606 OID 1334682)
-- Name: payment_release_associations payment_release_associations_payment_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_release_associations
    ADD CONSTRAINT payment_release_associations_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES finance.payment(payment_id);


--
-- TOC entry 7002 (class 2606 OID 1334687)
-- Name: payment_release_associations payment_release_associations_payment_release_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_release_associations
    ADD CONSTRAINT payment_release_associations_payment_release_id_fkey FOREIGN KEY (payment_release_id) REFERENCES finance.payment_releases(payment_release_id);


--
-- TOC entry 7003 (class 2606 OID 1334692)
-- Name: payment_releases payment_releases_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_releases
    ADD CONSTRAINT payment_releases_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES finance.payment_method(payment_method_id);


--
-- TOC entry 7000 (class 2606 OID 1334677)
-- Name: payment payment_winnings_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_winnings_id_fkey FOREIGN KEY (winnings_id) REFERENCES finance.winnings(winning_id);


--
-- TOC entry 7005 (class 2606 OID 1334727)
-- Name: winnings winnings_origin_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.winnings
    ADD CONSTRAINT winnings_origin_id_fkey FOREIGN KEY (origin_id) REFERENCES finance.origin(origin_id);


--
-- TOC entry 7008 (class 2606 OID 1347926)
-- Name: badge_custom_fields badge_custom_fields_organization_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.badge_custom_fields
    ADD CONSTRAINT badge_custom_fields_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES gamification.organization(id) NOT VALID;


--
-- TOC entry 7009 (class 2606 OID 1347931)
-- Name: member_badges member_badges_org_badge_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.member_badges
    ADD CONSTRAINT member_badges_org_badge_id_fkey FOREIGN KEY (org_badge_id) REFERENCES gamification.organization_badges(id) NOT VALID;


--
-- TOC entry 7011 (class 2606 OID 1347936)
-- Name: organization_badges_custom_fields organization_badges_custom_fields_badges_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges_custom_fields
    ADD CONSTRAINT organization_badges_custom_fields_badges_id_fkey FOREIGN KEY (badges_id) REFERENCES gamification.organization_badges(id) NOT VALID;


--
-- TOC entry 7012 (class 2606 OID 1347941)
-- Name: organization_badges_custom_fields organization_badges_custom_fields_custom_field_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges_custom_fields
    ADD CONSTRAINT organization_badges_custom_fields_custom_field_id_fkey FOREIGN KEY (custom_field_id) REFERENCES gamification.badge_custom_fields(field_def_id) NOT VALID;


--
-- TOC entry 7010 (class 2606 OID 1347946)
-- Name: organization_badges organization_badges_organization_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges
    ADD CONSTRAINT organization_badges_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES gamification.organization(id) NOT VALID;


--
-- TOC entry 7013 (class 2606 OID 1347951)
-- Name: organization_badges_tags organization_badges_tags_organization_badges_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges_tags
    ADD CONSTRAINT organization_badges_tags_organization_badges_id_fkey FOREIGN KEY (organization_badges_id) REFERENCES gamification.organization_badges(id) NOT VALID;


--
-- TOC entry 7014 (class 2606 OID 1347956)
-- Name: organization_badges_tags organization_badges_tags_tags_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.organization_badges_tags
    ADD CONSTRAINT organization_badges_tags_tags_id_fkey FOREIGN KEY (tags_id) REFERENCES gamification.tags(id) NOT VALID;


--
-- TOC entry 7015 (class 2606 OID 1347961)
-- Name: tags tags_organization_id_fkey; Type: FK CONSTRAINT; Schema: gamification; Owner: topcoder
--

ALTER TABLE ONLY gamification.tags
    ADD CONSTRAINT tags_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES gamification.organization(id) NOT VALID;


--
-- TOC entry 7171 (class 2606 OID 2070316)
-- Name: GroupMember GroupMember_groupId_fkey; Type: FK CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."GroupMember"
    ADD CONSTRAINT "GroupMember_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES groups."Group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7172 (class 2606 OID 2070321)
-- Name: _ParentSubGroups _ParentSubGroups_A_fkey; Type: FK CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."_ParentSubGroups"
    ADD CONSTRAINT "_ParentSubGroups_A_fkey" FOREIGN KEY ("A") REFERENCES groups."Group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7173 (class 2606 OID 2070326)
-- Name: _ParentSubGroups _ParentSubGroups_B_fkey; Type: FK CONSTRAINT; Schema: groups; Owner: groups
--

ALTER TABLE ONLY groups."_ParentSubGroups"
    ADD CONSTRAINT "_ParentSubGroups_B_fkey" FOREIGN KEY ("B") REFERENCES groups."Group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7057 (class 2606 OID 1832102)
-- Name: user_achievement achv_type_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_achievement
    ADD CONSTRAINT achv_type_fk FOREIGN KEY (achievement_type_id) REFERENCES identity.achievement_type_lu(achievement_type_id);


--
-- TOC entry 7058 (class 2606 OID 1832107)
-- Name: user_achievement achv_user_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_achievement
    ADD CONSTRAINT achv_user_fk FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7052 (class 2606 OID 1832077)
-- Name: dice_connection dice_connection_user_id_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.dice_connection
    ADD CONSTRAINT dice_connection_user_id_fkey FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7053 (class 2606 OID 1832082)
-- Name: email email_emailstatuslu_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.email
    ADD CONSTRAINT email_emailstatuslu_fk FOREIGN KEY (status_id) REFERENCES identity.email_status_lu(status_id);


--
-- TOC entry 7054 (class 2606 OID 1832087)
-- Name: email email_emailtypelu_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.email
    ADD CONSTRAINT email_emailtypelu_fk FOREIGN KEY (email_type_id) REFERENCES identity.email_type_lu(email_type_id);


--
-- TOC entry 7055 (class 2606 OID 1832092)
-- Name: email email_user_id_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.email
    ADD CONSTRAINT email_user_id_fkey FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7059 (class 2606 OID 1832112)
-- Name: user_group_xref fk_user_grp_xref1; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_group_xref
    ADD CONSTRAINT fk_user_grp_xref1 FOREIGN KEY (login_id) REFERENCES identity.security_user(login_id) ON DELETE CASCADE;


--
-- TOC entry 7060 (class 2606 OID 1832117)
-- Name: user_group_xref fk_user_grp_xref2; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_group_xref
    ADD CONSTRAINT fk_user_grp_xref2 FOREIGN KEY (group_id) REFERENCES identity.security_groups(group_id) ON DELETE CASCADE;


--
-- TOC entry 7073 (class 2606 OID 1832182)
-- Name: role_assignment role_id; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role_assignment
    ADD CONSTRAINT role_id FOREIGN KEY (role_id) REFERENCES identity.role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7056 (class 2606 OID 1832097)
-- Name: user_2fa user_2fa_user_id_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_2fa
    ADD CONSTRAINT user_2fa_user_id_fkey FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7070 (class 2606 OID 1832172)
-- Name: user_email_xref user_email_xref_email_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_email_xref
    ADD CONSTRAINT user_email_xref_email_fk FOREIGN KEY (email_id) REFERENCES identity.email(email_id);


--
-- TOC entry 7071 (class 2606 OID 1832177)
-- Name: user_email_xref user_email_xref_status_id_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_email_xref
    ADD CONSTRAINT user_email_xref_status_id_fkey FOREIGN KEY (status_id) REFERENCES identity.email_status_lu(status_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7072 (class 2606 OID 1832167)
-- Name: user_email_xref user_email_xref_user_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_email_xref
    ADD CONSTRAINT user_email_xref_user_fk FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7062 (class 2606 OID 1832127)
-- Name: user_otp_email user_otp_email_user_id_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_otp_email
    ADD CONSTRAINT user_otp_email_user_id_fkey FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7063 (class 2606 OID 1832132)
-- Name: user_social_login user_social_provider_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_social_login
    ADD CONSTRAINT user_social_provider_fk FOREIGN KEY (social_login_provider_id) REFERENCES identity.social_login_provider(social_login_provider_id);


--
-- TOC entry 7064 (class 2606 OID 1832137)
-- Name: user_social_login user_social_user_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_social_login
    ADD CONSTRAINT user_social_user_fk FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7065 (class 2606 OID 1832142)
-- Name: user_sso_login user_sso_login_provider_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_sso_login
    ADD CONSTRAINT user_sso_login_provider_fk FOREIGN KEY (provider_id) REFERENCES identity.sso_login_provider(sso_login_provider_id);


--
-- TOC entry 7066 (class 2606 OID 1832147)
-- Name: user_sso_login user_sso_login_user_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_sso_login
    ADD CONSTRAINT user_sso_login_user_fk FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7061 (class 2606 OID 1832122)
-- Name: user_group_xref usergroupxref_status_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_group_xref
    ADD CONSTRAINT usergroupxref_status_fk FOREIGN KEY (security_status_id) REFERENCES identity.security_status_lu(security_status_id);


--
-- TOC entry 7067 (class 2606 OID 1832152)
-- Name: user_status userstatus_user_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_status
    ADD CONSTRAINT userstatus_user_fk FOREIGN KEY (user_id) REFERENCES identity."user"(user_id);


--
-- TOC entry 7068 (class 2606 OID 1832157)
-- Name: user_status userstatus_userstatuslu_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_status
    ADD CONSTRAINT userstatus_userstatuslu_fk FOREIGN KEY (user_status_id) REFERENCES identity.user_status_lu(user_status_id);


--
-- TOC entry 7069 (class 2606 OID 1832162)
-- Name: user_status userstatus_userstatustype_fk; Type: FK CONSTRAINT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_status
    ADD CONSTRAINT userstatus_userstatustype_fk FOREIGN KEY (user_status_type_id) REFERENCES identity.user_status_type_lu(user_status_type_id);


--
-- TOC entry 7106 (class 2606 OID 2023990)
-- Name: memberAddress memberAddress_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberAddress"
    ADD CONSTRAINT "memberAddress_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7114 (class 2606 OID 2024030)
-- Name: memberCopilotStats memberCopilotStats_memberStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberCopilotStats"
    ADD CONSTRAINT "memberCopilotStats_memberStatsId_fkey" FOREIGN KEY ("memberStatsId") REFERENCES members."memberStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7111 (class 2606 OID 2024015)
-- Name: memberDataScienceHistoryStats memberDataScienceHistoryStats_historyStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceHistoryStats"
    ADD CONSTRAINT "memberDataScienceHistoryStats_historyStatsId_fkey" FOREIGN KEY ("historyStatsId") REFERENCES members."memberHistoryStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7119 (class 2606 OID 2024055)
-- Name: memberDataScienceStats memberDataScienceStats_memberStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceStats"
    ADD CONSTRAINT "memberDataScienceStats_memberStatsId_fkey" FOREIGN KEY ("memberStatsId") REFERENCES members."memberStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7118 (class 2606 OID 2024050)
-- Name: memberDesignStatsItem memberDesignStatsItem_designStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStatsItem"
    ADD CONSTRAINT "memberDesignStatsItem_designStatsId_fkey" FOREIGN KEY ("designStatsId") REFERENCES members."memberDesignStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7117 (class 2606 OID 2024045)
-- Name: memberDesignStats memberDesignStats_memberStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStats"
    ADD CONSTRAINT "memberDesignStats_memberStatsId_fkey" FOREIGN KEY ("memberStatsId") REFERENCES members."memberStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7110 (class 2606 OID 2024010)
-- Name: memberDevelopHistoryStats memberDevelopHistoryStats_historyStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopHistoryStats"
    ADD CONSTRAINT "memberDevelopHistoryStats_historyStatsId_fkey" FOREIGN KEY ("historyStatsId") REFERENCES members."memberHistoryStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7116 (class 2606 OID 2024040)
-- Name: memberDevelopStatsItem memberDevelopStatsItem_developStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStatsItem"
    ADD CONSTRAINT "memberDevelopStatsItem_developStatsId_fkey" FOREIGN KEY ("developStatsId") REFERENCES members."memberDevelopStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7115 (class 2606 OID 2024035)
-- Name: memberDevelopStats memberDevelopStats_memberStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStats"
    ADD CONSTRAINT "memberDevelopStats_memberStatsId_fkey" FOREIGN KEY ("memberStatsId") REFERENCES members."memberStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7108 (class 2606 OID 2024000)
-- Name: memberFinancial memberFinancial_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberFinancial"
    ADD CONSTRAINT "memberFinancial_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7109 (class 2606 OID 2024005)
-- Name: memberHistoryStats memberHistoryStats_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberHistoryStats"
    ADD CONSTRAINT "memberHistoryStats_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7123 (class 2606 OID 2024075)
-- Name: memberMarathonStats memberMarathonStats_dataScienceStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMarathonStats"
    ADD CONSTRAINT "memberMarathonStats_dataScienceStatsId_fkey" FOREIGN KEY ("dataScienceStatsId") REFERENCES members."memberDataScienceStats"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7107 (class 2606 OID 2023995)
-- Name: memberMaxRating memberMaxRating_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMaxRating"
    ADD CONSTRAINT "memberMaxRating_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7139 (class 2606 OID 2024155)
-- Name: memberSkillLevel memberSkillLevel_memberSkillId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkillLevel"
    ADD CONSTRAINT "memberSkillLevel_memberSkillId_fkey" FOREIGN KEY ("memberSkillId") REFERENCES members."memberSkill"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7140 (class 2606 OID 2024160)
-- Name: memberSkillLevel memberSkillLevel_skillLevelId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkillLevel"
    ADD CONSTRAINT "memberSkillLevel_skillLevelId_fkey" FOREIGN KEY ("skillLevelId") REFERENCES members."skillLevel"(id) ON UPDATE CASCADE;


--
-- TOC entry 7136 (class 2606 OID 2024140)
-- Name: memberSkill memberSkill_displayModeId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkill"
    ADD CONSTRAINT "memberSkill_displayModeId_fkey" FOREIGN KEY ("displayModeId") REFERENCES members."displayMode"(id) ON UPDATE CASCADE;


--
-- TOC entry 7137 (class 2606 OID 2024145)
-- Name: memberSkill memberSkill_skillId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkill"
    ADD CONSTRAINT "memberSkill_skillId_fkey" FOREIGN KEY ("skillId") REFERENCES members.skill(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7138 (class 2606 OID 2024150)
-- Name: memberSkill memberSkill_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSkill"
    ADD CONSTRAINT "memberSkill_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7121 (class 2606 OID 2024065)
-- Name: memberSrmChallengeDetail memberSrmChallengeDetail_srmStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmChallengeDetail"
    ADD CONSTRAINT "memberSrmChallengeDetail_srmStatsId_fkey" FOREIGN KEY ("srmStatsId") REFERENCES members."memberSrmStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7122 (class 2606 OID 2024070)
-- Name: memberSrmDivisionDetail memberSrmDivisionDetail_srmStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmDivisionDetail"
    ADD CONSTRAINT "memberSrmDivisionDetail_srmStatsId_fkey" FOREIGN KEY ("srmStatsId") REFERENCES members."memberSrmStats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7120 (class 2606 OID 2024060)
-- Name: memberSrmStats memberSrmStats_dataScienceStatsId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmStats"
    ADD CONSTRAINT "memberSrmStats_dataScienceStatsId_fkey" FOREIGN KEY ("dataScienceStatsId") REFERENCES members."memberDataScienceStats"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7112 (class 2606 OID 2024020)
-- Name: memberStats memberStats_memberRatingId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberStats"
    ADD CONSTRAINT "memberStats_memberRatingId_fkey" FOREIGN KEY ("memberRatingId") REFERENCES members."memberMaxRating"(id) ON UPDATE CASCADE;


--
-- TOC entry 7113 (class 2606 OID 2024025)
-- Name: memberStats memberStats_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberStats"
    ADD CONSTRAINT "memberStats_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7130 (class 2606 OID 2024110)
-- Name: memberTraitBasicInfo memberTraitBasicInfo_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitBasicInfo"
    ADD CONSTRAINT "memberTraitBasicInfo_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7134 (class 2606 OID 2024130)
-- Name: memberTraitCommunity memberTraitCommunity_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitCommunity"
    ADD CONSTRAINT "memberTraitCommunity_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7125 (class 2606 OID 2024085)
-- Name: memberTraitDevice memberTraitDevice_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitDevice"
    ADD CONSTRAINT "memberTraitDevice_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7129 (class 2606 OID 2024105)
-- Name: memberTraitEducation memberTraitEducation_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitEducation"
    ADD CONSTRAINT "memberTraitEducation_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7131 (class 2606 OID 2024115)
-- Name: memberTraitLanguage memberTraitLanguage_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitLanguage"
    ADD CONSTRAINT "memberTraitLanguage_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7132 (class 2606 OID 2024120)
-- Name: memberTraitOnboardChecklist memberTraitOnboardChecklist_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitOnboardChecklist"
    ADD CONSTRAINT "memberTraitOnboardChecklist_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7133 (class 2606 OID 2024125)
-- Name: memberTraitPersonalization memberTraitPersonalization_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitPersonalization"
    ADD CONSTRAINT "memberTraitPersonalization_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7127 (class 2606 OID 2024095)
-- Name: memberTraitServiceProvider memberTraitServiceProvider_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitServiceProvider"
    ADD CONSTRAINT "memberTraitServiceProvider_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7126 (class 2606 OID 2024090)
-- Name: memberTraitSoftware memberTraitSoftware_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitSoftware"
    ADD CONSTRAINT "memberTraitSoftware_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7128 (class 2606 OID 2024100)
-- Name: memberTraitWork memberTraitWork_memberTraitId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitWork"
    ADD CONSTRAINT "memberTraitWork_memberTraitId_fkey" FOREIGN KEY ("memberTraitId") REFERENCES members."memberTraits"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7124 (class 2606 OID 2024080)
-- Name: memberTraits memberTraits_userId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraits"
    ADD CONSTRAINT "memberTraits_userId_fkey" FOREIGN KEY ("userId") REFERENCES members.member("userId") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7135 (class 2606 OID 2024135)
-- Name: skill skill_categoryId_fkey; Type: FK CONSTRAINT; Schema: members; Owner: members
--

ALTER TABLE ONLY members.skill
    ADD CONSTRAINT "skill_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES members."skillCategory"(id) ON UPDATE CASCADE;


--
-- TOC entry 7034 (class 2606 OID 1436648)
-- Name: bulk_message_user_refs bulk_message_user_refs_bulk_message_id_fkey; Type: FK CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_message_user_refs
    ADD CONSTRAINT bulk_message_user_refs_bulk_message_id_fkey FOREIGN KEY (bulk_message_id) REFERENCES notifications.bulk_messages(id);


--
-- TOC entry 7035 (class 2606 OID 1436653)
-- Name: bulk_message_user_refs bulk_message_user_refs_notification_id_fkey; Type: FK CONSTRAINT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_message_user_refs
    ADD CONSTRAINT bulk_message_user_refs_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES notifications."Notifications"(id);


--
-- TOC entry 6997 (class 2606 OID 1332743)
-- Name: copilot_applications copilot_applications_opportunityId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: projects
--

ALTER TABLE ONLY projects.copilot_applications
    ADD CONSTRAINT "copilot_applications_opportunityId_fkey" FOREIGN KEY ("opportunityId") REFERENCES projects.copilot_opportunities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6980 (class 2606 OID 1324171)
-- Name: copilot_opportunities copilot_opportunities_copilotRequestId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_opportunities
    ADD CONSTRAINT "copilot_opportunities_copilotRequestId_fkey" FOREIGN KEY ("copilotRequestId") REFERENCES projects.copilot_requests(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6981 (class 2606 OID 1324176)
-- Name: copilot_opportunities copilot_opportunities_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_opportunities
    ADD CONSTRAINT "copilot_opportunities_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6982 (class 2606 OID 1333132)
-- Name: copilot_requests copilot_requests_copilotOpportunityId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_requests
    ADD CONSTRAINT "copilot_requests_copilotOpportunityId_fkey" FOREIGN KEY ("copilotOpportunityId") REFERENCES projects.copilot_opportunities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6983 (class 2606 OID 1324181)
-- Name: copilot_requests copilot_requests_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_requests
    ADD CONSTRAINT "copilot_requests_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6984 (class 2606 OID 1324186)
-- Name: milestones milestones_timelineId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestones
    ADD CONSTRAINT "milestones_timelineId_fkey" FOREIGN KEY ("timelineId") REFERENCES projects.timelines(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6985 (class 2606 OID 1324191)
-- Name: phase_products phase_products_phaseId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_products
    ADD CONSTRAINT "phase_products_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES projects.project_phases(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6986 (class 2606 OID 1324196)
-- Name: phase_work_streams phase_work_streams_phaseId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_work_streams
    ADD CONSTRAINT "phase_work_streams_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES projects.project_phases(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6987 (class 2606 OID 1324201)
-- Name: phase_work_streams phase_work_streams_workStreamId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_work_streams
    ADD CONSTRAINT "phase_work_streams_workStreamId_fkey" FOREIGN KEY ("workStreamId") REFERENCES projects.work_streams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6988 (class 2606 OID 1324206)
-- Name: project_attachments project_attachments_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_attachments
    ADD CONSTRAINT "project_attachments_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6989 (class 2606 OID 1333137)
-- Name: project_member_invites project_member_invites_applicationId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_member_invites
    ADD CONSTRAINT "project_member_invites_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES projects.copilot_applications(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6990 (class 2606 OID 1324211)
-- Name: project_member_invites project_member_invites_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_member_invites
    ADD CONSTRAINT "project_member_invites_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6991 (class 2606 OID 1324216)
-- Name: project_members project_members_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_members
    ADD CONSTRAINT "project_members_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6992 (class 2606 OID 1324221)
-- Name: project_phase_approval project_phase_approval_phaseId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phase_approval
    ADD CONSTRAINT "project_phase_approval_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES projects.project_phases(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6993 (class 2606 OID 1324226)
-- Name: project_phase_member project_phase_member_phaseId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phase_member
    ADD CONSTRAINT "project_phase_member_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES projects.project_phases(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6994 (class 2606 OID 1324231)
-- Name: project_phases project_phases_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phases
    ADD CONSTRAINT "project_phases_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6995 (class 2606 OID 1324236)
-- Name: scope_change_requests scope_change_requests_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.scope_change_requests
    ADD CONSTRAINT "scope_change_requests_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6996 (class 2606 OID 1324241)
-- Name: work_streams work_streams_projectId_fkey; Type: FK CONSTRAINT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.work_streams
    ADD CONSTRAINT "work_streams_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES projects.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7105 (class 2606 OID 2015739)
-- Name: ResourceRolePhaseDependency ResourceRolePhaseDependency_resourceRoleId_fkey; Type: FK CONSTRAINT; Schema: resources; Owner: resources
--

ALTER TABLE ONLY resources."ResourceRolePhaseDependency"
    ADD CONSTRAINT "ResourceRolePhaseDependency_resourceRoleId_fkey" FOREIGN KEY ("resourceRoleId") REFERENCES resources."ResourceRole"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7104 (class 2606 OID 2015734)
-- Name: Resource Resource_roleId_fkey; Type: FK CONSTRAINT; Schema: resources; Owner: resources
--

ALTER TABLE ONLY resources."Resource"
    ADD CONSTRAINT "Resource_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES resources."ResourceRole"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7162 (class 2606 OID 2034307)
-- Name: aiWorkflowRunItemComment aiWorkflowRunItemComment_parentId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRunItemComment"
    ADD CONSTRAINT "aiWorkflowRunItemComment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES reviews."aiWorkflowRunItemComment"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7163 (class 2606 OID 2034302)
-- Name: aiWorkflowRunItemComment aiWorkflowRunItemComment_workflowRunItemId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRunItemComment"
    ADD CONSTRAINT "aiWorkflowRunItemComment_workflowRunItemId_fkey" FOREIGN KEY ("workflowRunItemId") REFERENCES reviews."aiWorkflowRunItem"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7160 (class 2606 OID 2034297)
-- Name: aiWorkflowRunItem aiWorkflowRunItem_scorecardQuestionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRunItem"
    ADD CONSTRAINT "aiWorkflowRunItem_scorecardQuestionId_fkey" FOREIGN KEY ("scorecardQuestionId") REFERENCES reviews."scorecardQuestion"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7161 (class 2606 OID 2034292)
-- Name: aiWorkflowRunItem aiWorkflowRunItem_workflowRunId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRunItem"
    ADD CONSTRAINT "aiWorkflowRunItem_workflowRunId_fkey" FOREIGN KEY ("workflowRunId") REFERENCES reviews."aiWorkflowRun"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7158 (class 2606 OID 2034287)
-- Name: aiWorkflowRun aiWorkflowRun_submissionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRun"
    ADD CONSTRAINT "aiWorkflowRun_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES reviews.submission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7159 (class 2606 OID 2034282)
-- Name: aiWorkflowRun aiWorkflowRun_workflowId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflowRun"
    ADD CONSTRAINT "aiWorkflowRun_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES reviews."aiWorkflow"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7156 (class 2606 OID 2034272)
-- Name: aiWorkflow aiWorkflow_llmId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflow"
    ADD CONSTRAINT "aiWorkflow_llmId_fkey" FOREIGN KEY ("llmId") REFERENCES reviews."llmModel"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7157 (class 2606 OID 2034277)
-- Name: aiWorkflow aiWorkflow_scorecardId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."aiWorkflow"
    ADD CONSTRAINT "aiWorkflow_scorecardId_fkey" FOREIGN KEY ("scorecardId") REFERENCES reviews.scorecard(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7149 (class 2606 OID 2033877)
-- Name: appealResponse appealResponse_appealId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."appealResponse"
    ADD CONSTRAINT "appealResponse_appealId_fkey" FOREIGN KEY ("appealId") REFERENCES reviews.appeal(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7148 (class 2606 OID 2033872)
-- Name: appeal appeal_reviewItemCommentId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.appeal
    ADD CONSTRAINT "appeal_reviewItemCommentId_fkey" FOREIGN KEY ("reviewItemCommentId") REFERENCES reviews."reviewItemComment"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7155 (class 2606 OID 2034267)
-- Name: llmModel llmModel_providerId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."llmModel"
    ADD CONSTRAINT "llmModel_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES reviews."llmProvider"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7154 (class 2606 OID 2034187)
-- Name: resourceSubmission resourceSubmission_submissionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."resourceSubmission"
    ADD CONSTRAINT "resourceSubmission_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES reviews.submission(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7150 (class 2606 OID 2034206)
-- Name: reviewApplication reviewApplication_opportunityId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewApplication"
    ADD CONSTRAINT "reviewApplication_opportunityId_fkey" FOREIGN KEY ("opportunityId") REFERENCES reviews."reviewOpportunity"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7164 (class 2606 OID 2034343)
-- Name: reviewAudit reviewAudit_reviewId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewAudit"
    ADD CONSTRAINT "reviewAudit_reviewId_fkey" FOREIGN KEY ("reviewId") REFERENCES reviews.review(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7165 (class 2606 OID 2034348)
-- Name: reviewAudit reviewAudit_submissionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewAudit"
    ADD CONSTRAINT "reviewAudit_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES reviews.submission(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7147 (class 2606 OID 2033867)
-- Name: reviewItemComment reviewItemComment_reviewItemId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewItemComment"
    ADD CONSTRAINT "reviewItemComment_reviewItemId_fkey" FOREIGN KEY ("reviewItemId") REFERENCES reviews."reviewItem"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7146 (class 2606 OID 2034021)
-- Name: reviewItem reviewItem_reviewId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewItem"
    ADD CONSTRAINT "reviewItem_reviewId_fkey" FOREIGN KEY ("reviewId") REFERENCES reviews.review(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7151 (class 2606 OID 2064084)
-- Name: reviewSummation reviewSummation_scorecardId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewSummation"
    ADD CONSTRAINT "reviewSummation_scorecardId_fkey" FOREIGN KEY ("scorecardId") REFERENCES reviews.scorecard(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7152 (class 2606 OID 2034172)
-- Name: reviewSummation reviewSummation_submissionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."reviewSummation"
    ADD CONSTRAINT "reviewSummation_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES reviews.submission(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7144 (class 2606 OID 2033857)
-- Name: review review_scorecardId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.review
    ADD CONSTRAINT "review_scorecardId_fkey" FOREIGN KEY ("scorecardId") REFERENCES reviews.scorecard(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7145 (class 2606 OID 2034167)
-- Name: review review_submissionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.review
    ADD CONSTRAINT "review_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES reviews.submission(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7141 (class 2606 OID 2033842)
-- Name: scorecardGroup scorecardGroup_scorecardId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."scorecardGroup"
    ADD CONSTRAINT "scorecardGroup_scorecardId_fkey" FOREIGN KEY ("scorecardId") REFERENCES reviews.scorecard(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7143 (class 2606 OID 2033852)
-- Name: scorecardQuestion scorecardQuestion_scorecardSectionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."scorecardQuestion"
    ADD CONSTRAINT "scorecardQuestion_scorecardSectionId_fkey" FOREIGN KEY ("scorecardSectionId") REFERENCES reviews."scorecardSection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7142 (class 2606 OID 2033847)
-- Name: scorecardSection scorecardSection_scorecardGroupId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."scorecardSection"
    ADD CONSTRAINT "scorecardSection_scorecardGroupId_fkey" FOREIGN KEY ("scorecardGroupId") REFERENCES reviews."scorecardGroup"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7166 (class 2606 OID 2034367)
-- Name: submissionAccessAudit submissionAccessAudit_submissionId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews."submissionAccessAudit"
    ADD CONSTRAINT "submissionAccessAudit_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES reviews.submission(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7153 (class 2606 OID 2034177)
-- Name: submission submission_uploadId_fkey; Type: FK CONSTRAINT; Schema: reviews; Owner: reviews
--

ALTER TABLE ONLY reviews.submission
    ADD CONSTRAINT "submission_uploadId_fkey" FOREIGN KEY ("uploadId") REFERENCES reviews.upload(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7045 (class 2606 OID 1477301)
-- Name: skill_event fk_event; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event
    ADD CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES skills.event(id) NOT VALID;


--
-- TOC entry 7046 (class 2606 OID 1477306)
-- Name: skill_event fk_skill; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event
    ADD CONSTRAINT fk_skill FOREIGN KEY (skill_id) REFERENCES skills.skill(id) NOT VALID;


--
-- TOC entry 7049 (class 2606 OID 1477311)
-- Name: user_skill fk_skill; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill
    ADD CONSTRAINT fk_skill FOREIGN KEY (skill_id) REFERENCES skills.skill(id) NOT VALID;


--
-- TOC entry 7044 (class 2606 OID 1477316)
-- Name: skill fk_skill_category; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill
    ADD CONSTRAINT fk_skill_category FOREIGN KEY (category_id) REFERENCES skills.skill_category(id) NOT VALID;


--
-- TOC entry 7047 (class 2606 OID 1477321)
-- Name: skill_event fk_skill_event_type; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event
    ADD CONSTRAINT fk_skill_event_type FOREIGN KEY (skill_event_type_id) REFERENCES skills.skill_event_type(id) NOT VALID;


--
-- TOC entry 7048 (class 2606 OID 1477326)
-- Name: skill_event fk_source_type; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.skill_event
    ADD CONSTRAINT fk_source_type FOREIGN KEY (source_type_id) REFERENCES skills.source_type(id) NOT VALID;


--
-- TOC entry 7050 (class 2606 OID 1477331)
-- Name: user_skill fk_user_skill_level; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill
    ADD CONSTRAINT fk_user_skill_level FOREIGN KEY (user_skill_level_id) REFERENCES skills.user_skill_level(id) NOT VALID;


--
-- TOC entry 7043 (class 2606 OID 1477336)
-- Name: legacy_skill_map skill_fkey; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.legacy_skill_map
    ADD CONSTRAINT skill_fkey FOREIGN KEY (skill_id) REFERENCES skills.skill(id);


--
-- TOC entry 7051 (class 2606 OID 1477341)
-- Name: user_skill user_skill_user_skill_display_mode_id_fkey; Type: FK CONSTRAINT; Schema: skills; Owner: topcoder
--

ALTER TABLE ONLY skills.user_skill
    ADD CONSTRAINT user_skill_user_skill_display_mode_id_fkey FOREIGN KEY (user_skill_display_mode_id) REFERENCES skills.user_skill_display_mode(id);


--
-- TOC entry 7036 (class 2606 OID 1475544)
-- Name: interviews interviews_job_candidate_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.interviews
    ADD CONSTRAINT interviews_job_candidate_id_fkey FOREIGN KEY (job_candidate_id) REFERENCES taas.job_candidates(id);


--
-- TOC entry 7037 (class 2606 OID 1475549)
-- Name: job_candidates job_candidates_job_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.job_candidates
    ADD CONSTRAINT job_candidates_job_id_fkey FOREIGN KEY (job_id) REFERENCES taas.jobs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7038 (class 2606 OID 1475554)
-- Name: payment_schedulers payment_schedulers_work_period_payment_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.payment_schedulers
    ADD CONSTRAINT payment_schedulers_work_period_payment_id_fkey FOREIGN KEY (work_period_payment_id) REFERENCES taas.work_period_payments(id);


--
-- TOC entry 7039 (class 2606 OID 1475559)
-- Name: resource_bookings resource_bookings_job_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.resource_bookings
    ADD CONSTRAINT resource_bookings_job_id_fkey FOREIGN KEY (job_id) REFERENCES taas.jobs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7040 (class 2606 OID 1475564)
-- Name: role_search_requests role_search_requests_role_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.role_search_requests
    ADD CONSTRAINT role_search_requests_role_id_fkey FOREIGN KEY (role_id) REFERENCES taas.roles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 7041 (class 2606 OID 1475569)
-- Name: work_period_payments work_period_payments_work_period_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.work_period_payments
    ADD CONSTRAINT work_period_payments_work_period_id_fkey FOREIGN KEY (work_period_id) REFERENCES taas.work_periods(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7042 (class 2606 OID 1475574)
-- Name: work_periods work_periods_resource_booking_id_fkey; Type: FK CONSTRAINT; Schema: taas; Owner: topcoder
--

ALTER TABLE ONLY taas.work_periods
    ADD CONSTRAINT work_periods_resource_booking_id_fkey FOREIGN KEY (resource_booking_id) REFERENCES taas.resource_bookings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7032 (class 2606 OID 1363510)
-- Name: TermsOfUseDocusignTemplateXref TermsOfUseDocusignTemplateXref_termsOfUseId_fkey; Type: FK CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUseDocusignTemplateXref"
    ADD CONSTRAINT "TermsOfUseDocusignTemplateXref_termsOfUseId_fkey" FOREIGN KEY ("termsOfUseId") REFERENCES terms."TermsOfUse"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7031 (class 2606 OID 1363515)
-- Name: TermsOfUse TermsOfUse_agreeabilityTypeId_fkey; Type: FK CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."TermsOfUse"
    ADD CONSTRAINT "TermsOfUse_agreeabilityTypeId_fkey" FOREIGN KEY ("agreeabilityTypeId") REFERENCES terms."TermsOfUseAgreeabilityType"(id) ON UPDATE CASCADE;


--
-- TOC entry 7033 (class 2606 OID 1363520)
-- Name: UserTermsOfUseXref UserTermsOfUseXref_termsOfUseId_fkey; Type: FK CONSTRAINT; Schema: terms; Owner: topcoder
--

ALTER TABLE ONLY terms."UserTermsOfUseXref"
    ADD CONSTRAINT "UserTermsOfUseXref_termsOfUseId_fkey" FOREIGN KEY ("termsOfUseId") REFERENCES terms."TermsOfUse"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7327 (class 6104 OID 1363331)
-- Name: academy_publication; Type: PUBLICATION; Schema: -; Owner: topcoder
--

CREATE PUBLICATION academy_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION academy_publication OWNER TO topcoder;

--
-- TOC entry 7326 (class 6104 OID 1347966)
-- Name: gamification_publication; Type: PUBLICATION; Schema: -; Owner: topcoder
--

CREATE PUBLICATION gamification_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION gamification_publication OWNER TO topcoder;

--
-- TOC entry 7329 (class 6237 OID 1363332)
-- Name: academy_publication academy; Type: PUBLICATION TABLES IN SCHEMA; Schema: academy; Owner: topcoder
--

ALTER PUBLICATION academy_publication ADD TABLES IN SCHEMA academy;


--
-- TOC entry 7328 (class 6237 OID 1347967)
-- Name: gamification_publication gamification; Type: PUBLICATION TABLES IN SCHEMA; Schema: gamification; Owner: topcoder
--

ALTER PUBLICATION gamification_publication ADD TABLES IN SCHEMA gamification;


--
-- TOC entry 7704 (class 0 OID 0)
-- Dependencies: 11
-- Name: SCHEMA academy; Type: ACL; Schema: -; Owner: academy
--

GRANT CREATE ON SCHEMA academy TO PUBLIC;
GRANT USAGE ON SCHEMA academy TO power_bi_readonly;


--
-- TOC entry 7705 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA autopilot; Type: ACL; Schema: -; Owner: autopilot
--

GRANT USAGE ON SCHEMA autopilot TO power_bi_readonly;


--
-- TOC entry 7706 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA "billing-accounts"; Type: ACL; Schema: -; Owner: billingaccounts
--

GRANT USAGE ON SCHEMA "billing-accounts" TO power_bi_readonly;


--
-- TOC entry 7707 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA challenges; Type: ACL; Schema: -; Owner: challenges
--

GRANT USAGE ON SCHEMA challenges TO power_bi_readonly;


--
-- TOC entry 7709 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA emails; Type: ACL; Schema: -; Owner: emails
--

GRANT ALL ON SCHEMA emails TO PUBLIC;
GRANT USAGE ON SCHEMA emails TO power_bi_readonly;


--
-- TOC entry 7710 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA finance; Type: ACL; Schema: -; Owner: finance
--

GRANT USAGE ON SCHEMA finance TO power_bi_readonly;


--
-- TOC entry 7711 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA gamification; Type: ACL; Schema: -; Owner: gamification
--

GRANT ALL ON SCHEMA gamification TO PUBLIC;
GRANT USAGE ON SCHEMA gamification TO power_bi_readonly;


--
-- TOC entry 7712 (class 0 OID 0)
-- Dependencies: 18
-- Name: SCHEMA groups; Type: ACL; Schema: -; Owner: groups
--

GRANT USAGE ON SCHEMA groups TO power_bi_readonly;


--
-- TOC entry 7713 (class 0 OID 0)
-- Dependencies: 19
-- Name: SCHEMA identity; Type: ACL; Schema: -; Owner: identity
--

GRANT USAGE ON SCHEMA identity TO power_bi_readonly;


--
-- TOC entry 7714 (class 0 OID 0)
-- Dependencies: 20
-- Name: SCHEMA lookups; Type: ACL; Schema: -; Owner: lookups
--

GRANT USAGE ON SCHEMA lookups TO power_bi_readonly;


--
-- TOC entry 7715 (class 0 OID 0)
-- Dependencies: 21
-- Name: SCHEMA members; Type: ACL; Schema: -; Owner: members
--

GRANT USAGE ON SCHEMA members TO power_bi_readonly;


--
-- TOC entry 7716 (class 0 OID 0)
-- Dependencies: 22
-- Name: SCHEMA messages; Type: ACL; Schema: -; Owner: messages
--

GRANT ALL ON SCHEMA messages TO PUBLIC;
GRANT USAGE ON SCHEMA messages TO power_bi_readonly;


--
-- TOC entry 7718 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA notifications; Type: ACL; Schema: -; Owner: notifications
--

GRANT ALL ON SCHEMA notifications TO PUBLIC;
GRANT USAGE ON SCHEMA notifications TO power_bi_readonly;


--
-- TOC entry 7720 (class 0 OID 0)
-- Dependencies: 24
-- Name: SCHEMA projects; Type: ACL; Schema: -; Owner: projects
--

REVOKE ALL ON SCHEMA projects FROM pg_database_owner;
REVOKE USAGE ON SCHEMA projects FROM PUBLIC;
GRANT ALL ON SCHEMA projects TO projects;
GRANT ALL ON SCHEMA projects TO finance;
GRANT ALL ON SCHEMA projects TO PUBLIC;
GRANT USAGE ON SCHEMA projects TO power_bi_readonly;


--
-- TOC entry 7722 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: topcoder
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- TOC entry 7723 (class 0 OID 0)
-- Dependencies: 25
-- Name: SCHEMA resources; Type: ACL; Schema: -; Owner: resources
--

GRANT USAGE ON SCHEMA resources TO challenges;
GRANT USAGE ON SCHEMA resources TO power_bi_readonly;


--
-- TOC entry 7724 (class 0 OID 0)
-- Dependencies: 26
-- Name: SCHEMA reviews; Type: ACL; Schema: -; Owner: reviews
--

GRANT USAGE ON SCHEMA reviews TO challenges;
GRANT USAGE ON SCHEMA reviews TO power_bi_readonly;


--
-- TOC entry 7726 (class 0 OID 0)
-- Dependencies: 27
-- Name: SCHEMA skills; Type: ACL; Schema: -; Owner: skills
--

GRANT ALL ON SCHEMA skills TO PUBLIC;
GRANT ALL ON SCHEMA skills TO member_skills;
GRANT USAGE ON SCHEMA skills TO power_bi_readonly;


--
-- TOC entry 7728 (class 0 OID 0)
-- Dependencies: 28
-- Name: SCHEMA taas; Type: ACL; Schema: -; Owner: taas
--

GRANT USAGE ON SCHEMA taas TO power_bi_readonly;


--
-- TOC entry 7729 (class 0 OID 0)
-- Dependencies: 29
-- Name: SCHEMA terms; Type: ACL; Schema: -; Owner: terms
--

GRANT USAGE ON SCHEMA terms TO power_bi_readonly;


--
-- TOC entry 7731 (class 0 OID 0)
-- Dependencies: 30
-- Name: SCHEMA timeline; Type: ACL; Schema: -; Owner: timeline
--

GRANT ALL ON SCHEMA timeline TO PUBLIC;
GRANT USAGE ON SCHEMA timeline TO power_bi_readonly;


--
-- TOC entry 7737 (class 0 OID 0)
-- Dependencies: 664
-- Name: FUNCTION handle_appeal_change(); Type: ACL; Schema: reviews; Owner: reviews
--

GRANT ALL ON FUNCTION reviews.handle_appeal_change() TO challenges;


--
-- TOC entry 7738 (class 0 OID 0)
-- Dependencies: 665
-- Name: FUNCTION handle_appeal_response_change(); Type: ACL; Schema: reviews; Owner: reviews
--

GRANT ALL ON FUNCTION reviews.handle_appeal_response_change() TO challenges;


--
-- TOC entry 7739 (class 0 OID 0)
-- Dependencies: 663
-- Name: FUNCTION update_review_pending_summary_for_resource(p_resource_id text); Type: ACL; Schema: reviews; Owner: reviews
--

GRANT ALL ON FUNCTION reviews.update_review_pending_summary_for_resource(p_resource_id text) TO challenges;


--
-- TOC entry 7740 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE "CertificationCategory"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationCategory" TO academy;
GRANT SELECT ON TABLE academy."CertificationCategory" TO power_bi_readonly;


--
-- TOC entry 7742 (class 0 OID 0)
-- Dependencies: 345
-- Name: SEQUENCE "CertificationCategory_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationCategory_id_seq" TO academy;


--
-- TOC entry 7743 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE "CertificationEnrollments"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationEnrollments" TO academy;
GRANT SELECT ON TABLE academy."CertificationEnrollments" TO power_bi_readonly;


--
-- TOC entry 7745 (class 0 OID 0)
-- Dependencies: 347
-- Name: SEQUENCE "CertificationEnrollments_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationEnrollments_id_seq" TO academy;


--
-- TOC entry 7746 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE "CertificationResource"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationResource" TO academy;
GRANT SELECT ON TABLE academy."CertificationResource" TO power_bi_readonly;


--
-- TOC entry 7747 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE "CertificationResourceProgresses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationResourceProgresses" TO academy;
GRANT SELECT ON TABLE academy."CertificationResourceProgresses" TO power_bi_readonly;


--
-- TOC entry 7749 (class 0 OID 0)
-- Dependencies: 350
-- Name: SEQUENCE "CertificationResourceProgresses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationResourceProgresses_id_seq" TO academy;


--
-- TOC entry 7751 (class 0 OID 0)
-- Dependencies: 351
-- Name: SEQUENCE "CertificationResource_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationResource_id_seq" TO academy;


--
-- TOC entry 7752 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE "DataVersion"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."DataVersion" TO academy;
GRANT SELECT ON TABLE academy."DataVersion" TO power_bi_readonly;


--
-- TOC entry 7753 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE "FccCertificationProgresses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccCertificationProgresses" TO academy;
GRANT SELECT ON TABLE academy."FccCertificationProgresses" TO power_bi_readonly;


--
-- TOC entry 7755 (class 0 OID 0)
-- Dependencies: 354
-- Name: SEQUENCE "FccCertificationProgresses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccCertificationProgresses_id_seq" TO academy;


--
-- TOC entry 7756 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE "FccCompletedLessons"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccCompletedLessons" TO academy;
GRANT SELECT ON TABLE academy."FccCompletedLessons" TO power_bi_readonly;


--
-- TOC entry 7757 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE "FccCourses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccCourses" TO academy;
GRANT SELECT ON TABLE academy."FccCourses" TO power_bi_readonly;


--
-- TOC entry 7759 (class 0 OID 0)
-- Dependencies: 357
-- Name: SEQUENCE "FccCourses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccCourses_id_seq" TO academy;


--
-- TOC entry 7760 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE "FccLessons"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccLessons" TO academy;
GRANT SELECT ON TABLE academy."FccLessons" TO power_bi_readonly;


--
-- TOC entry 7761 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE "FccModuleProgresses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccModuleProgresses" TO academy;
GRANT SELECT ON TABLE academy."FccModuleProgresses" TO power_bi_readonly;


--
-- TOC entry 7763 (class 0 OID 0)
-- Dependencies: 360
-- Name: SEQUENCE "FccModuleProgresses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccModuleProgresses_id_seq" TO academy;


--
-- TOC entry 7764 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE "FccModules"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccModules" TO academy;
GRANT SELECT ON TABLE academy."FccModules" TO power_bi_readonly;


--
-- TOC entry 7766 (class 0 OID 0)
-- Dependencies: 362
-- Name: SEQUENCE "FccModules_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccModules_id_seq" TO academy;


--
-- TOC entry 7767 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE "FreeCodeCampCertification"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FreeCodeCampCertification" TO academy;
GRANT SELECT ON TABLE academy."FreeCodeCampCertification" TO power_bi_readonly;


--
-- TOC entry 7769 (class 0 OID 0)
-- Dependencies: 364
-- Name: SEQUENCE "FreeCodeCampCertification_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FreeCodeCampCertification_id_seq" TO academy;


--
-- TOC entry 7770 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE "ResourceProvider"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."ResourceProvider" TO academy;
GRANT SELECT ON TABLE academy."ResourceProvider" TO power_bi_readonly;


--
-- TOC entry 7772 (class 0 OID 0)
-- Dependencies: 366
-- Name: SEQUENCE "ResourceProvider_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."ResourceProvider_id_seq" TO academy;


--
-- TOC entry 7773 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."SequelizeMeta" TO academy;
GRANT SELECT ON TABLE academy."SequelizeMeta" TO power_bi_readonly;


--
-- TOC entry 7774 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE "TopcoderCertification"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."TopcoderCertification" TO academy;
GRANT SELECT ON TABLE academy."TopcoderCertification" TO power_bi_readonly;


--
-- TOC entry 7776 (class 0 OID 0)
-- Dependencies: 369
-- Name: SEQUENCE "TopcoderCertification_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."TopcoderCertification_id_seq" TO academy;


--
-- TOC entry 7777 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE "TopcoderUdemyCourse"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."TopcoderUdemyCourse" TO academy;
GRANT SELECT ON TABLE academy."TopcoderUdemyCourse" TO power_bi_readonly;


--
-- TOC entry 7778 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE "UdemyCourse"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."UdemyCourse" TO academy;
GRANT SELECT ON TABLE academy."UdemyCourse" TO power_bi_readonly;


--
-- TOC entry 7779 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE "fccCertsModulesLessons"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."fccCertsModulesLessons" TO academy;
GRANT SELECT ON TABLE academy."fccCertsModulesLessons" TO power_bi_readonly;


--
-- TOC entry 7780 (class 0 OID 0)
-- Dependencies: 599
-- Name: TABLE actions; Type: ACL; Schema: autopilot; Owner: autopilot
--

GRANT SELECT ON TABLE autopilot.actions TO power_bi_readonly;


--
-- TOC entry 7781 (class 0 OID 0)
-- Dependencies: 603
-- Name: TABLE "BillingAccount"; Type: ACL; Schema: billing-accounts; Owner: billingaccounts
--

GRANT SELECT ON TABLE "billing-accounts"."BillingAccount" TO power_bi_readonly;


--
-- TOC entry 7782 (class 0 OID 0)
-- Dependencies: 606
-- Name: TABLE "BillingAccountAccess"; Type: ACL; Schema: billing-accounts; Owner: billingaccounts
--

GRANT SELECT ON TABLE "billing-accounts"."BillingAccountAccess" TO power_bi_readonly;


--
-- TOC entry 7784 (class 0 OID 0)
-- Dependencies: 602
-- Name: TABLE "Client"; Type: ACL; Schema: billing-accounts; Owner: billingaccounts
--

GRANT SELECT ON TABLE "billing-accounts"."Client" TO power_bi_readonly;


--
-- TOC entry 7785 (class 0 OID 0)
-- Dependencies: 605
-- Name: TABLE "ConsumedAmount"; Type: ACL; Schema: billing-accounts; Owner: billingaccounts
--

GRANT SELECT ON TABLE "billing-accounts"."ConsumedAmount" TO power_bi_readonly;


--
-- TOC entry 7786 (class 0 OID 0)
-- Dependencies: 604
-- Name: TABLE "LockedAmount"; Type: ACL; Schema: billing-accounts; Owner: billingaccounts
--

GRANT SELECT ON TABLE "billing-accounts"."LockedAmount" TO power_bi_readonly;


--
-- TOC entry 7787 (class 0 OID 0)
-- Dependencies: 601
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: billing-accounts; Owner: billingaccounts
--

GRANT SELECT ON TABLE "billing-accounts"._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7788 (class 0 OID 0)
-- Dependencies: 476
-- Name: TABLE "Attachment"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."Attachment" TO power_bi_readonly;


--
-- TOC entry 7789 (class 0 OID 0)
-- Dependencies: 475
-- Name: TABLE "AuditLog"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."AuditLog" TO power_bi_readonly;


--
-- TOC entry 7790 (class 0 OID 0)
-- Dependencies: 471
-- Name: TABLE "Challenge"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."Challenge" TO power_bi_readonly;


--
-- TOC entry 7791 (class 0 OID 0)
-- Dependencies: 482
-- Name: TABLE "ChallengeBilling"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeBilling" TO power_bi_readonly;


--
-- TOC entry 7792 (class 0 OID 0)
-- Dependencies: 487
-- Name: TABLE "ChallengeConstraint"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeConstraint" TO power_bi_readonly;


--
-- TOC entry 7793 (class 0 OID 0)
-- Dependencies: 485
-- Name: TABLE "ChallengeDiscussion"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeDiscussion" TO power_bi_readonly;


--
-- TOC entry 7794 (class 0 OID 0)
-- Dependencies: 486
-- Name: TABLE "ChallengeDiscussionOption"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeDiscussionOption" TO power_bi_readonly;


--
-- TOC entry 7795 (class 0 OID 0)
-- Dependencies: 484
-- Name: TABLE "ChallengeEvent"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeEvent" TO power_bi_readonly;


--
-- TOC entry 7796 (class 0 OID 0)
-- Dependencies: 483
-- Name: TABLE "ChallengeLegacy"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeLegacy" TO power_bi_readonly;


--
-- TOC entry 7797 (class 0 OID 0)
-- Dependencies: 477
-- Name: TABLE "ChallengeMetadata"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeMetadata" TO power_bi_readonly;


--
-- TOC entry 7798 (class 0 OID 0)
-- Dependencies: 489
-- Name: TABLE "ChallengePhase"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengePhase" TO power_bi_readonly;


--
-- TOC entry 7799 (class 0 OID 0)
-- Dependencies: 490
-- Name: TABLE "ChallengePhaseConstraint"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengePhaseConstraint" TO power_bi_readonly;


--
-- TOC entry 7800 (class 0 OID 0)
-- Dependencies: 491
-- Name: TABLE "ChallengePrizeSet"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengePrizeSet" TO power_bi_readonly;


--
-- TOC entry 7801 (class 0 OID 0)
-- Dependencies: 494
-- Name: TABLE "ChallengeReviewer"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeReviewer" TO power_bi_readonly;


--
-- TOC entry 7802 (class 0 OID 0)
-- Dependencies: 481
-- Name: TABLE "ChallengeSkill"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeSkill" TO power_bi_readonly;


--
-- TOC entry 7803 (class 0 OID 0)
-- Dependencies: 480
-- Name: TABLE "ChallengeTerm"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeTerm" TO power_bi_readonly;


--
-- TOC entry 7804 (class 0 OID 0)
-- Dependencies: 474
-- Name: TABLE "ChallengeTimelineTemplate"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeTimelineTemplate" TO power_bi_readonly;


--
-- TOC entry 7805 (class 0 OID 0)
-- Dependencies: 473
-- Name: TABLE "ChallengeTrack"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeTrack" TO power_bi_readonly;


--
-- TOC entry 7806 (class 0 OID 0)
-- Dependencies: 472
-- Name: TABLE "ChallengeType"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeType" TO power_bi_readonly;


--
-- TOC entry 7807 (class 0 OID 0)
-- Dependencies: 479
-- Name: TABLE "ChallengeWinner"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."ChallengeWinner" TO power_bi_readonly;


--
-- TOC entry 7808 (class 0 OID 0)
-- Dependencies: 495
-- Name: TABLE "DefaultChallengeReviewer"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."DefaultChallengeReviewer" TO power_bi_readonly;


--
-- TOC entry 7809 (class 0 OID 0)
-- Dependencies: 498
-- Name: TABLE "Resource"; Type: ACL; Schema: resources; Owner: resources
--

GRANT SELECT ON TABLE resources."Resource" TO challenges;
GRANT SELECT ON TABLE resources."Resource" TO power_bi_readonly;


--
-- TOC entry 7810 (class 0 OID 0)
-- Dependencies: 488
-- Name: TABLE "Phase"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."Phase" TO power_bi_readonly;


--
-- TOC entry 7811 (class 0 OID 0)
-- Dependencies: 478
-- Name: TABLE "Prize"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."Prize" TO power_bi_readonly;


--
-- TOC entry 7812 (class 0 OID 0)
-- Dependencies: 492
-- Name: TABLE "TimelineTemplate"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."TimelineTemplate" TO power_bi_readonly;


--
-- TOC entry 7813 (class 0 OID 0)
-- Dependencies: 493
-- Name: TABLE "TimelineTemplatePhase"; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges."TimelineTemplatePhase" TO power_bi_readonly;


--
-- TOC entry 7814 (class 0 OID 0)
-- Dependencies: 470
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: challenges; Owner: challenges
--

GRANT SELECT ON TABLE challenges._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7815 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE "Emails"; Type: ACL; Schema: emails; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE emails."Emails" TO emails;
GRANT SELECT ON TABLE emails."Emails" TO power_bi_readonly;


--
-- TOC entry 7817 (class 0 OID 0)
-- Dependencies: 383
-- Name: SEQUENCE "Emails_id_seq"; Type: ACL; Schema: emails; Owner: topcoder
--

GRANT ALL ON SEQUENCE emails."Emails_id_seq" TO emails;


--
-- TOC entry 7818 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7819 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE audit; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.audit TO power_bi_readonly;


--
-- TOC entry 7820 (class 0 OID 0)
-- Dependencies: 598
-- Name: TABLE challenge_lock; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.challenge_lock TO power_bi_readonly;


--
-- TOC entry 7822 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE origin; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.origin TO power_bi_readonly;


--
-- TOC entry 7824 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE otp; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.otp TO power_bi_readonly;


--
-- TOC entry 7825 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE payment; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.payment TO power_bi_readonly;


--
-- TOC entry 7826 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE payment_method; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.payment_method TO power_bi_readonly;


--
-- TOC entry 7828 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE payment_release_associations; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.payment_release_associations TO power_bi_readonly;


--
-- TOC entry 7829 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE payment_releases; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.payment_releases TO power_bi_readonly;


--
-- TOC entry 7830 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE trolley_recipient; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.trolley_recipient TO power_bi_readonly;


--
-- TOC entry 7832 (class 0 OID 0)
-- Dependencies: 322
-- Name: TABLE trolley_recipient_payment_method; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.trolley_recipient_payment_method TO power_bi_readonly;


--
-- TOC entry 7833 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE trolley_webhook_log; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.trolley_webhook_log TO power_bi_readonly;


--
-- TOC entry 7834 (class 0 OID 0)
-- Dependencies: 432
-- Name: TABLE user_identity_verification_associations; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.user_identity_verification_associations TO power_bi_readonly;


--
-- TOC entry 7835 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE user_payment_methods; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.user_payment_methods TO power_bi_readonly;


--
-- TOC entry 7836 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE user_tax_form_associations; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.user_tax_form_associations TO power_bi_readonly;


--
-- TOC entry 7837 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE winnings; Type: ACL; Schema: finance; Owner: finance
--

GRANT SELECT ON TABLE finance.winnings TO power_bi_readonly;


--
-- TOC entry 7838 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification."SequelizeMeta" TO gamification;
GRANT SELECT ON TABLE gamification."SequelizeMeta" TO power_bi_readonly;


--
-- TOC entry 7839 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE badge_custom_fields; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.badge_custom_fields TO gamification;
GRANT SELECT ON TABLE gamification.badge_custom_fields TO power_bi_readonly;


--
-- TOC entry 7840 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE member_badges; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.member_badges TO gamification;
GRANT SELECT ON TABLE gamification.member_badges TO power_bi_readonly;


--
-- TOC entry 7841 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE organization; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization TO gamification;
GRANT SELECT ON TABLE gamification.organization TO power_bi_readonly;


--
-- TOC entry 7842 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE organization_badges; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization_badges TO gamification;
GRANT SELECT ON TABLE gamification.organization_badges TO power_bi_readonly;


--
-- TOC entry 7843 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE organization_badges_custom_fields; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization_badges_custom_fields TO gamification;
GRANT SELECT ON TABLE gamification.organization_badges_custom_fields TO power_bi_readonly;


--
-- TOC entry 7844 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE organization_badges_tags; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization_badges_tags TO gamification;
GRANT SELECT ON TABLE gamification.organization_badges_tags TO power_bi_readonly;


--
-- TOC entry 7845 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE tags; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.tags TO gamification;
GRANT SELECT ON TABLE gamification.tags TO power_bi_readonly;


--
-- TOC entry 7846 (class 0 OID 0)
-- Dependencies: 609
-- Name: TABLE "Group"; Type: ACL; Schema: groups; Owner: groups
--

GRANT SELECT ON TABLE groups."Group" TO power_bi_readonly;


--
-- TOC entry 7847 (class 0 OID 0)
-- Dependencies: 610
-- Name: TABLE "GroupMember"; Type: ACL; Schema: groups; Owner: groups
--

GRANT SELECT ON TABLE groups."GroupMember" TO power_bi_readonly;


--
-- TOC entry 7848 (class 0 OID 0)
-- Dependencies: 611
-- Name: TABLE "User"; Type: ACL; Schema: groups; Owner: groups
--

GRANT SELECT ON TABLE groups."User" TO power_bi_readonly;


--
-- TOC entry 7849 (class 0 OID 0)
-- Dependencies: 612
-- Name: TABLE "_ParentSubGroups"; Type: ACL; Schema: groups; Owner: groups
--

GRANT SELECT ON TABLE groups."_ParentSubGroups" TO power_bi_readonly;


--
-- TOC entry 7850 (class 0 OID 0)
-- Dependencies: 608
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: groups; Owner: groups
--

GRANT SELECT ON TABLE groups._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7851 (class 0 OID 0)
-- Dependencies: 433
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7852 (class 0 OID 0)
-- Dependencies: 436
-- Name: TABLE achievement_type_lu; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.achievement_type_lu TO power_bi_readonly;


--
-- TOC entry 7853 (class 0 OID 0)
-- Dependencies: 464
-- Name: TABLE client; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.client TO power_bi_readonly;


--
-- TOC entry 7855 (class 0 OID 0)
-- Dependencies: 437
-- Name: TABLE country; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.country TO power_bi_readonly;


--
-- TOC entry 7856 (class 0 OID 0)
-- Dependencies: 439
-- Name: TABLE dice_connection; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.dice_connection TO power_bi_readonly;


--
-- TOC entry 7858 (class 0 OID 0)
-- Dependencies: 440
-- Name: TABLE email; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.email TO power_bi_readonly;


--
-- TOC entry 7859 (class 0 OID 0)
-- Dependencies: 441
-- Name: TABLE email_status_lu; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.email_status_lu TO power_bi_readonly;


--
-- TOC entry 7860 (class 0 OID 0)
-- Dependencies: 442
-- Name: TABLE email_type_lu; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.email_type_lu TO power_bi_readonly;


--
-- TOC entry 7861 (class 0 OID 0)
-- Dependencies: 443
-- Name: TABLE id_sequences; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.id_sequences TO power_bi_readonly;


--
-- TOC entry 7862 (class 0 OID 0)
-- Dependencies: 444
-- Name: TABLE invalid_handles; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.invalid_handles TO power_bi_readonly;


--
-- TOC entry 7863 (class 0 OID 0)
-- Dependencies: 466
-- Name: TABLE role; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.role TO power_bi_readonly;


--
-- TOC entry 7864 (class 0 OID 0)
-- Dependencies: 468
-- Name: TABLE role_assignment; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.role_assignment TO power_bi_readonly;


--
-- TOC entry 7867 (class 0 OID 0)
-- Dependencies: 445
-- Name: TABLE security_groups; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.security_groups TO power_bi_readonly;


--
-- TOC entry 7868 (class 0 OID 0)
-- Dependencies: 446
-- Name: TABLE security_status_lu; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.security_status_lu TO power_bi_readonly;


--
-- TOC entry 7869 (class 0 OID 0)
-- Dependencies: 447
-- Name: TABLE security_user; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.security_user TO power_bi_readonly;


--
-- TOC entry 7870 (class 0 OID 0)
-- Dependencies: 448
-- Name: TABLE social_login_provider; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.social_login_provider TO power_bi_readonly;


--
-- TOC entry 7871 (class 0 OID 0)
-- Dependencies: 449
-- Name: TABLE sso_login_provider; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.sso_login_provider TO power_bi_readonly;


--
-- TOC entry 7872 (class 0 OID 0)
-- Dependencies: 450
-- Name: TABLE "user"; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity."user" TO power_bi_readonly;


--
-- TOC entry 7873 (class 0 OID 0)
-- Dependencies: 452
-- Name: TABLE user_2fa; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_2fa TO power_bi_readonly;


--
-- TOC entry 7875 (class 0 OID 0)
-- Dependencies: 453
-- Name: TABLE user_achievement; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_achievement TO power_bi_readonly;


--
-- TOC entry 7876 (class 0 OID 0)
-- Dependencies: 462
-- Name: TABLE user_email_xref; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_email_xref TO power_bi_readonly;


--
-- TOC entry 7877 (class 0 OID 0)
-- Dependencies: 454
-- Name: TABLE user_group_xref; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_group_xref TO power_bi_readonly;


--
-- TOC entry 7878 (class 0 OID 0)
-- Dependencies: 456
-- Name: TABLE user_otp_email; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_otp_email TO power_bi_readonly;


--
-- TOC entry 7880 (class 0 OID 0)
-- Dependencies: 457
-- Name: TABLE user_social_login; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_social_login TO power_bi_readonly;


--
-- TOC entry 7881 (class 0 OID 0)
-- Dependencies: 458
-- Name: TABLE user_sso_login; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_sso_login TO power_bi_readonly;


--
-- TOC entry 7882 (class 0 OID 0)
-- Dependencies: 459
-- Name: TABLE user_status; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_status TO power_bi_readonly;


--
-- TOC entry 7883 (class 0 OID 0)
-- Dependencies: 460
-- Name: TABLE user_status_lu; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_status_lu TO power_bi_readonly;


--
-- TOC entry 7884 (class 0 OID 0)
-- Dependencies: 461
-- Name: TABLE user_status_type_lu; Type: ACL; Schema: identity; Owner: identity
--

GRANT SELECT ON TABLE identity.user_status_type_lu TO power_bi_readonly;


--
-- TOC entry 7885 (class 0 OID 0)
-- Dependencies: 566
-- Name: TABLE "Country"; Type: ACL; Schema: lookups; Owner: lookups
--

GRANT SELECT ON TABLE lookups."Country" TO power_bi_readonly;


--
-- TOC entry 7886 (class 0 OID 0)
-- Dependencies: 567
-- Name: TABLE "Device"; Type: ACL; Schema: lookups; Owner: lookups
--

GRANT SELECT ON TABLE lookups."Device" TO power_bi_readonly;


--
-- TOC entry 7887 (class 0 OID 0)
-- Dependencies: 568
-- Name: TABLE "EducationalInstitution"; Type: ACL; Schema: lookups; Owner: lookups
--

GRANT SELECT ON TABLE lookups."EducationalInstitution" TO power_bi_readonly;


--
-- TOC entry 7888 (class 0 OID 0)
-- Dependencies: 565
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: lookups; Owner: lookups
--

GRANT SELECT ON TABLE lookups._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7889 (class 0 OID 0)
-- Dependencies: 500
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 7890 (class 0 OID 0)
-- Dependencies: 561
-- Name: TABLE "displayMode"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."displayMode" TO power_bi_readonly;


--
-- TOC entry 7891 (class 0 OID 0)
-- Dependencies: 507
-- Name: TABLE "distributionStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."distributionStats" TO power_bi_readonly;


--
-- TOC entry 7893 (class 0 OID 0)
-- Dependencies: 501
-- Name: TABLE member; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members.member TO power_bi_readonly;


--
-- TOC entry 7894 (class 0 OID 0)
-- Dependencies: 503
-- Name: TABLE "memberAddress"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberAddress" TO power_bi_readonly;


--
-- TOC entry 7896 (class 0 OID 0)
-- Dependencies: 518
-- Name: TABLE "memberCopilotStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberCopilotStats" TO power_bi_readonly;


--
-- TOC entry 7898 (class 0 OID 0)
-- Dependencies: 514
-- Name: TABLE "memberDataScienceHistoryStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDataScienceHistoryStats" TO power_bi_readonly;


--
-- TOC entry 7900 (class 0 OID 0)
-- Dependencies: 528
-- Name: TABLE "memberDataScienceStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDataScienceStats" TO power_bi_readonly;


--
-- TOC entry 7902 (class 0 OID 0)
-- Dependencies: 524
-- Name: TABLE "memberDesignStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDesignStats" TO power_bi_readonly;


--
-- TOC entry 7903 (class 0 OID 0)
-- Dependencies: 526
-- Name: TABLE "memberDesignStatsItem"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDesignStatsItem" TO power_bi_readonly;


--
-- TOC entry 7906 (class 0 OID 0)
-- Dependencies: 512
-- Name: TABLE "memberDevelopHistoryStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDevelopHistoryStats" TO power_bi_readonly;


--
-- TOC entry 7908 (class 0 OID 0)
-- Dependencies: 520
-- Name: TABLE "memberDevelopStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDevelopStats" TO power_bi_readonly;


--
-- TOC entry 7909 (class 0 OID 0)
-- Dependencies: 522
-- Name: TABLE "memberDevelopStatsItem"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberDevelopStatsItem" TO power_bi_readonly;


--
-- TOC entry 7912 (class 0 OID 0)
-- Dependencies: 508
-- Name: TABLE "memberFinancial"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberFinancial" TO power_bi_readonly;


--
-- TOC entry 7913 (class 0 OID 0)
-- Dependencies: 510
-- Name: TABLE "memberHistoryStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberHistoryStats" TO power_bi_readonly;


--
-- TOC entry 7915 (class 0 OID 0)
-- Dependencies: 536
-- Name: TABLE "memberMarathonStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberMarathonStats" TO power_bi_readonly;


--
-- TOC entry 7917 (class 0 OID 0)
-- Dependencies: 505
-- Name: TABLE "memberMaxRating"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberMaxRating" TO power_bi_readonly;


--
-- TOC entry 7919 (class 0 OID 0)
-- Dependencies: 563
-- Name: TABLE "memberSkill"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberSkill" TO power_bi_readonly;


--
-- TOC entry 7920 (class 0 OID 0)
-- Dependencies: 564
-- Name: TABLE "memberSkillLevel"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberSkillLevel" TO power_bi_readonly;


--
-- TOC entry 7921 (class 0 OID 0)
-- Dependencies: 532
-- Name: TABLE "memberSrmChallengeDetail"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberSrmChallengeDetail" TO power_bi_readonly;


--
-- TOC entry 7923 (class 0 OID 0)
-- Dependencies: 534
-- Name: TABLE "memberSrmDivisionDetail"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberSrmDivisionDetail" TO power_bi_readonly;


--
-- TOC entry 7925 (class 0 OID 0)
-- Dependencies: 530
-- Name: TABLE "memberSrmStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberSrmStats" TO power_bi_readonly;


--
-- TOC entry 7927 (class 0 OID 0)
-- Dependencies: 516
-- Name: TABLE "memberStats"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberStats" TO power_bi_readonly;


--
-- TOC entry 7929 (class 0 OID 0)
-- Dependencies: 550
-- Name: TABLE "memberTraitBasicInfo"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitBasicInfo" TO power_bi_readonly;


--
-- TOC entry 7931 (class 0 OID 0)
-- Dependencies: 558
-- Name: TABLE "memberTraitCommunity"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitCommunity" TO power_bi_readonly;


--
-- TOC entry 7933 (class 0 OID 0)
-- Dependencies: 540
-- Name: TABLE "memberTraitDevice"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitDevice" TO power_bi_readonly;


--
-- TOC entry 7935 (class 0 OID 0)
-- Dependencies: 548
-- Name: TABLE "memberTraitEducation"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitEducation" TO power_bi_readonly;


--
-- TOC entry 7937 (class 0 OID 0)
-- Dependencies: 552
-- Name: TABLE "memberTraitLanguage"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitLanguage" TO power_bi_readonly;


--
-- TOC entry 7939 (class 0 OID 0)
-- Dependencies: 554
-- Name: TABLE "memberTraitOnboardChecklist"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitOnboardChecklist" TO power_bi_readonly;


--
-- TOC entry 7941 (class 0 OID 0)
-- Dependencies: 556
-- Name: TABLE "memberTraitPersonalization"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitPersonalization" TO power_bi_readonly;


--
-- TOC entry 7943 (class 0 OID 0)
-- Dependencies: 544
-- Name: TABLE "memberTraitServiceProvider"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitServiceProvider" TO power_bi_readonly;


--
-- TOC entry 7945 (class 0 OID 0)
-- Dependencies: 542
-- Name: TABLE "memberTraitSoftware"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitSoftware" TO power_bi_readonly;


--
-- TOC entry 7947 (class 0 OID 0)
-- Dependencies: 546
-- Name: TABLE "memberTraitWork"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraitWork" TO power_bi_readonly;


--
-- TOC entry 7949 (class 0 OID 0)
-- Dependencies: 538
-- Name: TABLE "memberTraits"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."memberTraits" TO power_bi_readonly;


--
-- TOC entry 7951 (class 0 OID 0)
-- Dependencies: 560
-- Name: TABLE skill; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members.skill TO power_bi_readonly;


--
-- TOC entry 7952 (class 0 OID 0)
-- Dependencies: 559
-- Name: TABLE "skillCategory"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."skillCategory" TO power_bi_readonly;


--
-- TOC entry 7953 (class 0 OID 0)
-- Dependencies: 562
-- Name: TABLE "skillLevel"; Type: ACL; Schema: members; Owner: members
--

GRANT SELECT ON TABLE members."skillLevel" TO power_bi_readonly;


--
-- TOC entry 7954 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages."SequelizeMeta" TO messages;
GRANT SELECT ON TABLE messages."SequelizeMeta" TO power_bi_readonly;


--
-- TOC entry 7955 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE email_logs; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.email_logs TO messages;
GRANT SELECT ON TABLE messages.email_logs TO power_bi_readonly;


--
-- TOC entry 7957 (class 0 OID 0)
-- Dependencies: 333
-- Name: SEQUENCE email_logs_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.email_logs_id_seq TO messages;


--
-- TOC entry 7958 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE post_attachments; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.post_attachments TO messages;
GRANT SELECT ON TABLE messages.post_attachments TO power_bi_readonly;


--
-- TOC entry 7960 (class 0 OID 0)
-- Dependencies: 335
-- Name: SEQUENCE post_attachments_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.post_attachments_id_seq TO messages;


--
-- TOC entry 7961 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE post_user_stats; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.post_user_stats TO messages;
GRANT SELECT ON TABLE messages.post_user_stats TO power_bi_readonly;


--
-- TOC entry 7962 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE posts; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.posts TO messages;
GRANT SELECT ON TABLE messages.posts TO power_bi_readonly;


--
-- TOC entry 7964 (class 0 OID 0)
-- Dependencies: 338
-- Name: SEQUENCE posts_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.posts_id_seq TO messages;


--
-- TOC entry 7965 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE reference_lookups; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.reference_lookups TO messages;
GRANT SELECT ON TABLE messages.reference_lookups TO power_bi_readonly;


--
-- TOC entry 7966 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE topics; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.topics TO messages;
GRANT SELECT ON TABLE messages.topics TO power_bi_readonly;


--
-- TOC entry 7968 (class 0 OID 0)
-- Dependencies: 341
-- Name: SEQUENCE topics_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.topics_id_seq TO messages;


--
-- TOC entry 7969 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE "NotificationSettings"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."NotificationSettings" TO notifications;
GRANT SELECT ON TABLE notifications."NotificationSettings" TO power_bi_readonly;


--
-- TOC entry 7971 (class 0 OID 0)
-- Dependencies: 385
-- Name: SEQUENCE "NotificationSettings_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."NotificationSettings_id_seq" TO notifications;


--
-- TOC entry 7972 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE "Notifications"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."Notifications" TO notifications;
GRANT SELECT ON TABLE notifications."Notifications" TO power_bi_readonly;


--
-- TOC entry 7974 (class 0 OID 0)
-- Dependencies: 387
-- Name: SEQUENCE "Notifications_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."Notifications_id_seq" TO notifications;


--
-- TOC entry 7975 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE "ScheduledEvents"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."ScheduledEvents" TO notifications;
GRANT SELECT ON TABLE notifications."ScheduledEvents" TO power_bi_readonly;


--
-- TOC entry 7977 (class 0 OID 0)
-- Dependencies: 389
-- Name: SEQUENCE "ScheduledEvents_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."ScheduledEvents_id_seq" TO notifications;


--
-- TOC entry 7978 (class 0 OID 0)
-- Dependencies: 390
-- Name: TABLE "ServiceSettings"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."ServiceSettings" TO notifications;
GRANT SELECT ON TABLE notifications."ServiceSettings" TO power_bi_readonly;


--
-- TOC entry 7980 (class 0 OID 0)
-- Dependencies: 391
-- Name: SEQUENCE "ServiceSettings_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."ServiceSettings_id_seq" TO notifications;


--
-- TOC entry 7981 (class 0 OID 0)
-- Dependencies: 392
-- Name: TABLE bk_notifications_20200609; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.bk_notifications_20200609 TO notifications;
GRANT SELECT ON TABLE notifications.bk_notifications_20200609 TO power_bi_readonly;


--
-- TOC entry 7982 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE bulk_message_user_refs; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.bulk_message_user_refs TO notifications;
GRANT SELECT ON TABLE notifications.bulk_message_user_refs TO power_bi_readonly;


--
-- TOC entry 7984 (class 0 OID 0)
-- Dependencies: 394
-- Name: SEQUENCE bulk_message_user_refs_id_seq; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications.bulk_message_user_refs_id_seq TO notifications;


--
-- TOC entry 7985 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE bulk_messages; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.bulk_messages TO notifications;
GRANT SELECT ON TABLE notifications.bulk_messages TO power_bi_readonly;


--
-- TOC entry 7987 (class 0 OID 0)
-- Dependencies: 396
-- Name: SEQUENCE bulk_messages_id_seq; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications.bulk_messages_id_seq TO notifications;


--
-- TOC entry 7988 (class 0 OID 0)
-- Dependencies: 397
-- Name: TABLE tmpbtable; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.tmpbtable TO notifications;
GRANT SELECT ON TABLE notifications.tmpbtable TO power_bi_readonly;


--
-- TOC entry 7989 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects."SequelizeMeta" TO projects;
GRANT SELECT ON TABLE projects."SequelizeMeta" TO power_bi_readonly;


--
-- TOC entry 7990 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE building_blocks; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.building_blocks TO projects;
GRANT SELECT ON TABLE projects.building_blocks TO power_bi_readonly;


--
-- TOC entry 7992 (class 0 OID 0)
-- Dependencies: 242
-- Name: SEQUENCE building_blocks_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.building_blocks_id_seq TO projects;


--
-- TOC entry 7993 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE copilot_applications; Type: ACL; Schema: projects; Owner: projects
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.copilot_applications TO topcoder;
GRANT SELECT ON TABLE projects.copilot_applications TO power_bi_readonly;


--
-- TOC entry 7995 (class 0 OID 0)
-- Dependencies: 304
-- Name: SEQUENCE copilot_applications_id_seq; Type: ACL; Schema: projects; Owner: projects
--

GRANT ALL ON SEQUENCE projects.copilot_applications_id_seq TO topcoder;


--
-- TOC entry 7996 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE copilot_opportunities; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.copilot_opportunities TO projects;
GRANT SELECT ON TABLE projects.copilot_opportunities TO power_bi_readonly;


--
-- TOC entry 7998 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE copilot_opportunities_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.copilot_opportunities_id_seq TO projects;


--
-- TOC entry 7999 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE copilot_requests; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.copilot_requests TO projects;
GRANT SELECT ON TABLE projects.copilot_requests TO power_bi_readonly;


--
-- TOC entry 8001 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE copilot_requests_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.copilot_requests_id_seq TO projects;


--
-- TOC entry 8002 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE customer_payments; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.customer_payments TO projects;
GRANT SELECT ON TABLE projects.customer_payments TO power_bi_readonly;


--
-- TOC entry 8004 (class 0 OID 0)
-- Dependencies: 248
-- Name: SEQUENCE customer_payments_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.customer_payments_id_seq TO projects;


--
-- TOC entry 8005 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE form; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.form TO projects;
GRANT SELECT ON TABLE projects.form TO power_bi_readonly;


--
-- TOC entry 8007 (class 0 OID 0)
-- Dependencies: 250
-- Name: SEQUENCE form_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.form_id_seq TO projects;


--
-- TOC entry 8008 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE milestone_templates; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.milestone_templates TO projects;
GRANT SELECT ON TABLE projects.milestone_templates TO power_bi_readonly;


--
-- TOC entry 8009 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE milestones; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.milestones TO projects;
GRANT SELECT ON TABLE projects.milestones TO power_bi_readonly;


--
-- TOC entry 8011 (class 0 OID 0)
-- Dependencies: 253
-- Name: SEQUENCE milestones_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.milestones_id_seq TO projects;


--
-- TOC entry 8012 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE org_config; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.org_config TO projects;
GRANT SELECT ON TABLE projects.org_config TO power_bi_readonly;


--
-- TOC entry 8014 (class 0 OID 0)
-- Dependencies: 255
-- Name: SEQUENCE org_config_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.org_config_id_seq TO projects;


--
-- TOC entry 8015 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE phase_products; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.phase_products TO projects;
GRANT SELECT ON TABLE projects.phase_products TO power_bi_readonly;


--
-- TOC entry 8017 (class 0 OID 0)
-- Dependencies: 257
-- Name: SEQUENCE phase_products_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.phase_products_id_seq TO projects;


--
-- TOC entry 8018 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE phase_work_streams; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.phase_work_streams TO projects;
GRANT SELECT ON TABLE projects.phase_work_streams TO power_bi_readonly;


--
-- TOC entry 8019 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE plan_config; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.plan_config TO projects;
GRANT SELECT ON TABLE projects.plan_config TO power_bi_readonly;


--
-- TOC entry 8021 (class 0 OID 0)
-- Dependencies: 260
-- Name: SEQUENCE plan_config_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.plan_config_id_seq TO projects;


--
-- TOC entry 8022 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE price_config; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.price_config TO projects;
GRANT SELECT ON TABLE projects.price_config TO power_bi_readonly;


--
-- TOC entry 8024 (class 0 OID 0)
-- Dependencies: 262
-- Name: SEQUENCE price_config_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.price_config_id_seq TO projects;


--
-- TOC entry 8025 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE product_categories; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.product_categories TO projects;
GRANT SELECT ON TABLE projects.product_categories TO power_bi_readonly;


--
-- TOC entry 8027 (class 0 OID 0)
-- Dependencies: 264
-- Name: SEQUENCE product_milestone_templates_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.product_milestone_templates_id_seq TO projects;


--
-- TOC entry 8028 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE product_templates; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.product_templates TO projects;
GRANT SELECT ON TABLE projects.product_templates TO power_bi_readonly;


--
-- TOC entry 8029 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE product_templates_backup; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.product_templates_backup TO projects;
GRANT SELECT ON TABLE projects.product_templates_backup TO power_bi_readonly;


--
-- TOC entry 8031 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE product_templates_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.product_templates_id_seq TO projects;


--
-- TOC entry 8032 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE project_attachments; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_attachments TO projects;
GRANT SELECT ON TABLE projects.project_attachments TO power_bi_readonly;


--
-- TOC entry 8034 (class 0 OID 0)
-- Dependencies: 269
-- Name: SEQUENCE project_attachments_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_attachments_id_seq TO projects;


--
-- TOC entry 8036 (class 0 OID 0)
-- Dependencies: 270
-- Name: SEQUENCE project_estimation_items_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_estimation_items_id_seq TO projects;


--
-- TOC entry 8037 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE project_estimation_items; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_estimation_items TO projects;
GRANT SELECT ON TABLE projects.project_estimation_items TO power_bi_readonly;


--
-- TOC entry 8038 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE project_estimations; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_estimations TO projects;
GRANT SELECT ON TABLE projects.project_estimations TO power_bi_readonly;


--
-- TOC entry 8040 (class 0 OID 0)
-- Dependencies: 273
-- Name: SEQUENCE project_estimations_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_estimations_id_seq TO projects;


--
-- TOC entry 8041 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE project_history; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_history TO projects;
GRANT SELECT ON TABLE projects.project_history TO power_bi_readonly;


--
-- TOC entry 8043 (class 0 OID 0)
-- Dependencies: 275
-- Name: SEQUENCE project_history_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_history_id_seq TO projects;


--
-- TOC entry 8044 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE project_member_invites; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_member_invites TO projects;
GRANT SELECT ON TABLE projects.project_member_invites TO power_bi_readonly;


--
-- TOC entry 8046 (class 0 OID 0)
-- Dependencies: 277
-- Name: SEQUENCE project_member_invites_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_member_invites_id_seq TO projects;


--
-- TOC entry 8047 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE project_members; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_members TO projects;
GRANT SELECT ON TABLE projects.project_members TO power_bi_readonly;


--
-- TOC entry 8049 (class 0 OID 0)
-- Dependencies: 279
-- Name: SEQUENCE project_members_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_members_id_seq TO projects;


--
-- TOC entry 8050 (class 0 OID 0)
-- Dependencies: 280
-- Name: SEQUENCE project_phase_approval_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_phase_approval_id_seq TO projects;


--
-- TOC entry 8051 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE project_phase_approval; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_phase_approval TO projects;
GRANT SELECT ON TABLE projects.project_phase_approval TO power_bi_readonly;


--
-- TOC entry 8052 (class 0 OID 0)
-- Dependencies: 282
-- Name: SEQUENCE project_phase_member_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_phase_member_id_seq TO projects;


--
-- TOC entry 8053 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE project_phase_member; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_phase_member TO projects;
GRANT SELECT ON TABLE projects.project_phase_member TO power_bi_readonly;


--
-- TOC entry 8054 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE project_phases; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_phases TO projects;
GRANT SELECT ON TABLE projects.project_phases TO power_bi_readonly;


--
-- TOC entry 8056 (class 0 OID 0)
-- Dependencies: 285
-- Name: SEQUENCE project_phases_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_phases_id_seq TO projects;


--
-- TOC entry 8057 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE project_settings; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_settings TO projects;
GRANT SELECT ON TABLE projects.project_settings TO power_bi_readonly;


--
-- TOC entry 8059 (class 0 OID 0)
-- Dependencies: 287
-- Name: SEQUENCE project_settings_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_settings_id_seq TO projects;


--
-- TOC entry 8060 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE project_templates; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_templates TO projects;
GRANT SELECT ON TABLE projects.project_templates TO power_bi_readonly;


--
-- TOC entry 8061 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE project_templates_backup; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_templates_backup TO projects;
GRANT SELECT ON TABLE projects.project_templates_backup TO power_bi_readonly;


--
-- TOC entry 8063 (class 0 OID 0)
-- Dependencies: 290
-- Name: SEQUENCE project_templates_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_templates_id_seq TO projects;


--
-- TOC entry 8064 (class 0 OID 0)
-- Dependencies: 291
-- Name: TABLE project_types; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_types TO projects;
GRANT SELECT ON TABLE projects.project_types TO power_bi_readonly;


--
-- TOC entry 8065 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE projects; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.projects TO projects;
GRANT SELECT ON TABLE projects.projects TO power_bi_readonly;


--
-- TOC entry 8067 (class 0 OID 0)
-- Dependencies: 293
-- Name: SEQUENCE projects_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.projects_id_seq TO projects;


--
-- TOC entry 8068 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE scope_change_requests; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.scope_change_requests TO projects;
GRANT SELECT ON TABLE projects.scope_change_requests TO power_bi_readonly;


--
-- TOC entry 8070 (class 0 OID 0)
-- Dependencies: 295
-- Name: SEQUENCE scope_change_requests_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.scope_change_requests_id_seq TO projects;


--
-- TOC entry 8071 (class 0 OID 0)
-- Dependencies: 296
-- Name: TABLE status_history; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.status_history TO projects;
GRANT SELECT ON TABLE projects.status_history TO power_bi_readonly;


--
-- TOC entry 8073 (class 0 OID 0)
-- Dependencies: 297
-- Name: SEQUENCE status_history_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.status_history_id_seq TO projects;


--
-- TOC entry 8074 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE timelines; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.timelines TO projects;
GRANT SELECT ON TABLE projects.timelines TO power_bi_readonly;


--
-- TOC entry 8076 (class 0 OID 0)
-- Dependencies: 299
-- Name: SEQUENCE timelines_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.timelines_id_seq TO projects;


--
-- TOC entry 8077 (class 0 OID 0)
-- Dependencies: 300
-- Name: TABLE work_management_permissions; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.work_management_permissions TO projects;
GRANT SELECT ON TABLE projects.work_management_permissions TO power_bi_readonly;


--
-- TOC entry 8079 (class 0 OID 0)
-- Dependencies: 301
-- Name: SEQUENCE work_management_permissions_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.work_management_permissions_id_seq TO projects;


--
-- TOC entry 8080 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE work_streams; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.work_streams TO projects;
GRANT SELECT ON TABLE projects.work_streams TO power_bi_readonly;


--
-- TOC entry 8082 (class 0 OID 0)
-- Dependencies: 303
-- Name: SEQUENCE work_streams_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.work_streams_id_seq TO projects;


--
-- TOC entry 8083 (class 0 OID 0)
-- Dependencies: 497
-- Name: TABLE "ResourceRole"; Type: ACL; Schema: resources; Owner: resources
--

GRANT SELECT ON TABLE resources."ResourceRole" TO challenges;
GRANT SELECT ON TABLE resources."ResourceRole" TO power_bi_readonly;


--
-- TOC entry 8084 (class 0 OID 0)
-- Dependencies: 499
-- Name: TABLE "ResourceRolePhaseDependency"; Type: ACL; Schema: resources; Owner: resources
--

GRANT SELECT ON TABLE resources."ResourceRolePhaseDependency" TO challenges;
GRANT SELECT ON TABLE resources."ResourceRolePhaseDependency" TO power_bi_readonly;


--
-- TOC entry 8085 (class 0 OID 0)
-- Dependencies: 496
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: resources; Owner: resources
--

GRANT SELECT ON TABLE resources._prisma_migrations TO challenges;
GRANT SELECT ON TABLE resources._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 8086 (class 0 OID 0)
-- Dependencies: 569
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews._prisma_migrations TO challenges;
GRANT SELECT ON TABLE reviews._prisma_migrations TO power_bi_readonly;


--
-- TOC entry 8087 (class 0 OID 0)
-- Dependencies: 591
-- Name: TABLE "aiWorkflow"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."aiWorkflow" TO challenges;
GRANT SELECT ON TABLE reviews."aiWorkflow" TO power_bi_readonly;


--
-- TOC entry 8088 (class 0 OID 0)
-- Dependencies: 592
-- Name: TABLE "aiWorkflowRun"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."aiWorkflowRun" TO challenges;
GRANT SELECT ON TABLE reviews."aiWorkflowRun" TO power_bi_readonly;


--
-- TOC entry 8089 (class 0 OID 0)
-- Dependencies: 593
-- Name: TABLE "aiWorkflowRunItem"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."aiWorkflowRunItem" TO challenges;
GRANT SELECT ON TABLE reviews."aiWorkflowRunItem" TO power_bi_readonly;


--
-- TOC entry 8090 (class 0 OID 0)
-- Dependencies: 594
-- Name: TABLE "aiWorkflowRunItemComment"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."aiWorkflowRunItemComment" TO challenges;
GRANT SELECT ON TABLE reviews."aiWorkflowRunItemComment" TO power_bi_readonly;


--
-- TOC entry 8091 (class 0 OID 0)
-- Dependencies: 577
-- Name: TABLE appeal; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews.appeal TO challenges;
GRANT SELECT ON TABLE reviews.appeal TO power_bi_readonly;


--
-- TOC entry 8092 (class 0 OID 0)
-- Dependencies: 578
-- Name: TABLE "appealResponse"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."appealResponse" TO challenges;
GRANT SELECT ON TABLE reviews."appealResponse" TO power_bi_readonly;


--
-- TOC entry 8093 (class 0 OID 0)
-- Dependencies: 579
-- Name: TABLE "challengeResult"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."challengeResult" TO challenges;
GRANT SELECT ON TABLE reviews."challengeResult" TO power_bi_readonly;


--
-- TOC entry 8094 (class 0 OID 0)
-- Dependencies: 580
-- Name: TABLE "contactRequest"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."contactRequest" TO challenges;
GRANT SELECT ON TABLE reviews."contactRequest" TO power_bi_readonly;


--
-- TOC entry 8095 (class 0 OID 0)
-- Dependencies: 588
-- Name: TABLE "gitWebhookLog"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."gitWebhookLog" TO challenges;
GRANT SELECT ON TABLE reviews."gitWebhookLog" TO power_bi_readonly;


--
-- TOC entry 8096 (class 0 OID 0)
-- Dependencies: 590
-- Name: TABLE "llmModel"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."llmModel" TO challenges;
GRANT SELECT ON TABLE reviews."llmModel" TO power_bi_readonly;


--
-- TOC entry 8097 (class 0 OID 0)
-- Dependencies: 589
-- Name: TABLE "llmProvider"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."llmProvider" TO challenges;
GRANT SELECT ON TABLE reviews."llmProvider" TO power_bi_readonly;


--
-- TOC entry 8098 (class 0 OID 0)
-- Dependencies: 587
-- Name: TABLE "resourceSubmission"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."resourceSubmission" TO challenges;
GRANT SELECT ON TABLE reviews."resourceSubmission" TO power_bi_readonly;


--
-- TOC entry 8099 (class 0 OID 0)
-- Dependencies: 574
-- Name: TABLE review; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews.review TO challenges;
GRANT SELECT ON TABLE reviews.review TO power_bi_readonly;


--
-- TOC entry 8100 (class 0 OID 0)
-- Dependencies: 582
-- Name: TABLE "reviewApplication"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewApplication" TO challenges;
GRANT SELECT ON TABLE reviews."reviewApplication" TO power_bi_readonly;


--
-- TOC entry 8101 (class 0 OID 0)
-- Dependencies: 595
-- Name: TABLE "reviewAudit"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewAudit" TO challenges;
GRANT SELECT ON TABLE reviews."reviewAudit" TO power_bi_readonly;


--
-- TOC entry 8102 (class 0 OID 0)
-- Dependencies: 575
-- Name: TABLE "reviewItem"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewItem" TO challenges;
GRANT SELECT ON TABLE reviews."reviewItem" TO power_bi_readonly;


--
-- TOC entry 8103 (class 0 OID 0)
-- Dependencies: 576
-- Name: TABLE "reviewItemComment"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewItemComment" TO challenges;
GRANT SELECT ON TABLE reviews."reviewItemComment" TO power_bi_readonly;


--
-- TOC entry 8104 (class 0 OID 0)
-- Dependencies: 581
-- Name: TABLE "reviewOpportunity"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewOpportunity" TO challenges;
GRANT SELECT ON TABLE reviews."reviewOpportunity" TO power_bi_readonly;


--
-- TOC entry 8105 (class 0 OID 0)
-- Dependencies: 584
-- Name: TABLE "reviewSummation"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewSummation" TO challenges;
GRANT SELECT ON TABLE reviews."reviewSummation" TO power_bi_readonly;


--
-- TOC entry 8106 (class 0 OID 0)
-- Dependencies: 583
-- Name: TABLE "reviewType"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."reviewType" TO challenges;
GRANT SELECT ON TABLE reviews."reviewType" TO power_bi_readonly;


--
-- TOC entry 8107 (class 0 OID 0)
-- Dependencies: 600
-- Name: TABLE review_pending_summary; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE reviews.review_pending_summary TO challenges;
GRANT SELECT ON TABLE reviews.review_pending_summary TO power_bi_readonly;


--
-- TOC entry 8108 (class 0 OID 0)
-- Dependencies: 570
-- Name: TABLE scorecard; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews.scorecard TO challenges;
GRANT SELECT ON TABLE reviews.scorecard TO power_bi_readonly;


--
-- TOC entry 8109 (class 0 OID 0)
-- Dependencies: 571
-- Name: TABLE "scorecardGroup"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."scorecardGroup" TO challenges;
GRANT SELECT ON TABLE reviews."scorecardGroup" TO power_bi_readonly;


--
-- TOC entry 8110 (class 0 OID 0)
-- Dependencies: 573
-- Name: TABLE "scorecardQuestion"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."scorecardQuestion" TO challenges;
GRANT SELECT ON TABLE reviews."scorecardQuestion" TO power_bi_readonly;


--
-- TOC entry 8111 (class 0 OID 0)
-- Dependencies: 572
-- Name: TABLE "scorecardSection"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."scorecardSection" TO challenges;
GRANT SELECT ON TABLE reviews."scorecardSection" TO power_bi_readonly;


--
-- TOC entry 8112 (class 0 OID 0)
-- Dependencies: 585
-- Name: TABLE submission; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews.submission TO challenges;
GRANT SELECT ON TABLE reviews.submission TO power_bi_readonly;


--
-- TOC entry 8113 (class 0 OID 0)
-- Dependencies: 596
-- Name: TABLE "submissionAccessAudit"; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews."submissionAccessAudit" TO challenges;
GRANT SELECT ON TABLE reviews."submissionAccessAudit" TO power_bi_readonly;


--
-- TOC entry 8114 (class 0 OID 0)
-- Dependencies: 586
-- Name: TABLE upload; Type: ACL; Schema: reviews; Owner: reviews
--

GRANT SELECT ON TABLE reviews.upload TO challenges;
GRANT SELECT ON TABLE reviews.upload TO power_bi_readonly;


--
-- TOC entry 8115 (class 0 OID 0)
-- Dependencies: 410
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."SequelizeMeta" TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."SequelizeMeta" TO member_skills;
GRANT SELECT ON TABLE skills."SequelizeMeta" TO power_bi_readonly;


--
-- TOC entry 8116 (class 0 OID 0)
-- Dependencies: 411
-- Name: TABLE event; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.event TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.event TO member_skills;
GRANT SELECT ON TABLE skills.event TO power_bi_readonly;


--
-- TOC entry 8117 (class 0 OID 0)
-- Dependencies: 412
-- Name: TABLE legacy_skill_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.legacy_skill_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.legacy_skill_map TO member_skills;
GRANT SELECT ON TABLE skills.legacy_skill_map TO power_bi_readonly;


--
-- TOC entry 8118 (class 0 OID 0)
-- Dependencies: 413
-- Name: TABLE prod_challenge_emsi_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_challenge_emsi_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_challenge_emsi_skills TO member_skills;
GRANT SELECT ON TABLE skills.prod_challenge_emsi_skills TO power_bi_readonly;


--
-- TOC entry 8119 (class 0 OID 0)
-- Dependencies: 414
-- Name: TABLE prod_job_emsi_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_job_emsi_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_job_emsi_skills TO member_skills;
GRANT SELECT ON TABLE skills.prod_job_emsi_skills TO power_bi_readonly;


--
-- TOC entry 8120 (class 0 OID 0)
-- Dependencies: 415
-- Name: TABLE prod_user_emsi_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_user_emsi_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_user_emsi_skills TO member_skills;
GRANT SELECT ON TABLE skills.prod_user_emsi_skills TO power_bi_readonly;


--
-- TOC entry 8121 (class 0 OID 0)
-- Dependencies: 416
-- Name: TABLE prod_v5_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_v5_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_v5_skills TO member_skills;
GRANT SELECT ON TABLE skills.prod_v5_skills TO power_bi_readonly;


--
-- TOC entry 8122 (class 0 OID 0)
-- Dependencies: 417
-- Name: TABLE skill; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill TO member_skills;
GRANT SELECT ON TABLE skills.skill TO power_bi_readonly;


--
-- TOC entry 8123 (class 0 OID 0)
-- Dependencies: 418
-- Name: TABLE skill_category; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_category TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_category TO member_skills;
GRANT SELECT ON TABLE skills.skill_category TO power_bi_readonly;


--
-- TOC entry 8124 (class 0 OID 0)
-- Dependencies: 419
-- Name: TABLE skill_event; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event TO member_skills;
GRANT SELECT ON TABLE skills.skill_event TO power_bi_readonly;


--
-- TOC entry 8125 (class 0 OID 0)
-- Dependencies: 420
-- Name: TABLE skill_event_type; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event_type TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event_type TO member_skills;
GRANT SELECT ON TABLE skills.skill_event_type TO power_bi_readonly;


--
-- TOC entry 8126 (class 0 OID 0)
-- Dependencies: 421
-- Name: TABLE skill_replacement; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_replacement TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_replacement TO member_skills;
GRANT SELECT ON TABLE skills.skill_replacement TO power_bi_readonly;


--
-- TOC entry 8127 (class 0 OID 0)
-- Dependencies: 422
-- Name: TABLE skill_to_emsi_skill_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_to_emsi_skill_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_to_emsi_skill_map TO member_skills;
GRANT SELECT ON TABLE skills.skill_to_emsi_skill_map TO power_bi_readonly;


--
-- TOC entry 8128 (class 0 OID 0)
-- Dependencies: 423
-- Name: TABLE source_type; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.source_type TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.source_type TO member_skills;
GRANT SELECT ON TABLE skills.source_type TO power_bi_readonly;


--
-- TOC entry 8129 (class 0 OID 0)
-- Dependencies: 424
-- Name: TABLE user_skill; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill TO member_skills;
GRANT SELECT ON TABLE skills.user_skill TO power_bi_readonly;


--
-- TOC entry 8130 (class 0 OID 0)
-- Dependencies: 425
-- Name: TABLE user_skill_display_mode; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_display_mode TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_display_mode TO member_skills;
GRANT SELECT ON TABLE skills.user_skill_display_mode TO power_bi_readonly;


--
-- TOC entry 8131 (class 0 OID 0)
-- Dependencies: 426
-- Name: TABLE user_skill_level; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_level TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_level TO member_skills;
GRANT SELECT ON TABLE skills.user_skill_level TO power_bi_readonly;


--
-- TOC entry 8132 (class 0 OID 0)
-- Dependencies: 427
-- Name: TABLE vw_all_skills_with_category; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_all_skills_with_category TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_all_skills_with_category TO member_skills;
GRANT SELECT ON TABLE skills.vw_all_skills_with_category TO power_bi_readonly;


--
-- TOC entry 8133 (class 0 OID 0)
-- Dependencies: 428
-- Name: TABLE vw_skill_to_emsi_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_skill_to_emsi_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_skill_to_emsi_map TO member_skills;
GRANT SELECT ON TABLE skills.vw_skill_to_emsi_map TO power_bi_readonly;


--
-- TOC entry 8134 (class 0 OID 0)
-- Dependencies: 429
-- Name: TABLE "vw_user_AI_skill_counts"; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."vw_user_AI_skill_counts" TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."vw_user_AI_skill_counts" TO member_skills;
GRANT SELECT ON TABLE skills."vw_user_AI_skill_counts" TO power_bi_readonly;


--
-- TOC entry 8135 (class 0 OID 0)
-- Dependencies: 430
-- Name: TABLE vw_v5_skill_to_std_skill_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_v5_skill_to_std_skill_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_v5_skill_to_std_skill_map TO member_skills;
GRANT SELECT ON TABLE skills.vw_v5_skill_to_std_skill_map TO power_bi_readonly;


--
-- TOC entry 8136 (class 0 OID 0)
-- Dependencies: 431
-- Name: TABLE work_skill; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.work_skill TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.work_skill TO member_skills;
GRANT SELECT ON TABLE skills.work_skill TO power_bi_readonly;


--
-- TOC entry 8137 (class 0 OID 0)
-- Dependencies: 409
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas."SequelizeMeta" TO taas;
GRANT SELECT ON TABLE taas."SequelizeMeta" TO power_bi_readonly;


--
-- TOC entry 8138 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE interviews; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.interviews TO taas;
GRANT SELECT ON TABLE taas.interviews TO power_bi_readonly;


--
-- TOC entry 8139 (class 0 OID 0)
-- Dependencies: 399
-- Name: TABLE job_candidates; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.job_candidates TO taas;
GRANT SELECT ON TABLE taas.job_candidates TO power_bi_readonly;


--
-- TOC entry 8140 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE jobs; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.jobs TO taas;
GRANT SELECT ON TABLE taas.jobs TO power_bi_readonly;


--
-- TOC entry 8141 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE legacy_skill_map; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.legacy_skill_map TO taas;
GRANT SELECT ON TABLE taas.legacy_skill_map TO power_bi_readonly;


--
-- TOC entry 8142 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE payment_schedulers; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.payment_schedulers TO taas;
GRANT SELECT ON TABLE taas.payment_schedulers TO power_bi_readonly;


--
-- TOC entry 8143 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE resource_bookings; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.resource_bookings TO taas;
GRANT SELECT ON TABLE taas.resource_bookings TO power_bi_readonly;


--
-- TOC entry 8144 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE role_search_requests; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.role_search_requests TO taas;
GRANT SELECT ON TABLE taas.role_search_requests TO power_bi_readonly;


--
-- TOC entry 8145 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE roles; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.roles TO taas;
GRANT SELECT ON TABLE taas.roles TO power_bi_readonly;


--
-- TOC entry 8146 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE user_meeting_settings; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.user_meeting_settings TO taas;
GRANT SELECT ON TABLE taas.user_meeting_settings TO power_bi_readonly;


--
-- TOC entry 8147 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE work_period_payments; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.work_period_payments TO taas;
GRANT SELECT ON TABLE taas.work_period_payments TO power_bi_readonly;


--
-- TOC entry 8148 (class 0 OID 0)
-- Dependencies: 408
-- Name: TABLE work_periods; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.work_periods TO taas;
GRANT SELECT ON TABLE taas.work_periods TO power_bi_readonly;


--
-- TOC entry 8149 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE "DocusignEnvelope"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."DocusignEnvelope" TO terms;
GRANT SELECT ON TABLE terms."DocusignEnvelope" TO power_bi_readonly;


--
-- TOC entry 8150 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE "TermsForResource"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsForResource" TO terms;
GRANT SELECT ON TABLE terms."TermsForResource" TO power_bi_readonly;


--
-- TOC entry 8151 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE "TermsOfUse"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUse" TO terms;
GRANT SELECT ON TABLE terms."TermsOfUse" TO power_bi_readonly;


--
-- TOC entry 8152 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE "TermsOfUseAgreeabilityType"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseAgreeabilityType" TO terms;
GRANT SELECT ON TABLE terms."TermsOfUseAgreeabilityType" TO power_bi_readonly;


--
-- TOC entry 8153 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE "TermsOfUseDependency"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseDependency" TO terms;
GRANT SELECT ON TABLE terms."TermsOfUseDependency" TO power_bi_readonly;


--
-- TOC entry 8154 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE "TermsOfUseDocusignTemplateXref"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseDocusignTemplateXref" TO terms;
GRANT SELECT ON TABLE terms."TermsOfUseDocusignTemplateXref" TO power_bi_readonly;


--
-- TOC entry 8155 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE "TermsOfUseType"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseType" TO terms;
GRANT SELECT ON TABLE terms."TermsOfUseType" TO power_bi_readonly;


--
-- TOC entry 8156 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE "UserTermsOfUseBanXref"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."UserTermsOfUseBanXref" TO terms;
GRANT SELECT ON TABLE terms."UserTermsOfUseBanXref" TO power_bi_readonly;


--
-- TOC entry 8157 (class 0 OID 0)
-- Dependencies: 381
-- Name: TABLE "UserTermsOfUseXref"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."UserTermsOfUseXref" TO terms;
GRANT SELECT ON TABLE terms."UserTermsOfUseXref" TO power_bi_readonly;


--
-- TOC entry 8158 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE events; Type: ACL; Schema: timeline; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE timeline.events TO timeline;
GRANT SELECT ON TABLE timeline.events TO power_bi_readonly;


--
-- TOC entry 8160 (class 0 OID 0)
-- Dependencies: 343
-- Name: SEQUENCE events_id_seq; Type: ACL; Schema: timeline; Owner: topcoder
--

GRANT ALL ON SEQUENCE timeline.events_id_seq TO timeline;


--
-- TOC entry 3527 (class 826 OID 2105784)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: academy; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA academy GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3528 (class 826 OID 2105785)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: autopilot; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA autopilot GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3529 (class 826 OID 2105786)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: billing-accounts; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA "billing-accounts" GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3530 (class 826 OID 2105787)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: challenges; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA challenges GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3531 (class 826 OID 2105788)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: emails; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA emails GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3532 (class 826 OID 2105789)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: finance; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA finance GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3533 (class 826 OID 2105790)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: gamification; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA gamification GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3534 (class 826 OID 2105791)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: groups; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA groups GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3535 (class 826 OID 2105792)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: identity; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA identity GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3536 (class 826 OID 2105793)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: lookups; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA lookups GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3537 (class 826 OID 2105794)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: members; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA members GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3538 (class 826 OID 2105795)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: messages; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA messages GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3539 (class 826 OID 2105796)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: notifications; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA notifications GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3540 (class 826 OID 2105797)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: projects; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA projects GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3541 (class 826 OID 2105798)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: resources; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA resources GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3542 (class 826 OID 2105799)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: reviews; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA reviews GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3543 (class 826 OID 2105800)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: skills; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA skills GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3544 (class 826 OID 2105801)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: taas; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA taas GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3545 (class 826 OID 2105802)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: terms; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA terms GRANT SELECT ON TABLES TO power_bi_readonly;


--
-- TOC entry 3546 (class 826 OID 2105803)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: timeline; Owner: topcoder
--

ALTER DEFAULT PRIVILEGES FOR ROLE topcoder IN SCHEMA timeline GRANT SELECT ON TABLES TO power_bi_readonly;


-- Completed on 2025-11-25 11:43:06 AEDT

--
-- PostgreSQL database dump complete
--

\unrestrict Aamsb0w6QlUnTHU724QaKOrqwzyz9pVhXQENKuxshNefvZ1e3SmtbIPHI8uc1NG

