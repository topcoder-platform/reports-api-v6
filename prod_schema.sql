--
-- PostgreSQL database dump
--

\restrict s16NovA9EFBc13dBHlnDEcS07mSi2bKZrbuVMRHyMVer1OegddV4BfKSOHzAqYR

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.6 (Ubuntu 17.6-0ubuntu0.25.04.1)

-- Started on 2025-10-27 07:51:06 AEDT

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
-- TOC entry 9 (class 2615 OID 1362914)
-- Name: academy; Type: SCHEMA; Schema: -; Owner: academy
--

CREATE SCHEMA academy;


ALTER SCHEMA academy OWNER TO academy;

--
-- TOC entry 27 (class 2615 OID 2030550)
-- Name: autopilot; Type: SCHEMA; Schema: -; Owner: autopilot
--

CREATE SCHEMA autopilot;


ALTER SCHEMA autopilot OWNER TO autopilot;

--
-- TOC entry 21 (class 2615 OID 1825263)
-- Name: billing-accounts; Type: SCHEMA; Schema: -; Owner: billingaccounts
--

CREATE SCHEMA "billing-accounts";


ALTER SCHEMA "billing-accounts" OWNER TO billingaccounts;

--
-- TOC entry 24 (class 2615 OID 2004827)
-- Name: challenges; Type: SCHEMA; Schema: -; Owner: challenges
--

CREATE SCHEMA challenges;


ALTER SCHEMA challenges OWNER TO challenges;

--
-- TOC entry 12 (class 2615 OID 1363874)
-- Name: emails; Type: SCHEMA; Schema: -; Owner: emails
--

CREATE SCHEMA emails;


ALTER SCHEMA emails OWNER TO emails;

--
-- TOC entry 7623 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA emails; Type: COMMENT; Schema: -; Owner: emails
--

COMMENT ON SCHEMA emails IS 'TC Email Service';


--
-- TOC entry 10 (class 2615 OID 1320061)
-- Name: finance; Type: SCHEMA; Schema: -; Owner: finance
--

CREATE SCHEMA finance;


ALTER SCHEMA finance OWNER TO finance;

--
-- TOC entry 13 (class 2615 OID 1347860)
-- Name: gamification; Type: SCHEMA; Schema: -; Owner: gamification
--

CREATE SCHEMA gamification;


ALTER SCHEMA gamification OWNER TO gamification;

--
-- TOC entry 19 (class 2615 OID 1825080)
-- Name: groups; Type: SCHEMA; Schema: -; Owner: groups
--

CREATE SCHEMA groups;


ALTER SCHEMA groups OWNER TO groups;

--
-- TOC entry 23 (class 2615 OID 1831862)
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
-- TOC entry 25 (class 2615 OID 2023503)
-- Name: members; Type: SCHEMA; Schema: -; Owner: members
--

CREATE SCHEMA members;


ALTER SCHEMA members OWNER TO members;

--
-- TOC entry 14 (class 2615 OID 1348134)
-- Name: messages; Type: SCHEMA; Schema: -; Owner: messages
--

CREATE SCHEMA messages;


ALTER SCHEMA messages OWNER TO messages;

--
-- TOC entry 16 (class 2615 OID 1436568)
-- Name: notifications; Type: SCHEMA; Schema: -; Owner: notifications
--

CREATE SCHEMA notifications;


ALTER SCHEMA notifications OWNER TO notifications;

--
-- TOC entry 7627 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA notifications; Type: COMMENT; Schema: -; Owner: notifications
--

COMMENT ON SCHEMA notifications IS 'TC Notifications Service';


--
-- TOC entry 18 (class 2615 OID 2200)
-- Name: projects; Type: SCHEMA; Schema: -; Owner: projects
--

CREATE SCHEMA projects;


ALTER SCHEMA projects OWNER TO projects;

--
-- TOC entry 7629 (class 0 OID 0)
-- Dependencies: 18
-- Name: SCHEMA projects; Type: COMMENT; Schema: -; Owner: projects
--

COMMENT ON SCHEMA projects IS 'TC Projects Service DB';


--
-- TOC entry 22 (class 2615 OID 1825030)
-- Name: resources; Type: SCHEMA; Schema: -; Owner: resources
--

CREATE SCHEMA resources;


ALTER SCHEMA resources OWNER TO resources;

--
-- TOC entry 28 (class 2615 OID 2033636)
-- Name: reviews; Type: SCHEMA; Schema: -; Owner: reviews
--

CREATE SCHEMA reviews;


ALTER SCHEMA reviews OWNER TO reviews;

--
-- TOC entry 26 (class 2615 OID 1476988)
-- Name: skills; Type: SCHEMA; Schema: -; Owner: skills
--

CREATE SCHEMA skills;


ALTER SCHEMA skills OWNER TO skills;

--
-- TOC entry 7632 (class 0 OID 0)
-- Dependencies: 26
-- Name: SCHEMA skills; Type: COMMENT; Schema: -; Owner: skills
--

COMMENT ON SCHEMA skills IS 'Standardized Skills Schema';


--
-- TOC entry 17 (class 2615 OID 1475405)
-- Name: taas; Type: SCHEMA; Schema: -; Owner: taas
--

CREATE SCHEMA taas;


ALTER SCHEMA taas OWNER TO taas;

--
-- TOC entry 7634 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA taas; Type: COMMENT; Schema: -; Owner: taas
--

COMMENT ON SCHEMA taas IS 'TaaS API';


--
-- TOC entry 11 (class 2615 OID 1363440)
-- Name: terms; Type: SCHEMA; Schema: -; Owner: terms
--

CREATE SCHEMA terms;


ALTER SCHEMA terms OWNER TO terms;

--
-- TOC entry 15 (class 2615 OID 1352749)
-- Name: timeline; Type: SCHEMA; Schema: -; Owner: timeline
--

CREATE SCHEMA timeline;


ALTER SCHEMA timeline OWNER TO timeline;

--
-- TOC entry 7635 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA timeline; Type: COMMENT; Schema: -; Owner: timeline
--

COMMENT ON SCHEMA timeline IS 'Timeline wall API';


--
-- TOC entry 1 (class 3079 OID 1476033)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA pg_catalog;


--
-- TOC entry 7637 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 3 (class 3079 OID 1323388)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA pg_catalog;


--
-- TOC entry 7638 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 5 (class 3079 OID 2033646)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA reviews;


--
-- TOC entry 7639 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 2 (class 3079 OID 1334256)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA pg_catalog;


--
-- TOC entry 7640 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1516 (class 1247 OID 1362922)
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
-- TOC entry 1519 (class 1247 OID 1362934)
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
-- TOC entry 1522 (class 1247 OID 1362944)
-- Name: FccCertificationType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."FccCertificationType" AS ENUM (
    'certification',
    'course-completion'
);


ALTER TYPE academy."FccCertificationType" OWNER TO topcoder;

--
-- TOC entry 1525 (class 1247 OID 1362950)
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
-- TOC entry 1528 (class 1247 OID 1362960)
-- Name: ResourceableType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."ResourceableType" AS ENUM (
    'FreeCodeCampCertification',
    'TopcoderUdemyCourse'
);


ALTER TYPE academy."ResourceableType" OWNER TO topcoder;

--
-- TOC entry 1531 (class 1247 OID 1362966)
-- Name: enum_CertificationEnrollment_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationEnrollment_status" AS ENUM (
    'enrolled',
    'disenrolled',
    'completed'
);


ALTER TYPE academy."enum_CertificationEnrollment_status" OWNER TO topcoder;

--
-- TOC entry 1534 (class 1247 OID 1362974)
-- Name: enum_CertificationEnrollments_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationEnrollments_status" AS ENUM (
    'enrolled',
    'disenrolled',
    'completed'
);


ALTER TYPE academy."enum_CertificationEnrollments_status" OWNER TO topcoder;

--
-- TOC entry 1537 (class 1247 OID 1362982)
-- Name: enum_CertificationResourceProgresses_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationResourceProgresses_status" AS ENUM (
    'not-started',
    'in-progress',
    'completed'
);


ALTER TYPE academy."enum_CertificationResourceProgresses_status" OWNER TO topcoder;

--
-- TOC entry 1540 (class 1247 OID 1362990)
-- Name: enum_CertificationResource_resourceableType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_CertificationResource_resourceableType" AS ENUM (
    'FreeCodeCampCertification',
    'TopcoderUdemyCourse'
);


ALTER TYPE academy."enum_CertificationResource_resourceableType" OWNER TO topcoder;

--
-- TOC entry 1543 (class 1247 OID 1362996)
-- Name: enum_FccCertificationProgresses_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccCertificationProgresses_status" AS ENUM (
    'in-progress',
    'completed',
    'not-started'
);


ALTER TYPE academy."enum_FccCertificationProgresses_status" OWNER TO topcoder;

--
-- TOC entry 1546 (class 1247 OID 1363004)
-- Name: enum_FccCourseProgresses_status; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccCourseProgresses_status" AS ENUM (
    'in-progress',
    'completed'
);


ALTER TYPE academy."enum_FccCourseProgresses_status" OWNER TO topcoder;

--
-- TOC entry 1549 (class 1247 OID 1363010)
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
-- TOC entry 1552 (class 1247 OID 1363020)
-- Name: enum_FccModuleProgresses_moduleStatus; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FccModuleProgresses_moduleStatus" AS ENUM (
    'not-started',
    'in-progress',
    'completed'
);


ALTER TYPE academy."enum_FccModuleProgresses_moduleStatus" OWNER TO topcoder;

--
-- TOC entry 1555 (class 1247 OID 1363028)
-- Name: enum_FreeCodeCampCertification_certType; Type: TYPE; Schema: academy; Owner: topcoder
--

CREATE TYPE academy."enum_FreeCodeCampCertification_certType" AS ENUM (
    'certification',
    'course-completion'
);


ALTER TYPE academy."enum_FreeCodeCampCertification_certType" OWNER TO topcoder;

--
-- TOC entry 1558 (class 1247 OID 1363034)
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
-- TOC entry 1561 (class 1247 OID 1363044)
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
-- TOC entry 1564 (class 1247 OID 1363056)
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
-- TOC entry 1567 (class 1247 OID 1363066)
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
-- TOC entry 1570 (class 1247 OID 1363076)
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
-- TOC entry 1573 (class 1247 OID 1363086)
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
-- TOC entry 1747 (class 1247 OID 1825420)
-- Name: BAStatus; Type: TYPE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TYPE "billing-accounts"."BAStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE "billing-accounts"."BAStatus" OWNER TO billingaccounts;

--
-- TOC entry 1744 (class 1247 OID 1825415)
-- Name: ClientStatus; Type: TYPE; Schema: billing-accounts; Owner: billingaccounts
--

CREATE TYPE "billing-accounts"."ClientStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE "billing-accounts"."ClientStatus" OWNER TO billingaccounts;

--
-- TOC entry 1924 (class 1247 OID 2004858)
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
-- TOC entry 2008 (class 1247 OID 2005316)
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
-- TOC entry 1921 (class 1247 OID 2004854)
-- Name: DiscussionTypeEnum; Type: TYPE; Schema: challenges; Owner: challenges
--

CREATE TYPE challenges."DiscussionTypeEnum" AS ENUM (
    'CHALLENGE'
);


ALTER TYPE challenges."DiscussionTypeEnum" OWNER TO challenges;

--
-- TOC entry 1927 (class 1247 OID 2004890)
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
-- TOC entry 2002 (class 1247 OID 2005282)
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
-- TOC entry 1918 (class 1247 OID 2004848)
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
-- TOC entry 1390 (class 1247 OID 1334282)
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
-- TOC entry 1393 (class 1247 OID 1334304)
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
-- TOC entry 1396 (class 1247 OID 1334314)
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
-- TOC entry 1399 (class 1247 OID 1334328)
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
-- TOC entry 1456 (class 1247 OID 1334766)
-- Name: tax_form_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.tax_form_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE finance.tax_form_status OWNER TO finance;

--
-- TOC entry 1402 (class 1247 OID 1334354)
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
-- TOC entry 1735 (class 1247 OID 1771164)
-- Name: verification_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.verification_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE finance.verification_status OWNER TO finance;

--
-- TOC entry 1447 (class 1247 OID 1334733)
-- Name: webhook_status; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.webhook_status AS ENUM (
    'error',
    'processed',
    'logged'
);


ALTER TYPE finance.webhook_status OWNER TO finance;

--
-- TOC entry 1405 (class 1247 OID 1334366)
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
-- TOC entry 1408 (class 1247 OID 1334512)
-- Name: winnings_type; Type: TYPE; Schema: finance; Owner: finance
--

CREATE TYPE finance.winnings_type AS ENUM (
    'PAYMENT',
    'REWARD'
);


ALTER TYPE finance.winnings_type OWNER TO finance;

--
-- TOC entry 2026 (class 1247 OID 2018819)
-- Name: GroupStatus; Type: TYPE; Schema: groups; Owner: groups
--

CREATE TYPE groups."GroupStatus" AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE groups."GroupStatus" OWNER TO groups;

--
-- TOC entry 2050 (class 1247 OID 2023538)
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
-- TOC entry 2047 (class 1247 OID 2023528)
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
-- TOC entry 2044 (class 1247 OID 2023514)
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
-- TOC entry 2056 (class 1247 OID 2023564)
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
-- TOC entry 2053 (class 1247 OID 2023552)
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
-- TOC entry 2059 (class 1247 OID 2023576)
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
-- TOC entry 1660 (class 1247 OID 1436579)
-- Name: enum_ScheduledEvents_status; Type: TYPE; Schema: notifications; Owner: topcoder
--

CREATE TYPE notifications."enum_ScheduledEvents_status" AS ENUM (
    'pending',
    'completed',
    'failed'
);


ALTER TYPE notifications."enum_ScheduledEvents_status" OWNER TO topcoder;

--
-- TOC entry 1274 (class 1247 OID 1323824)
-- Name: enum_project_phase_approval_decision; Type: TYPE; Schema: projects; Owner: topcoder
--

CREATE TYPE projects.enum_project_phase_approval_decision AS ENUM (
    'approve',
    'reject'
);


ALTER TYPE projects.enum_project_phase_approval_decision OWNER TO topcoder;

--
-- TOC entry 2194 (class 1247 OID 2033716)
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
-- TOC entry 2197 (class 1247 OID 2033726)
-- Name: QuestionType; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."QuestionType" AS ENUM (
    'SCALE',
    'YES_NO',
    'TEST_CASE'
);


ALTER TYPE reviews."QuestionType" OWNER TO reviews;

--
-- TOC entry 2242 (class 1247 OID 2033966)
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
-- TOC entry 2236 (class 1247 OID 2033944)
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
-- TOC entry 2200 (class 1247 OID 2033732)
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
-- TOC entry 2233 (class 1247 OID 2033936)
-- Name: ReviewOpportunityStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ReviewOpportunityStatus" AS ENUM (
    'OPEN',
    'CLOSED',
    'CANCELLED'
);


ALTER TYPE reviews."ReviewOpportunityStatus" OWNER TO reviews;

--
-- TOC entry 2239 (class 1247 OID 2033954)
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
-- TOC entry 2299 (class 1247 OID 2034313)
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
-- TOC entry 2188 (class 1247 OID 2033691)
-- Name: ScorecardStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."ScorecardStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'DELETED'
);


ALTER TYPE reviews."ScorecardStatus" OWNER TO reviews;

--
-- TOC entry 2191 (class 1247 OID 2033698)
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
-- TOC entry 2269 (class 1247 OID 2034096)
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
-- TOC entry 2266 (class 1247 OID 2034086)
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
-- TOC entry 2263 (class 1247 OID 2034080)
-- Name: UploadStatus; Type: TYPE; Schema: reviews; Owner: reviews
--

CREATE TYPE reviews."UploadStatus" AS ENUM (
    'ACTIVE',
    'DELETED'
);


ALTER TYPE reviews."UploadStatus" OWNER TO reviews;

--
-- TOC entry 2260 (class 1247 OID 2034071)
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
-- TOC entry 1687 (class 1247 OID 1475408)
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
-- TOC entry 1690 (class 1247 OID 1475424)
-- Name: enum_payment_schedulers_status; Type: TYPE; Schema: taas; Owner: topcoder
--

CREATE TYPE taas.enum_payment_schedulers_status AS ENUM (
    'in-progress',
    'completed',
    'failed'
);


ALTER TYPE taas.enum_payment_schedulers_status OWNER TO topcoder;

--
-- TOC entry 1693 (class 1247 OID 1475432)
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
-- TOC entry 1696 (class 1247 OID 1475446)
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
-- TOC entry 1510 (class 1247 OID 1352752)
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
-- TOC entry 655 (class 1255 OID 2033683)
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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 347 (class 1259 OID 1363095)
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
-- TOC entry 348 (class 1259 OID 1363100)
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
-- TOC entry 7642 (class 0 OID 0)
-- Dependencies: 348
-- Name: CertificationCategory_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationCategory_id_seq" OWNED BY academy."CertificationCategory".id;


--
-- TOC entry 349 (class 1259 OID 1363101)
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
-- TOC entry 350 (class 1259 OID 1363107)
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
-- TOC entry 7645 (class 0 OID 0)
-- Dependencies: 350
-- Name: CertificationEnrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationEnrollments_id_seq" OWNED BY academy."CertificationEnrollments".id;


--
-- TOC entry 351 (class 1259 OID 1363108)
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
-- TOC entry 352 (class 1259 OID 1363113)
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
-- TOC entry 353 (class 1259 OID 1363117)
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
-- TOC entry 7649 (class 0 OID 0)
-- Dependencies: 353
-- Name: CertificationResourceProgresses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationResourceProgresses_id_seq" OWNED BY academy."CertificationResourceProgresses".id;


--
-- TOC entry 354 (class 1259 OID 1363118)
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
-- TOC entry 7651 (class 0 OID 0)
-- Dependencies: 354
-- Name: CertificationResource_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."CertificationResource_id_seq" OWNED BY academy."CertificationResource".id;


--
-- TOC entry 355 (class 1259 OID 1363119)
-- Name: DataVersion; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."DataVersion" (
    version timestamp(3) without time zone NOT NULL
);


ALTER TABLE academy."DataVersion" OWNER TO topcoder;

--
-- TOC entry 356 (class 1259 OID 1363122)
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
-- TOC entry 357 (class 1259 OID 1363127)
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
-- TOC entry 7655 (class 0 OID 0)
-- Dependencies: 357
-- Name: FccCertificationProgresses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccCertificationProgresses_id_seq" OWNED BY academy."FccCertificationProgresses".id;


--
-- TOC entry 358 (class 1259 OID 1363128)
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
-- TOC entry 359 (class 1259 OID 1363133)
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
-- TOC entry 360 (class 1259 OID 1363139)
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
-- TOC entry 7659 (class 0 OID 0)
-- Dependencies: 360
-- Name: FccCourses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccCourses_id_seq" OWNED BY academy."FccCourses".id;


--
-- TOC entry 361 (class 1259 OID 1363140)
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
-- TOC entry 362 (class 1259 OID 1363146)
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
-- TOC entry 363 (class 1259 OID 1363150)
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
-- TOC entry 7663 (class 0 OID 0)
-- Dependencies: 363
-- Name: FccModuleProgresses_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccModuleProgresses_id_seq" OWNED BY academy."FccModuleProgresses".id;


--
-- TOC entry 364 (class 1259 OID 1363151)
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
-- TOC entry 365 (class 1259 OID 1363157)
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
-- TOC entry 7666 (class 0 OID 0)
-- Dependencies: 365
-- Name: FccModules_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FccModules_id_seq" OWNED BY academy."FccModules".id;


--
-- TOC entry 366 (class 1259 OID 1363158)
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
-- TOC entry 367 (class 1259 OID 1363166)
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
-- TOC entry 7669 (class 0 OID 0)
-- Dependencies: 367
-- Name: FreeCodeCampCertification_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."FreeCodeCampCertification_id_seq" OWNED BY academy."FreeCodeCampCertification".id;


--
-- TOC entry 368 (class 1259 OID 1363167)
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
-- TOC entry 369 (class 1259 OID 1363172)
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
-- TOC entry 7672 (class 0 OID 0)
-- Dependencies: 369
-- Name: ResourceProvider_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."ResourceProvider_id_seq" OWNED BY academy."ResourceProvider".id;


--
-- TOC entry 370 (class 1259 OID 1363173)
-- Name: SequelizeMeta; Type: TABLE; Schema: academy; Owner: topcoder
--

CREATE TABLE academy."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE academy."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 371 (class 1259 OID 1363176)
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
-- TOC entry 372 (class 1259 OID 1363183)
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
-- TOC entry 7676 (class 0 OID 0)
-- Dependencies: 372
-- Name: TopcoderCertification_id_seq; Type: SEQUENCE OWNED BY; Schema: academy; Owner: topcoder
--

ALTER SEQUENCE academy."TopcoderCertification_id_seq" OWNED BY academy."TopcoderCertification".id;


--
-- TOC entry 373 (class 1259 OID 1363184)
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
-- TOC entry 374 (class 1259 OID 1363190)
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
-- TOC entry 375 (class 1259 OID 1363195)
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
-- TOC entry 438 (class 1259 OID 1825434)
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
-- TOC entry 441 (class 1259 OID 1825461)
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
-- TOC entry 442 (class 1259 OID 1825503)
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
-- TOC entry 7681 (class 0 OID 0)
-- Dependencies: 442
-- Name: BillingAccount_id_seq; Type: SEQUENCE OWNED BY; Schema: billing-accounts; Owner: billingaccounts
--

ALTER SEQUENCE "billing-accounts"."BillingAccount_id_seq" OWNED BY "billing-accounts"."BillingAccount".id;


--
-- TOC entry 437 (class 1259 OID 1825425)
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
-- TOC entry 440 (class 1259 OID 1825453)
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
-- TOC entry 439 (class 1259 OID 1825445)
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
-- TOC entry 436 (class 1259 OID 1825405)
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
-- TOC entry 486 (class 1259 OID 2004945)
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
-- TOC entry 485 (class 1259 OID 2004937)
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
-- TOC entry 481 (class 1259 OID 2004899)
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
-- TOC entry 492 (class 1259 OID 2004993)
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
-- TOC entry 497 (class 1259 OID 2005040)
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
-- TOC entry 495 (class 1259 OID 2005024)
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
-- TOC entry 496 (class 1259 OID 2005032)
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
-- TOC entry 494 (class 1259 OID 2005016)
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
-- TOC entry 493 (class 1259 OID 2005001)
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
-- TOC entry 487 (class 1259 OID 2004953)
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
-- TOC entry 499 (class 1259 OID 2005057)
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
-- TOC entry 500 (class 1259 OID 2005066)
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
-- TOC entry 501 (class 1259 OID 2005074)
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
-- TOC entry 504 (class 1259 OID 2005251)
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
-- TOC entry 491 (class 1259 OID 2004985)
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
-- TOC entry 490 (class 1259 OID 2004977)
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
-- TOC entry 484 (class 1259 OID 2004928)
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
-- TOC entry 483 (class 1259 OID 2004920)
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
-- TOC entry 482 (class 1259 OID 2004910)
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
-- TOC entry 489 (class 1259 OID 2004969)
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
-- TOC entry 505 (class 1259 OID 2005293)
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
    "isAIReviewer" boolean NOT NULL,
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
-- TOC entry 498 (class 1259 OID 2005049)
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
-- TOC entry 488 (class 1259 OID 2004961)
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
-- TOC entry 502 (class 1259 OID 2005082)
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
-- TOC entry 503 (class 1259 OID 2005091)
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
-- TOC entry 480 (class 1259 OID 2004828)
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
-- TOC entry 385 (class 1259 OID 1363875)
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
-- TOC entry 386 (class 1259 OID 1363880)
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
-- TOC entry 7683 (class 0 OID 0)
-- Dependencies: 386
-- Name: Emails_id_seq; Type: SEQUENCE OWNED BY; Schema: emails; Owner: topcoder
--

ALTER SEQUENCE emails."Emails_id_seq" OWNED BY emails."Emails".id;


--
-- TOC entry 304 (class 1259 OID 1334272)
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
-- TOC entry 305 (class 1259 OID 1334517)
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
-- TOC entry 307 (class 1259 OID 1334533)
-- Name: origin; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.origin (
    origin_id integer NOT NULL,
    origin_name character varying(255) NOT NULL
);


ALTER TABLE finance.origin OWNER TO finance;

--
-- TOC entry 306 (class 1259 OID 1334532)
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
-- TOC entry 7685 (class 0 OID 0)
-- Dependencies: 306
-- Name: origin_origin_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.origin_origin_id_seq OWNED BY finance.origin.origin_id;


--
-- TOC entry 308 (class 1259 OID 1334539)
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
-- TOC entry 309 (class 1259 OID 1334550)
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
-- TOC entry 311 (class 1259 OID 1334563)
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
-- TOC entry 310 (class 1259 OID 1334562)
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
-- TOC entry 7686 (class 0 OID 0)
-- Dependencies: 310
-- Name: payment_method_payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.payment_method_payment_method_id_seq OWNED BY finance.payment_method.payment_method_id;


--
-- TOC entry 312 (class 1259 OID 1334571)
-- Name: payment_release_associations; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.payment_release_associations (
    payment_release_id uuid NOT NULL,
    payment_id uuid NOT NULL
);


ALTER TABLE finance.payment_release_associations OWNER TO finance;

--
-- TOC entry 313 (class 1259 OID 1334576)
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
-- TOC entry 315 (class 1259 OID 1334588)
-- Name: payoneer_payment_method; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.payoneer_payment_method (
    id integer NOT NULL,
    user_payment_method_id uuid,
    user_id character varying(80) NOT NULL,
    payee_id character varying(50) NOT NULL,
    payoneer_id character varying(50)
);


ALTER TABLE finance.payoneer_payment_method OWNER TO finance;

--
-- TOC entry 314 (class 1259 OID 1334587)
-- Name: payoneer_payment_method_id_seq; Type: SEQUENCE; Schema: finance; Owner: finance
--

CREATE SEQUENCE finance.payoneer_payment_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.payoneer_payment_method_id_seq OWNER TO finance;

--
-- TOC entry 7687 (class 0 OID 0)
-- Dependencies: 314
-- Name: payoneer_payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.payoneer_payment_method_id_seq OWNED BY finance.payoneer_payment_method.id;


--
-- TOC entry 317 (class 1259 OID 1334595)
-- Name: paypal_payment_method; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.paypal_payment_method (
    id integer NOT NULL,
    user_payment_method_id uuid,
    user_id character varying(80) NOT NULL,
    email character varying(150),
    payer_id character varying(50),
    country_code character varying(2)
);


ALTER TABLE finance.paypal_payment_method OWNER TO finance;

--
-- TOC entry 316 (class 1259 OID 1334594)
-- Name: paypal_payment_method_id_seq; Type: SEQUENCE; Schema: finance; Owner: finance
--

CREATE SEQUENCE finance.paypal_payment_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.paypal_payment_method_id_seq OWNER TO finance;

--
-- TOC entry 7688 (class 0 OID 0)
-- Dependencies: 316
-- Name: paypal_payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.paypal_payment_method_id_seq OWNED BY finance.paypal_payment_method.id;


--
-- TOC entry 318 (class 1259 OID 1334601)
-- Name: reward; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.reward (
    reward_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    winnings_id uuid NOT NULL,
    points integer,
    title character varying(255),
    description text,
    reference jsonb,
    attributes jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finance.reward OWNER TO finance;

--
-- TOC entry 323 (class 1259 OID 1334752)
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
-- TOC entry 322 (class 1259 OID 1334751)
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
-- TOC entry 7689 (class 0 OID 0)
-- Dependencies: 322
-- Name: trolley_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: finance
--

ALTER SEQUENCE finance.trolley_recipient_id_seq OWNED BY finance.trolley_recipient.id;


--
-- TOC entry 325 (class 1259 OID 1334779)
-- Name: trolley_recipient_payment_method; Type: TABLE; Schema: finance; Owner: finance
--

CREATE TABLE finance.trolley_recipient_payment_method (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    trolley_recipient_id integer NOT NULL,
    recipient_account_id character varying(80) NOT NULL
);


ALTER TABLE finance.trolley_recipient_payment_method OWNER TO finance;

--
-- TOC entry 321 (class 1259 OID 1334739)
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
-- TOC entry 435 (class 1259 OID 1771169)
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
-- TOC entry 319 (class 1259 OID 1334633)
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
-- TOC entry 324 (class 1259 OID 1334771)
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
-- TOC entry 320 (class 1259 OID 1334648)
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
-- TOC entry 326 (class 1259 OID 1347861)
-- Name: SequelizeMeta; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE gamification."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 327 (class 1259 OID 1347864)
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
-- TOC entry 328 (class 1259 OID 1347869)
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
-- TOC entry 329 (class 1259 OID 1347874)
-- Name: organization; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization (
    id uuid NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE gamification.organization OWNER TO topcoder;

--
-- TOC entry 330 (class 1259 OID 1347879)
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
-- TOC entry 331 (class 1259 OID 1347885)
-- Name: organization_badges_custom_fields; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization_badges_custom_fields (
    custom_field_id uuid NOT NULL,
    badges_id uuid NOT NULL
);


ALTER TABLE gamification.organization_badges_custom_fields OWNER TO topcoder;

--
-- TOC entry 332 (class 1259 OID 1347888)
-- Name: organization_badges_tags; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.organization_badges_tags (
    tags_id uuid NOT NULL,
    organization_badges_id uuid NOT NULL
);


ALTER TABLE gamification.organization_badges_tags OWNER TO topcoder;

--
-- TOC entry 333 (class 1259 OID 1347891)
-- Name: tags; Type: TABLE; Schema: gamification; Owner: topcoder
--

CREATE TABLE gamification.tags (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    tag_value text NOT NULL
);


ALTER TABLE gamification.tags OWNER TO topcoder;

--
-- TOC entry 511 (class 1259 OID 2018823)
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
-- TOC entry 512 (class 1259 OID 2018831)
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
-- TOC entry 513 (class 1259 OID 2018839)
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
-- TOC entry 514 (class 1259 OID 2018847)
-- Name: _ParentSubGroups; Type: TABLE; Schema: groups; Owner: groups
--

CREATE TABLE groups."_ParentSubGroups" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE groups."_ParentSubGroups" OWNER TO groups;

--
-- TOC entry 510 (class 1259 OID 2018809)
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
-- TOC entry 443 (class 1259 OID 1831866)
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
-- TOC entry 446 (class 1259 OID 1831877)
-- Name: achievement_type_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.achievement_type_lu (
    achievement_type_id numeric(5,0) NOT NULL,
    achievement_type_desc character varying(64) NOT NULL
);


ALTER TABLE identity.achievement_type_lu OWNER TO identity;

--
-- TOC entry 474 (class 1259 OID 1832034)
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
-- TOC entry 473 (class 1259 OID 1832033)
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
-- TOC entry 7698 (class 0 OID 0)
-- Dependencies: 473
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.client_id_seq OWNED BY identity.client.id;


--
-- TOC entry 447 (class 1259 OID 1831882)
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
-- TOC entry 449 (class 1259 OID 1831889)
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
-- TOC entry 448 (class 1259 OID 1831888)
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
-- TOC entry 7699 (class 0 OID 0)
-- Dependencies: 448
-- Name: dice_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.dice_connection_id_seq OWNED BY identity.dice_connection.id;


--
-- TOC entry 444 (class 1259 OID 1831875)
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
-- TOC entry 450 (class 1259 OID 1831897)
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
-- TOC entry 451 (class 1259 OID 1831905)
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
-- TOC entry 452 (class 1259 OID 1831912)
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
-- TOC entry 453 (class 1259 OID 1831919)
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
-- TOC entry 454 (class 1259 OID 1831925)
-- Name: invalid_handles; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.invalid_handles (
    invalid_handle_id integer NOT NULL,
    invalid_handle character varying(20) NOT NULL
);


ALTER TABLE identity.invalid_handles OWNER TO identity;

--
-- TOC entry 476 (class 1259 OID 1832043)
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
-- TOC entry 478 (class 1259 OID 1832050)
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
-- TOC entry 477 (class 1259 OID 1832049)
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
-- TOC entry 7700 (class 0 OID 0)
-- Dependencies: 477
-- Name: role_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.role_assignment_id_seq OWNED BY identity.role_assignment.id;


--
-- TOC entry 475 (class 1259 OID 1832042)
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
-- TOC entry 7701 (class 0 OID 0)
-- Dependencies: 475
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.role_id_seq OWNED BY identity.role.id;


--
-- TOC entry 455 (class 1259 OID 1831930)
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
-- TOC entry 456 (class 1259 OID 1831936)
-- Name: security_status_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.security_status_lu (
    security_status_id numeric(3,0) NOT NULL,
    status_desc character varying(200)
);


ALTER TABLE identity.security_status_lu OWNER TO identity;

--
-- TOC entry 457 (class 1259 OID 1831941)
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
-- TOC entry 479 (class 1259 OID 1832187)
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
-- TOC entry 445 (class 1259 OID 1831876)
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
-- TOC entry 458 (class 1259 OID 1831946)
-- Name: social_login_provider; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.social_login_provider (
    social_login_provider_id numeric(10,0) NOT NULL,
    name character varying(50)
);


ALTER TABLE identity.social_login_provider OWNER TO identity;

--
-- TOC entry 459 (class 1259 OID 1831951)
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
-- TOC entry 460 (class 1259 OID 1831958)
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
-- TOC entry 462 (class 1259 OID 1831969)
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
-- TOC entry 461 (class 1259 OID 1831968)
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
-- TOC entry 7702 (class 0 OID 0)
-- Dependencies: 461
-- Name: user_2fa_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.user_2fa_id_seq OWNED BY identity.user_2fa.id;


--
-- TOC entry 463 (class 1259 OID 1831979)
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
-- TOC entry 472 (class 1259 OID 1832026)
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
-- TOC entry 464 (class 1259 OID 1831985)
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
-- TOC entry 466 (class 1259 OID 1831992)
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
-- TOC entry 465 (class 1259 OID 1831991)
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
-- TOC entry 7703 (class 0 OID 0)
-- Dependencies: 465
-- Name: user_otp_email_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: identity
--

ALTER SEQUENCE identity.user_otp_email_id_seq OWNED BY identity.user_otp_email.id;


--
-- TOC entry 467 (class 1259 OID 1832000)
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
-- TOC entry 468 (class 1259 OID 1832006)
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
-- TOC entry 469 (class 1259 OID 1832011)
-- Name: user_status; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_status (
    user_id numeric(10,0) NOT NULL,
    user_status_type_id numeric(3,0) NOT NULL,
    user_status_id numeric(5,0)
);


ALTER TABLE identity.user_status OWNER TO identity;

--
-- TOC entry 470 (class 1259 OID 1832016)
-- Name: user_status_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_status_lu (
    user_status_id numeric(5,0) NOT NULL,
    description character varying(100)
);


ALTER TABLE identity.user_status_lu OWNER TO identity;

--
-- TOC entry 471 (class 1259 OID 1832021)
-- Name: user_status_type_lu; Type: TABLE; Schema: identity; Owner: identity
--

CREATE TABLE identity.user_status_type_lu (
    user_status_type_id numeric(3,0) NOT NULL,
    description character varying(100)
);


ALTER TABLE identity.user_status_type_lu OWNER TO identity;

--
-- TOC entry 581 (class 1259 OID 2029892)
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
-- TOC entry 582 (class 1259 OID 2029901)
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
-- TOC entry 583 (class 1259 OID 2029910)
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
-- TOC entry 580 (class 1259 OID 2029883)
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
-- TOC entry 515 (class 1259 OID 2023504)
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
-- TOC entry 576 (class 1259 OID 2023911)
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
-- TOC entry 522 (class 1259 OID 2023626)
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
-- TOC entry 521 (class 1259 OID 2023625)
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
-- TOC entry 7704 (class 0 OID 0)
-- Dependencies: 521
-- Name: distributionStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."distributionStats_id_seq" OWNED BY members."distributionStats".id;


--
-- TOC entry 516 (class 1259 OID 2023597)
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
-- TOC entry 518 (class 1259 OID 2023606)
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
-- TOC entry 517 (class 1259 OID 2023605)
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
-- TOC entry 7705 (class 0 OID 0)
-- Dependencies: 517
-- Name: memberAddress_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberAddress_id_seq" OWNED BY members."memberAddress".id;


--
-- TOC entry 533 (class 1259 OID 2023686)
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
-- TOC entry 532 (class 1259 OID 2023685)
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
-- TOC entry 7706 (class 0 OID 0)
-- Dependencies: 532
-- Name: memberCopilotStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberCopilotStats_id_seq" OWNED BY members."memberCopilotStats".id;


--
-- TOC entry 529 (class 1259 OID 2023665)
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
-- TOC entry 528 (class 1259 OID 2023664)
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
-- TOC entry 7707 (class 0 OID 0)
-- Dependencies: 528
-- Name: memberDataScienceHistoryStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDataScienceHistoryStats_id_seq" OWNED BY members."memberDataScienceHistoryStats".id;


--
-- TOC entry 543 (class 1259 OID 2023736)
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
-- TOC entry 542 (class 1259 OID 2023735)
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
-- TOC entry 7708 (class 0 OID 0)
-- Dependencies: 542
-- Name: memberDataScienceStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDataScienceStats_id_seq" OWNED BY members."memberDataScienceStats".id;


--
-- TOC entry 539 (class 1259 OID 2023716)
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
-- TOC entry 541 (class 1259 OID 2023726)
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
-- TOC entry 540 (class 1259 OID 2023725)
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
-- TOC entry 7709 (class 0 OID 0)
-- Dependencies: 540
-- Name: memberDesignStatsItem_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDesignStatsItem_id_seq" OWNED BY members."memberDesignStatsItem".id;


--
-- TOC entry 538 (class 1259 OID 2023715)
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
-- TOC entry 7710 (class 0 OID 0)
-- Dependencies: 538
-- Name: memberDesignStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDesignStats_id_seq" OWNED BY members."memberDesignStats".id;


--
-- TOC entry 527 (class 1259 OID 2023655)
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
-- TOC entry 526 (class 1259 OID 2023654)
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
-- TOC entry 7711 (class 0 OID 0)
-- Dependencies: 526
-- Name: memberDevelopHistoryStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDevelopHistoryStats_id_seq" OWNED BY members."memberDevelopHistoryStats".id;


--
-- TOC entry 535 (class 1259 OID 2023696)
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
-- TOC entry 537 (class 1259 OID 2023706)
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
-- TOC entry 536 (class 1259 OID 2023705)
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
-- TOC entry 7712 (class 0 OID 0)
-- Dependencies: 536
-- Name: memberDevelopStatsItem_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDevelopStatsItem_id_seq" OWNED BY members."memberDevelopStatsItem".id;


--
-- TOC entry 534 (class 1259 OID 2023695)
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
-- TOC entry 7713 (class 0 OID 0)
-- Dependencies: 534
-- Name: memberDevelopStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberDevelopStats_id_seq" OWNED BY members."memberDevelopStats".id;


--
-- TOC entry 523 (class 1259 OID 2023635)
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
-- TOC entry 525 (class 1259 OID 2023644)
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
-- TOC entry 524 (class 1259 OID 2023643)
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
-- TOC entry 7714 (class 0 OID 0)
-- Dependencies: 524
-- Name: memberHistoryStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberHistoryStats_id_seq" OWNED BY members."memberHistoryStats".id;


--
-- TOC entry 551 (class 1259 OID 2023776)
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
-- TOC entry 550 (class 1259 OID 2023775)
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
-- TOC entry 7715 (class 0 OID 0)
-- Dependencies: 550
-- Name: memberMarathonStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberMarathonStats_id_seq" OWNED BY members."memberMarathonStats".id;


--
-- TOC entry 520 (class 1259 OID 2023616)
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
-- TOC entry 519 (class 1259 OID 2023615)
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
-- TOC entry 7716 (class 0 OID 0)
-- Dependencies: 519
-- Name: memberMaxRating_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberMaxRating_id_seq" OWNED BY members."memberMaxRating".id;


--
-- TOC entry 578 (class 1259 OID 2023927)
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
-- TOC entry 579 (class 1259 OID 2023935)
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
-- TOC entry 547 (class 1259 OID 2023756)
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
-- TOC entry 546 (class 1259 OID 2023755)
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
-- TOC entry 7717 (class 0 OID 0)
-- Dependencies: 546
-- Name: memberSrmChallengeDetail_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberSrmChallengeDetail_id_seq" OWNED BY members."memberSrmChallengeDetail".id;


--
-- TOC entry 549 (class 1259 OID 2023766)
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
-- TOC entry 548 (class 1259 OID 2023765)
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
-- TOC entry 7718 (class 0 OID 0)
-- Dependencies: 548
-- Name: memberSrmDivisionDetail_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberSrmDivisionDetail_id_seq" OWNED BY members."memberSrmDivisionDetail".id;


--
-- TOC entry 545 (class 1259 OID 2023746)
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
-- TOC entry 544 (class 1259 OID 2023745)
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
-- TOC entry 7719 (class 0 OID 0)
-- Dependencies: 544
-- Name: memberSrmStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberSrmStats_id_seq" OWNED BY members."memberSrmStats".id;


--
-- TOC entry 531 (class 1259 OID 2023675)
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
-- TOC entry 530 (class 1259 OID 2023674)
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
-- TOC entry 7720 (class 0 OID 0)
-- Dependencies: 530
-- Name: memberStats_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberStats_id_seq" OWNED BY members."memberStats".id;


--
-- TOC entry 565 (class 1259 OID 2023846)
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
-- TOC entry 564 (class 1259 OID 2023845)
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
-- TOC entry 7721 (class 0 OID 0)
-- Dependencies: 564
-- Name: memberTraitBasicInfo_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitBasicInfo_id_seq" OWNED BY members."memberTraitBasicInfo".id;


--
-- TOC entry 573 (class 1259 OID 2023886)
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
-- TOC entry 572 (class 1259 OID 2023885)
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
-- TOC entry 7722 (class 0 OID 0)
-- Dependencies: 572
-- Name: memberTraitCommunity_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitCommunity_id_seq" OWNED BY members."memberTraitCommunity".id;


--
-- TOC entry 555 (class 1259 OID 2023796)
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
-- TOC entry 554 (class 1259 OID 2023795)
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
-- TOC entry 7723 (class 0 OID 0)
-- Dependencies: 554
-- Name: memberTraitDevice_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitDevice_id_seq" OWNED BY members."memberTraitDevice".id;


--
-- TOC entry 563 (class 1259 OID 2023836)
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
-- TOC entry 562 (class 1259 OID 2023835)
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
-- TOC entry 7724 (class 0 OID 0)
-- Dependencies: 562
-- Name: memberTraitEducation_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitEducation_id_seq" OWNED BY members."memberTraitEducation".id;


--
-- TOC entry 567 (class 1259 OID 2023856)
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
-- TOC entry 566 (class 1259 OID 2023855)
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
-- TOC entry 7725 (class 0 OID 0)
-- Dependencies: 566
-- Name: memberTraitLanguage_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitLanguage_id_seq" OWNED BY members."memberTraitLanguage".id;


--
-- TOC entry 569 (class 1259 OID 2023866)
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
-- TOC entry 568 (class 1259 OID 2023865)
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
-- TOC entry 7726 (class 0 OID 0)
-- Dependencies: 568
-- Name: memberTraitOnboardChecklist_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitOnboardChecklist_id_seq" OWNED BY members."memberTraitOnboardChecklist".id;


--
-- TOC entry 571 (class 1259 OID 2023876)
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
-- TOC entry 570 (class 1259 OID 2023875)
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
-- TOC entry 7727 (class 0 OID 0)
-- Dependencies: 570
-- Name: memberTraitPersonalization_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitPersonalization_id_seq" OWNED BY members."memberTraitPersonalization".id;


--
-- TOC entry 559 (class 1259 OID 2023816)
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
-- TOC entry 558 (class 1259 OID 2023815)
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
-- TOC entry 7728 (class 0 OID 0)
-- Dependencies: 558
-- Name: memberTraitServiceProvider_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitServiceProvider_id_seq" OWNED BY members."memberTraitServiceProvider".id;


--
-- TOC entry 557 (class 1259 OID 2023806)
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
-- TOC entry 556 (class 1259 OID 2023805)
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
-- TOC entry 7729 (class 0 OID 0)
-- Dependencies: 556
-- Name: memberTraitSoftware_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitSoftware_id_seq" OWNED BY members."memberTraitSoftware".id;


--
-- TOC entry 561 (class 1259 OID 2023826)
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
-- TOC entry 560 (class 1259 OID 2023825)
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
-- TOC entry 7730 (class 0 OID 0)
-- Dependencies: 560
-- Name: memberTraitWork_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraitWork_id_seq" OWNED BY members."memberTraitWork".id;


--
-- TOC entry 553 (class 1259 OID 2023786)
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
-- TOC entry 552 (class 1259 OID 2023785)
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
-- TOC entry 7731 (class 0 OID 0)
-- Dependencies: 552
-- Name: memberTraits_id_seq; Type: SEQUENCE OWNED BY; Schema: members; Owner: members
--

ALTER SEQUENCE members."memberTraits_id_seq" OWNED BY members."memberTraits".id;


--
-- TOC entry 575 (class 1259 OID 2023903)
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
-- TOC entry 574 (class 1259 OID 2023895)
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
-- TOC entry 577 (class 1259 OID 2023919)
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
-- TOC entry 334 (class 1259 OID 1348140)
-- Name: SequelizeMeta; Type: TABLE; Schema: messages; Owner: topcoder
--

CREATE TABLE messages."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE messages."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 335 (class 1259 OID 1348143)
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
-- TOC entry 336 (class 1259 OID 1348148)
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
-- TOC entry 7734 (class 0 OID 0)
-- Dependencies: 336
-- Name: email_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.email_logs_id_seq OWNED BY messages.email_logs.id;


--
-- TOC entry 337 (class 1259 OID 1348149)
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
-- TOC entry 338 (class 1259 OID 1348154)
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
-- TOC entry 7737 (class 0 OID 0)
-- Dependencies: 338
-- Name: post_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.post_attachments_id_seq OWNED BY messages.post_attachments.id;


--
-- TOC entry 339 (class 1259 OID 1348155)
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
-- TOC entry 340 (class 1259 OID 1348160)
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
-- TOC entry 341 (class 1259 OID 1348166)
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
-- TOC entry 7741 (class 0 OID 0)
-- Dependencies: 341
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.posts_id_seq OWNED BY messages.posts.id;


--
-- TOC entry 342 (class 1259 OID 1348167)
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
-- TOC entry 343 (class 1259 OID 1348172)
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
-- TOC entry 344 (class 1259 OID 1348180)
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
-- TOC entry 7745 (class 0 OID 0)
-- Dependencies: 344
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: messages; Owner: topcoder
--

ALTER SEQUENCE messages.topics_id_seq OWNED BY messages.topics.id;


--
-- TOC entry 387 (class 1259 OID 1436585)
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
-- TOC entry 388 (class 1259 OID 1436590)
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
-- TOC entry 7748 (class 0 OID 0)
-- Dependencies: 388
-- Name: NotificationSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."NotificationSettings_id_seq" OWNED BY notifications."NotificationSettings".id;


--
-- TOC entry 389 (class 1259 OID 1436591)
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
-- TOC entry 390 (class 1259 OID 1436596)
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
-- TOC entry 7751 (class 0 OID 0)
-- Dependencies: 390
-- Name: Notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."Notifications_id_seq" OWNED BY notifications."Notifications".id;


--
-- TOC entry 391 (class 1259 OID 1436597)
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
-- TOC entry 392 (class 1259 OID 1436602)
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
-- TOC entry 7754 (class 0 OID 0)
-- Dependencies: 392
-- Name: ScheduledEvents_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."ScheduledEvents_id_seq" OWNED BY notifications."ScheduledEvents".id;


--
-- TOC entry 393 (class 1259 OID 1436603)
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
-- TOC entry 394 (class 1259 OID 1436608)
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
-- TOC entry 7757 (class 0 OID 0)
-- Dependencies: 394
-- Name: ServiceSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications."ServiceSettings_id_seq" OWNED BY notifications."ServiceSettings".id;


--
-- TOC entry 395 (class 1259 OID 1436609)
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
-- TOC entry 396 (class 1259 OID 1436614)
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
-- TOC entry 397 (class 1259 OID 1436617)
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
-- TOC entry 7761 (class 0 OID 0)
-- Dependencies: 397
-- Name: bulk_message_user_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications.bulk_message_user_refs_id_seq OWNED BY notifications.bulk_message_user_refs.id;


--
-- TOC entry 398 (class 1259 OID 1436618)
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
-- TOC entry 399 (class 1259 OID 1436623)
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
-- TOC entry 7764 (class 0 OID 0)
-- Dependencies: 399
-- Name: bulk_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: topcoder
--

ALTER SEQUENCE notifications.bulk_messages_id_seq OWNED BY notifications.bulk_messages.id;


--
-- TOC entry 400 (class 1259 OID 1436624)
-- Name: tmpbtable; Type: TABLE; Schema: notifications; Owner: topcoder
--

CREATE TABLE notifications.tmpbtable (
    id bigint,
    type character varying(255),
    "userId" bigint
);


ALTER TABLE notifications.tmpbtable OWNER TO topcoder;

--
-- TOC entry 238 (class 1259 OID 1323830)
-- Name: SequelizeMeta; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE projects."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 239 (class 1259 OID 1323833)
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
-- TOC entry 240 (class 1259 OID 1323840)
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
-- TOC entry 7769 (class 0 OID 0)
-- Dependencies: 240
-- Name: building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.building_blocks_id_seq OWNED BY projects.building_blocks.id;


--
-- TOC entry 303 (class 1259 OID 1332735)
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
-- TOC entry 302 (class 1259 OID 1332734)
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
-- TOC entry 7772 (class 0 OID 0)
-- Dependencies: 302
-- Name: copilot_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: projects
--

ALTER SEQUENCE projects.copilot_applications_id_seq OWNED BY projects.copilot_applications.id;


--
-- TOC entry 241 (class 1259 OID 1323841)
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
-- TOC entry 242 (class 1259 OID 1323844)
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
-- TOC entry 7775 (class 0 OID 0)
-- Dependencies: 242
-- Name: copilot_opportunities_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.copilot_opportunities_id_seq OWNED BY projects.copilot_opportunities.id;


--
-- TOC entry 243 (class 1259 OID 1323845)
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
-- TOC entry 244 (class 1259 OID 1323850)
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
-- TOC entry 7778 (class 0 OID 0)
-- Dependencies: 244
-- Name: copilot_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.copilot_requests_id_seq OWNED BY projects.copilot_requests.id;


--
-- TOC entry 245 (class 1259 OID 1323851)
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
-- TOC entry 246 (class 1259 OID 1323856)
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
-- TOC entry 7781 (class 0 OID 0)
-- Dependencies: 246
-- Name: customer_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.customer_payments_id_seq OWNED BY projects.customer_payments.id;


--
-- TOC entry 247 (class 1259 OID 1323857)
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
-- TOC entry 248 (class 1259 OID 1323865)
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
-- TOC entry 7784 (class 0 OID 0)
-- Dependencies: 248
-- Name: form_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.form_id_seq OWNED BY projects.form.id;


--
-- TOC entry 249 (class 1259 OID 1323866)
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
-- TOC entry 250 (class 1259 OID 1323872)
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
-- TOC entry 251 (class 1259 OID 1323878)
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
-- TOC entry 7788 (class 0 OID 0)
-- Dependencies: 251
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.milestones_id_seq OWNED BY projects.milestones.id;


--
-- TOC entry 252 (class 1259 OID 1323879)
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
-- TOC entry 253 (class 1259 OID 1323884)
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
-- TOC entry 7791 (class 0 OID 0)
-- Dependencies: 253
-- Name: org_config_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.org_config_id_seq OWNED BY projects.org_config.id;


--
-- TOC entry 254 (class 1259 OID 1323885)
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
-- TOC entry 255 (class 1259 OID 1323894)
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
-- TOC entry 7794 (class 0 OID 0)
-- Dependencies: 255
-- Name: phase_products_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.phase_products_id_seq OWNED BY projects.phase_products.id;


--
-- TOC entry 256 (class 1259 OID 1323895)
-- Name: phase_work_streams; Type: TABLE; Schema: projects; Owner: topcoder
--

CREATE TABLE projects.phase_work_streams (
    "workStreamId" bigint NOT NULL,
    "phaseId" bigint NOT NULL
);


ALTER TABLE projects.phase_work_streams OWNER TO topcoder;

--
-- TOC entry 257 (class 1259 OID 1323898)
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
-- TOC entry 258 (class 1259 OID 1323906)
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
-- TOC entry 7798 (class 0 OID 0)
-- Dependencies: 258
-- Name: plan_config_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.plan_config_id_seq OWNED BY projects.plan_config.id;


--
-- TOC entry 259 (class 1259 OID 1323907)
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
-- TOC entry 260 (class 1259 OID 1323915)
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
-- TOC entry 7801 (class 0 OID 0)
-- Dependencies: 260
-- Name: price_config_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.price_config_id_seq OWNED BY projects.price_config.id;


--
-- TOC entry 261 (class 1259 OID 1323916)
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
-- TOC entry 262 (class 1259 OID 1323923)
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
-- TOC entry 7804 (class 0 OID 0)
-- Dependencies: 262
-- Name: product_milestone_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.product_milestone_templates_id_seq OWNED BY projects.milestone_templates.id;


--
-- TOC entry 263 (class 1259 OID 1323924)
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
-- TOC entry 264 (class 1259 OID 1323932)
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
-- TOC entry 265 (class 1259 OID 1323937)
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
-- TOC entry 7808 (class 0 OID 0)
-- Dependencies: 265
-- Name: product_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.product_templates_id_seq OWNED BY projects.product_templates.id;


--
-- TOC entry 266 (class 1259 OID 1323938)
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
-- TOC entry 267 (class 1259 OID 1323943)
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
-- TOC entry 7811 (class 0 OID 0)
-- Dependencies: 267
-- Name: project_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_attachments_id_seq OWNED BY projects.project_attachments.id;


--
-- TOC entry 268 (class 1259 OID 1323944)
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
-- TOC entry 7813 (class 0 OID 0)
-- Dependencies: 268
-- Name: project_estimation_items_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_estimation_items_id_seq OWNED BY projects.form.id;


--
-- TOC entry 269 (class 1259 OID 1323945)
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
-- TOC entry 270 (class 1259 OID 1323952)
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
-- TOC entry 271 (class 1259 OID 1323959)
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
-- TOC entry 7817 (class 0 OID 0)
-- Dependencies: 271
-- Name: project_estimations_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_estimations_id_seq OWNED BY projects.project_estimations.id;


--
-- TOC entry 272 (class 1259 OID 1323960)
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
-- TOC entry 273 (class 1259 OID 1323965)
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
-- TOC entry 7820 (class 0 OID 0)
-- Dependencies: 273
-- Name: project_history_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_history_id_seq OWNED BY projects.project_history.id;


--
-- TOC entry 274 (class 1259 OID 1323966)
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
-- TOC entry 275 (class 1259 OID 1323971)
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
-- TOC entry 7823 (class 0 OID 0)
-- Dependencies: 275
-- Name: project_member_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_member_invites_id_seq OWNED BY projects.project_member_invites.id;


--
-- TOC entry 276 (class 1259 OID 1323972)
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
-- TOC entry 277 (class 1259 OID 1323976)
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
-- TOC entry 7826 (class 0 OID 0)
-- Dependencies: 277
-- Name: project_members_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_members_id_seq OWNED BY projects.project_members.id;


--
-- TOC entry 278 (class 1259 OID 1323977)
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
-- TOC entry 279 (class 1259 OID 1323978)
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
-- TOC entry 280 (class 1259 OID 1323984)
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
-- TOC entry 281 (class 1259 OID 1323985)
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
-- TOC entry 282 (class 1259 OID 1323989)
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
-- TOC entry 283 (class 1259 OID 1323998)
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
-- TOC entry 7833 (class 0 OID 0)
-- Dependencies: 283
-- Name: project_phases_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_phases_id_seq OWNED BY projects.project_phases.id;


--
-- TOC entry 284 (class 1259 OID 1323999)
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
-- TOC entry 285 (class 1259 OID 1324007)
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
-- TOC entry 7836 (class 0 OID 0)
-- Dependencies: 285
-- Name: project_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_settings_id_seq OWNED BY projects.project_settings.id;


--
-- TOC entry 286 (class 1259 OID 1324008)
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
-- TOC entry 287 (class 1259 OID 1324016)
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
-- TOC entry 288 (class 1259 OID 1324021)
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
-- TOC entry 7840 (class 0 OID 0)
-- Dependencies: 288
-- Name: project_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.project_templates_id_seq OWNED BY projects.project_templates.id;


--
-- TOC entry 289 (class 1259 OID 1324022)
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
-- TOC entry 290 (class 1259 OID 1324029)
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
-- TOC entry 291 (class 1259 OID 1324037)
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
-- TOC entry 7844 (class 0 OID 0)
-- Dependencies: 291
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.projects_id_seq OWNED BY projects.projects.id;


--
-- TOC entry 292 (class 1259 OID 1324038)
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
-- TOC entry 293 (class 1259 OID 1324043)
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
-- TOC entry 7847 (class 0 OID 0)
-- Dependencies: 293
-- Name: scope_change_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.scope_change_requests_id_seq OWNED BY projects.scope_change_requests.id;


--
-- TOC entry 294 (class 1259 OID 1324044)
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
-- TOC entry 295 (class 1259 OID 1324049)
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
-- TOC entry 7850 (class 0 OID 0)
-- Dependencies: 295
-- Name: status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.status_history_id_seq OWNED BY projects.status_history.id;


--
-- TOC entry 296 (class 1259 OID 1324050)
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
-- TOC entry 297 (class 1259 OID 1324055)
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
-- TOC entry 7853 (class 0 OID 0)
-- Dependencies: 297
-- Name: timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.timelines_id_seq OWNED BY projects.timelines.id;


--
-- TOC entry 298 (class 1259 OID 1324056)
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
-- TOC entry 299 (class 1259 OID 1324061)
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
-- TOC entry 7856 (class 0 OID 0)
-- Dependencies: 299
-- Name: work_management_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.work_management_permissions_id_seq OWNED BY projects.work_management_permissions.id;


--
-- TOC entry 300 (class 1259 OID 1324062)
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
-- TOC entry 301 (class 1259 OID 1324067)
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
-- TOC entry 7859 (class 0 OID 0)
-- Dependencies: 301
-- Name: work_streams_id_seq; Type: SEQUENCE OWNED BY; Schema: projects; Owner: topcoder
--

ALTER SEQUENCE projects.work_streams_id_seq OWNED BY projects.work_streams.id;


--
-- TOC entry 508 (class 1259 OID 2015711)
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
-- TOC entry 507 (class 1259 OID 2015703)
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
-- TOC entry 509 (class 1259 OID 2015719)
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
-- TOC entry 506 (class 1259 OID 2015678)
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
-- TOC entry 584 (class 1259 OID 2033637)
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
-- TOC entry 606 (class 1259 OID 2034228)
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
-- TOC entry 607 (class 1259 OID 2034237)
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
-- TOC entry 608 (class 1259 OID 2034245)
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
-- TOC entry 609 (class 1259 OID 2034255)
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
-- TOC entry 592 (class 1259 OID 2033798)
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
-- TOC entry 593 (class 1259 OID 2033807)
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
-- TOC entry 594 (class 1259 OID 2033816)
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
-- TOC entry 595 (class 1259 OID 2033824)
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
-- TOC entry 603 (class 1259 OID 2034192)
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
-- TOC entry 605 (class 1259 OID 2034219)
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
-- TOC entry 604 (class 1259 OID 2034211)
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
-- TOC entry 602 (class 1259 OID 2034153)
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
-- TOC entry 589 (class 1259 OID 2033769)
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
-- TOC entry 597 (class 1259 OID 2033995)
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
-- TOC entry 610 (class 1259 OID 2034332)
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
-- TOC entry 590 (class 1259 OID 2033779)
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
-- TOC entry 591 (class 1259 OID 2033788)
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
-- TOC entry 596 (class 1259 OID 2033985)
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
-- TOC entry 599 (class 1259 OID 2034035)
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
-- TOC entry 598 (class 1259 OID 2034027)
-- Name: reviewType; Type: TABLE; Schema: reviews; Owner: reviews
--

CREATE TABLE reviews."reviewType" (
    id character varying(36) DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "isActive" boolean NOT NULL
);


ALTER TABLE reviews."reviewType" OWNER TO reviews;

--
-- TOC entry 585 (class 1259 OID 2033684)
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
-- TOC entry 586 (class 1259 OID 2033742)
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
-- TOC entry 588 (class 1259 OID 2033760)
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
-- TOC entry 587 (class 1259 OID 2033751)
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
-- TOC entry 600 (class 1259 OID 2034044)
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
    "virusScan" boolean DEFAULT false NOT NULL
);


ALTER TABLE reviews.submission OWNER TO reviews;

--
-- TOC entry 611 (class 1259 OID 2034355)
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
-- TOC entry 601 (class 1259 OID 2034144)
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
-- TOC entry 413 (class 1259 OID 1477130)
-- Name: SequelizeMeta; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE skills."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 414 (class 1259 OID 1477133)
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
-- TOC entry 415 (class 1259 OID 1477139)
-- Name: legacy_skill_map; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.legacy_skill_map (
    legacy_v5_id uuid NOT NULL,
    skill_id uuid NOT NULL
);


ALTER TABLE skills.legacy_skill_map OWNER TO topcoder;

--
-- TOC entry 416 (class 1259 OID 1477142)
-- Name: prod_challenge_emsi_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_challenge_emsi_skills (
    emsi_skill_id uuid NOT NULL,
    challenge_id uuid NOT NULL
);


ALTER TABLE skills.prod_challenge_emsi_skills OWNER TO topcoder;

--
-- TOC entry 417 (class 1259 OID 1477145)
-- Name: prod_job_emsi_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_job_emsi_skills (
    emsi_skill_id uuid NOT NULL,
    job_id uuid NOT NULL
);


ALTER TABLE skills.prod_job_emsi_skills OWNER TO topcoder;

--
-- TOC entry 418 (class 1259 OID 1477148)
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
-- TOC entry 419 (class 1259 OID 1477153)
-- Name: prod_v5_skills; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.prod_v5_skills (
    id uuid NOT NULL,
    name character varying(255),
    std_skill_id uuid
);


ALTER TABLE skills.prod_v5_skills OWNER TO topcoder;

--
-- TOC entry 420 (class 1259 OID 1477156)
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
-- TOC entry 421 (class 1259 OID 1477164)
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
-- TOC entry 422 (class 1259 OID 1477172)
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
-- TOC entry 423 (class 1259 OID 1477176)
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
-- TOC entry 424 (class 1259 OID 1477182)
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
-- TOC entry 425 (class 1259 OID 1477187)
-- Name: skill_to_emsi_skill_map; Type: TABLE; Schema: skills; Owner: topcoder
--

CREATE TABLE skills.skill_to_emsi_skill_map (
    skill_id uuid NOT NULL,
    emsi_skill_id uuid,
    emsi_id text
);


ALTER TABLE skills.skill_to_emsi_skill_map OWNER TO topcoder;

--
-- TOC entry 426 (class 1259 OID 1477192)
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
-- TOC entry 427 (class 1259 OID 1477198)
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
-- TOC entry 428 (class 1259 OID 1477205)
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
-- TOC entry 429 (class 1259 OID 1477210)
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
-- TOC entry 430 (class 1259 OID 1477216)
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
-- TOC entry 431 (class 1259 OID 1477221)
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
-- TOC entry 432 (class 1259 OID 1477226)
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
-- TOC entry 433 (class 1259 OID 1477231)
-- Name: vw_v5_skill_to_std_skill_map; Type: VIEW; Schema: skills; Owner: topcoder
--

CREATE VIEW skills.vw_v5_skill_to_std_skill_map AS
 SELECT pv5s.id AS v5_skill_id,
    lsm.skill_id AS standardized_skill_id
   FROM (skills.prod_v5_skills pv5s
     JOIN skills.legacy_skill_map lsm ON ((lsm.legacy_v5_id = pv5s.id)));


ALTER VIEW skills.vw_v5_skill_to_std_skill_map OWNER TO topcoder;

--
-- TOC entry 434 (class 1259 OID 1477235)
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
-- TOC entry 412 (class 1259 OID 1475979)
-- Name: SequelizeMeta; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE taas."SequelizeMeta" OWNER TO topcoder;

--
-- TOC entry 401 (class 1259 OID 1475457)
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
-- TOC entry 402 (class 1259 OID 1475464)
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
-- TOC entry 403 (class 1259 OID 1475470)
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
-- TOC entry 404 (class 1259 OID 1475482)
-- Name: legacy_skill_map; Type: TABLE; Schema: taas; Owner: topcoder
--

CREATE TABLE taas.legacy_skill_map (
    legacy_v5_id uuid NOT NULL,
    skill_id uuid NOT NULL
);


ALTER TABLE taas.legacy_skill_map OWNER TO topcoder;

--
-- TOC entry 405 (class 1259 OID 1475485)
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
-- TOC entry 406 (class 1259 OID 1475488)
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
-- TOC entry 407 (class 1259 OID 1475494)
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
-- TOC entry 408 (class 1259 OID 1475499)
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
-- TOC entry 409 (class 1259 OID 1475504)
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
-- TOC entry 410 (class 1259 OID 1475509)
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
-- TOC entry 411 (class 1259 OID 1475514)
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
-- TOC entry 376 (class 1259 OID 1363445)
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
-- TOC entry 377 (class 1259 OID 1363450)
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
-- TOC entry 378 (class 1259 OID 1363455)
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
-- TOC entry 379 (class 1259 OID 1363461)
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
-- TOC entry 380 (class 1259 OID 1363466)
-- Name: TermsOfUseDependency; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseDependency" (
    "dependencyTermsOfUseId" uuid NOT NULL,
    "dependentTermsOfUseId" uuid NOT NULL
);


ALTER TABLE terms."TermsOfUseDependency" OWNER TO topcoder;

--
-- TOC entry 381 (class 1259 OID 1363469)
-- Name: TermsOfUseDocusignTemplateXref; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseDocusignTemplateXref" (
    "termsOfUseId" uuid NOT NULL,
    "docusignTemplateId" character varying(255) NOT NULL
);


ALTER TABLE terms."TermsOfUseDocusignTemplateXref" OWNER TO topcoder;

--
-- TOC entry 382 (class 1259 OID 1363472)
-- Name: TermsOfUseType; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."TermsOfUseType" (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE terms."TermsOfUseType" OWNER TO topcoder;

--
-- TOC entry 383 (class 1259 OID 1363475)
-- Name: UserTermsOfUseBanXref; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."UserTermsOfUseBanXref" (
    "userId" bigint NOT NULL,
    "termsOfUseId" uuid NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE terms."UserTermsOfUseBanXref" OWNER TO topcoder;

--
-- TOC entry 384 (class 1259 OID 1363478)
-- Name: UserTermsOfUseXref; Type: TABLE; Schema: terms; Owner: topcoder
--

CREATE TABLE terms."UserTermsOfUseXref" (
    "userId" bigint NOT NULL,
    "termsOfUseId" uuid NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE terms."UserTermsOfUseXref" OWNER TO topcoder;

--
-- TOC entry 345 (class 1259 OID 1352761)
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
-- TOC entry 346 (class 1259 OID 1352766)
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
-- TOC entry 7905 (class 0 OID 0)
-- Dependencies: 346
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: timeline; Owner: topcoder
--

ALTER SEQUENCE timeline.events_id_seq OWNED BY timeline.events.id;


--
-- TOC entry 5736 (class 2604 OID 1363202)
-- Name: CertificationCategory id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationCategory" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationCategory_id_seq"'::regclass);


--
-- TOC entry 5737 (class 2604 OID 1363203)
-- Name: CertificationEnrollments id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationEnrollments" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationEnrollments_id_seq"'::regclass);


--
-- TOC entry 5739 (class 2604 OID 1363204)
-- Name: CertificationResource id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResource" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationResource_id_seq"'::regclass);


--
-- TOC entry 5740 (class 2604 OID 1363205)
-- Name: CertificationResourceProgresses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."CertificationResourceProgresses" ALTER COLUMN id SET DEFAULT nextval('academy."CertificationResourceProgresses_id_seq"'::regclass);


--
-- TOC entry 5742 (class 2604 OID 1363206)
-- Name: FccCertificationProgresses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCertificationProgresses" ALTER COLUMN id SET DEFAULT nextval('academy."FccCertificationProgresses_id_seq"'::regclass);


--
-- TOC entry 5743 (class 2604 OID 1363207)
-- Name: FccCourses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccCourses" ALTER COLUMN id SET DEFAULT nextval('academy."FccCourses_id_seq"'::regclass);


--
-- TOC entry 5746 (class 2604 OID 1363208)
-- Name: FccModuleProgresses id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModuleProgresses" ALTER COLUMN id SET DEFAULT nextval('academy."FccModuleProgresses_id_seq"'::regclass);


--
-- TOC entry 5748 (class 2604 OID 1363209)
-- Name: FccModules id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FccModules" ALTER COLUMN id SET DEFAULT nextval('academy."FccModules_id_seq"'::regclass);


--
-- TOC entry 5750 (class 2604 OID 1363210)
-- Name: FreeCodeCampCertification id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."FreeCodeCampCertification" ALTER COLUMN id SET DEFAULT nextval('academy."FreeCodeCampCertification_id_seq"'::regclass);


--
-- TOC entry 5754 (class 2604 OID 1363211)
-- Name: ResourceProvider id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."ResourceProvider" ALTER COLUMN id SET DEFAULT nextval('academy."ResourceProvider_id_seq"'::regclass);


--
-- TOC entry 5755 (class 2604 OID 1363212)
-- Name: TopcoderCertification id; Type: DEFAULT; Schema: academy; Owner: topcoder
--

ALTER TABLE ONLY academy."TopcoderCertification" ALTER COLUMN id SET DEFAULT nextval('academy."TopcoderCertification_id_seq"'::regclass);


--
-- TOC entry 5808 (class 2604 OID 1825504)
-- Name: BillingAccount id; Type: DEFAULT; Schema: billing-accounts; Owner: billingaccounts
--

ALTER TABLE ONLY "billing-accounts"."BillingAccount" ALTER COLUMN id SET DEFAULT nextval('"billing-accounts"."BillingAccount_id_seq"'::regclass);


--
-- TOC entry 5760 (class 2604 OID 1363881)
-- Name: Emails id; Type: DEFAULT; Schema: emails; Owner: topcoder
--

ALTER TABLE ONLY emails."Emails" ALTER COLUMN id SET DEFAULT nextval('emails."Emails_id_seq"'::regclass);


--
-- TOC entry 5693 (class 2604 OID 1334536)
-- Name: origin origin_id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.origin ALTER COLUMN origin_id SET DEFAULT nextval('finance.origin_origin_id_seq'::regclass);


--
-- TOC entry 5705 (class 2604 OID 1334566)
-- Name: payment_method payment_method_id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payment_method ALTER COLUMN payment_method_id SET DEFAULT nextval('finance.payment_method_payment_method_id_seq'::regclass);


--
-- TOC entry 5710 (class 2604 OID 1334591)
-- Name: payoneer_payment_method id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.payoneer_payment_method ALTER COLUMN id SET DEFAULT nextval('finance.payoneer_payment_method_id_seq'::regclass);


--
-- TOC entry 5711 (class 2604 OID 1334598)
-- Name: paypal_payment_method id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.paypal_payment_method ALTER COLUMN id SET DEFAULT nextval('finance.paypal_payment_method_id_seq'::regclass);


--
-- TOC entry 5723 (class 2604 OID 1334755)
-- Name: trolley_recipient id; Type: DEFAULT; Schema: finance; Owner: finance
--

ALTER TABLE ONLY finance.trolley_recipient ALTER COLUMN id SET DEFAULT nextval('finance.trolley_recipient_id_seq'::regclass);


--
-- TOC entry 5846 (class 2604 OID 1832037)
-- Name: client id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.client ALTER COLUMN id SET DEFAULT nextval('identity.client_id_seq'::regclass);


--
-- TOC entry 5815 (class 2604 OID 1831892)
-- Name: dice_connection id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.dice_connection ALTER COLUMN id SET DEFAULT nextval('identity.dice_connection_id_seq'::regclass);


--
-- TOC entry 5847 (class 2604 OID 1832046)
-- Name: role id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role ALTER COLUMN id SET DEFAULT nextval('identity.role_id_seq'::regclass);


--
-- TOC entry 5848 (class 2604 OID 1832053)
-- Name: role_assignment id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.role_assignment ALTER COLUMN id SET DEFAULT nextval('identity.role_assignment_id_seq'::regclass);


--
-- TOC entry 5832 (class 2604 OID 1831972)
-- Name: user_2fa id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_2fa ALTER COLUMN id SET DEFAULT nextval('identity.user_2fa_id_seq'::regclass);


--
-- TOC entry 5840 (class 2604 OID 1831995)
-- Name: user_otp_email id; Type: DEFAULT; Schema: identity; Owner: identity
--

ALTER TABLE ONLY identity.user_otp_email ALTER COLUMN id SET DEFAULT nextval('identity.user_otp_email_id_seq'::regclass);


--
-- TOC entry 5919 (class 2604 OID 2023629)
-- Name: distributionStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."distributionStats" ALTER COLUMN id SET DEFAULT nextval('members."distributionStats_id_seq"'::regclass);


--
-- TOC entry 5915 (class 2604 OID 2023609)
-- Name: memberAddress id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberAddress" ALTER COLUMN id SET DEFAULT nextval('members."memberAddress_id_seq"'::regclass);


--
-- TOC entry 5932 (class 2604 OID 2023689)
-- Name: memberCopilotStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberCopilotStats" ALTER COLUMN id SET DEFAULT nextval('members."memberCopilotStats_id_seq"'::regclass);


--
-- TOC entry 5927 (class 2604 OID 2023668)
-- Name: memberDataScienceHistoryStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceHistoryStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDataScienceHistoryStats_id_seq"'::regclass);


--
-- TOC entry 5942 (class 2604 OID 2023739)
-- Name: memberDataScienceStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDataScienceStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDataScienceStats_id_seq"'::regclass);


--
-- TOC entry 5938 (class 2604 OID 2023719)
-- Name: memberDesignStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDesignStats_id_seq"'::regclass);


--
-- TOC entry 5940 (class 2604 OID 2023729)
-- Name: memberDesignStatsItem id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDesignStatsItem" ALTER COLUMN id SET DEFAULT nextval('members."memberDesignStatsItem_id_seq"'::regclass);


--
-- TOC entry 5925 (class 2604 OID 2023658)
-- Name: memberDevelopHistoryStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopHistoryStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDevelopHistoryStats_id_seq"'::regclass);


--
-- TOC entry 5934 (class 2604 OID 2023699)
-- Name: memberDevelopStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStats" ALTER COLUMN id SET DEFAULT nextval('members."memberDevelopStats_id_seq"'::regclass);


--
-- TOC entry 5936 (class 2604 OID 2023709)
-- Name: memberDevelopStatsItem id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberDevelopStatsItem" ALTER COLUMN id SET DEFAULT nextval('members."memberDevelopStatsItem_id_seq"'::regclass);


--
-- TOC entry 5922 (class 2604 OID 2023647)
-- Name: memberHistoryStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberHistoryStats" ALTER COLUMN id SET DEFAULT nextval('members."memberHistoryStats_id_seq"'::regclass);


--
-- TOC entry 5950 (class 2604 OID 2023779)
-- Name: memberMarathonStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMarathonStats" ALTER COLUMN id SET DEFAULT nextval('members."memberMarathonStats_id_seq"'::regclass);


--
-- TOC entry 5917 (class 2604 OID 2023619)
-- Name: memberMaxRating id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberMaxRating" ALTER COLUMN id SET DEFAULT nextval('members."memberMaxRating_id_seq"'::regclass);


--
-- TOC entry 5946 (class 2604 OID 2023759)
-- Name: memberSrmChallengeDetail id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmChallengeDetail" ALTER COLUMN id SET DEFAULT nextval('members."memberSrmChallengeDetail_id_seq"'::regclass);


--
-- TOC entry 5948 (class 2604 OID 2023769)
-- Name: memberSrmDivisionDetail id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmDivisionDetail" ALTER COLUMN id SET DEFAULT nextval('members."memberSrmDivisionDetail_id_seq"'::regclass);


--
-- TOC entry 5944 (class 2604 OID 2023749)
-- Name: memberSrmStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberSrmStats" ALTER COLUMN id SET DEFAULT nextval('members."memberSrmStats_id_seq"'::regclass);


--
-- TOC entry 5929 (class 2604 OID 2023678)
-- Name: memberStats id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberStats" ALTER COLUMN id SET DEFAULT nextval('members."memberStats_id_seq"'::regclass);


--
-- TOC entry 5964 (class 2604 OID 2023849)
-- Name: memberTraitBasicInfo id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitBasicInfo" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitBasicInfo_id_seq"'::regclass);


--
-- TOC entry 5972 (class 2604 OID 2023889)
-- Name: memberTraitCommunity id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitCommunity" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitCommunity_id_seq"'::regclass);


--
-- TOC entry 5954 (class 2604 OID 2023799)
-- Name: memberTraitDevice id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitDevice" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitDevice_id_seq"'::regclass);


--
-- TOC entry 5962 (class 2604 OID 2023839)
-- Name: memberTraitEducation id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitEducation" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitEducation_id_seq"'::regclass);


--
-- TOC entry 5966 (class 2604 OID 2023859)
-- Name: memberTraitLanguage id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitLanguage" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitLanguage_id_seq"'::regclass);


--
-- TOC entry 5968 (class 2604 OID 2023869)
-- Name: memberTraitOnboardChecklist id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitOnboardChecklist" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitOnboardChecklist_id_seq"'::regclass);


--
-- TOC entry 5970 (class 2604 OID 2023879)
-- Name: memberTraitPersonalization id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitPersonalization" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitPersonalization_id_seq"'::regclass);


--
-- TOC entry 5958 (class 2604 OID 2023819)
-- Name: memberTraitServiceProvider id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitServiceProvider" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitServiceProvider_id_seq"'::regclass);


--
-- TOC entry 5956 (class 2604 OID 2023809)
-- Name: memberTraitSoftware id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitSoftware" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitSoftware_id_seq"'::regclass);


--
-- TOC entry 5960 (class 2604 OID 2023829)
-- Name: memberTraitWork id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraitWork" ALTER COLUMN id SET DEFAULT nextval('members."memberTraitWork_id_seq"'::regclass);


--
-- TOC entry 5952 (class 2604 OID 2023789)
-- Name: memberTraits id; Type: DEFAULT; Schema: members; Owner: members
--

ALTER TABLE ONLY members."memberTraits" ALTER COLUMN id SET DEFAULT nextval('members."memberTraits_id_seq"'::regclass);


--
-- TOC entry 5727 (class 2604 OID 1348181)
-- Name: email_logs id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.email_logs ALTER COLUMN id SET DEFAULT nextval('messages.email_logs_id_seq'::regclass);


--
-- TOC entry 5728 (class 2604 OID 1348182)
-- Name: post_attachments id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.post_attachments ALTER COLUMN id SET DEFAULT nextval('messages.post_attachments_id_seq'::regclass);


--
-- TOC entry 5729 (class 2604 OID 1348183)
-- Name: posts id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.posts ALTER COLUMN id SET DEFAULT nextval('messages.posts_id_seq'::regclass);


--
-- TOC entry 5731 (class 2604 OID 1348184)
-- Name: topics id; Type: DEFAULT; Schema: messages; Owner: topcoder
--

ALTER TABLE ONLY messages.topics ALTER COLUMN id SET DEFAULT nextval('messages.topics_id_seq'::regclass);


--
-- TOC entry 5761 (class 2604 OID 1436627)
-- Name: NotificationSettings id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."NotificationSettings" ALTER COLUMN id SET DEFAULT nextval('notifications."NotificationSettings_id_seq"'::regclass);


--
-- TOC entry 5762 (class 2604 OID 1436628)
-- Name: Notifications id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."Notifications" ALTER COLUMN id SET DEFAULT nextval('notifications."Notifications_id_seq"'::regclass);


--
-- TOC entry 5763 (class 2604 OID 1436629)
-- Name: ScheduledEvents id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."ScheduledEvents" ALTER COLUMN id SET DEFAULT nextval('notifications."ScheduledEvents_id_seq"'::regclass);


--
-- TOC entry 5764 (class 2604 OID 1436630)
-- Name: ServiceSettings id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications."ServiceSettings" ALTER COLUMN id SET DEFAULT nextval('notifications."ServiceSettings_id_seq"'::regclass);


--
-- TOC entry 5765 (class 2604 OID 1436631)
-- Name: bulk_message_user_refs id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_message_user_refs ALTER COLUMN id SET DEFAULT nextval('notifications.bulk_message_user_refs_id_seq'::regclass);


--
-- TOC entry 5766 (class 2604 OID 1436632)
-- Name: bulk_messages id; Type: DEFAULT; Schema: notifications; Owner: topcoder
--

ALTER TABLE ONLY notifications.bulk_messages ALTER COLUMN id SET DEFAULT nextval('notifications.bulk_messages_id_seq'::regclass);


--
-- TOC entry 5618 (class 2604 OID 1324068)
-- Name: building_blocks id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.building_blocks ALTER COLUMN id SET DEFAULT nextval('projects.building_blocks_id_seq'::regclass);


--
-- TOC entry 5688 (class 2604 OID 1332738)
-- Name: copilot_applications id; Type: DEFAULT; Schema: projects; Owner: projects
--

ALTER TABLE ONLY projects.copilot_applications ALTER COLUMN id SET DEFAULT nextval('projects.copilot_applications_id_seq'::regclass);


--
-- TOC entry 5621 (class 2604 OID 1324069)
-- Name: copilot_opportunities id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_opportunities ALTER COLUMN id SET DEFAULT nextval('projects.copilot_opportunities_id_seq'::regclass);


--
-- TOC entry 5622 (class 2604 OID 1324070)
-- Name: copilot_requests id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.copilot_requests ALTER COLUMN id SET DEFAULT nextval('projects.copilot_requests_id_seq'::regclass);


--
-- TOC entry 5623 (class 2604 OID 1324071)
-- Name: customer_payments id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.customer_payments ALTER COLUMN id SET DEFAULT nextval('projects.customer_payments_id_seq'::regclass);


--
-- TOC entry 5624 (class 2604 OID 1324072)
-- Name: form id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.form ALTER COLUMN id SET DEFAULT nextval('projects.form_id_seq'::regclass);


--
-- TOC entry 5628 (class 2604 OID 1324073)
-- Name: milestone_templates id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestone_templates ALTER COLUMN id SET DEFAULT nextval('projects.product_milestone_templates_id_seq'::regclass);


--
-- TOC entry 5630 (class 2604 OID 1324074)
-- Name: milestones id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.milestones ALTER COLUMN id SET DEFAULT nextval('projects.milestones_id_seq'::regclass);


--
-- TOC entry 5632 (class 2604 OID 1324075)
-- Name: org_config id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.org_config ALTER COLUMN id SET DEFAULT nextval('projects.org_config_id_seq'::regclass);


--
-- TOC entry 5633 (class 2604 OID 1324076)
-- Name: phase_products id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.phase_products ALTER COLUMN id SET DEFAULT nextval('projects.phase_products_id_seq'::regclass);


--
-- TOC entry 5638 (class 2604 OID 1324077)
-- Name: plan_config id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.plan_config ALTER COLUMN id SET DEFAULT nextval('projects.plan_config_id_seq'::regclass);


--
-- TOC entry 5642 (class 2604 OID 1324078)
-- Name: price_config id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.price_config ALTER COLUMN id SET DEFAULT nextval('projects.price_config_id_seq'::regclass);


--
-- TOC entry 5648 (class 2604 OID 1324079)
-- Name: product_templates id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.product_templates ALTER COLUMN id SET DEFAULT nextval('projects.product_templates_id_seq'::regclass);


--
-- TOC entry 5652 (class 2604 OID 1324080)
-- Name: project_attachments id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_attachments ALTER COLUMN id SET DEFAULT nextval('projects.project_attachments_id_seq'::regclass);


--
-- TOC entry 5655 (class 2604 OID 1324081)
-- Name: project_estimations id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_estimations ALTER COLUMN id SET DEFAULT nextval('projects.project_estimations_id_seq'::regclass);


--
-- TOC entry 5658 (class 2604 OID 1324082)
-- Name: project_history id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_history ALTER COLUMN id SET DEFAULT nextval('projects.project_history_id_seq'::regclass);


--
-- TOC entry 5659 (class 2604 OID 1324083)
-- Name: project_member_invites id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_member_invites ALTER COLUMN id SET DEFAULT nextval('projects.project_member_invites_id_seq'::regclass);


--
-- TOC entry 5660 (class 2604 OID 1324084)
-- Name: project_members id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_members ALTER COLUMN id SET DEFAULT nextval('projects.project_members_id_seq'::regclass);


--
-- TOC entry 5664 (class 2604 OID 1324085)
-- Name: project_phases id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_phases ALTER COLUMN id SET DEFAULT nextval('projects.project_phases_id_seq'::regclass);


--
-- TOC entry 5669 (class 2604 OID 1324086)
-- Name: project_settings id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_settings ALTER COLUMN id SET DEFAULT nextval('projects.project_settings_id_seq'::regclass);


--
-- TOC entry 5673 (class 2604 OID 1324087)
-- Name: project_templates id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.project_templates ALTER COLUMN id SET DEFAULT nextval('projects.project_templates_id_seq'::regclass);


--
-- TOC entry 5679 (class 2604 OID 1324088)
-- Name: projects id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.projects ALTER COLUMN id SET DEFAULT nextval('projects.projects_id_seq'::regclass);


--
-- TOC entry 5683 (class 2604 OID 1324089)
-- Name: scope_change_requests id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.scope_change_requests ALTER COLUMN id SET DEFAULT nextval('projects.scope_change_requests_id_seq'::regclass);


--
-- TOC entry 5684 (class 2604 OID 1324090)
-- Name: status_history id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.status_history ALTER COLUMN id SET DEFAULT nextval('projects.status_history_id_seq'::regclass);


--
-- TOC entry 5685 (class 2604 OID 1324091)
-- Name: timelines id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.timelines ALTER COLUMN id SET DEFAULT nextval('projects.timelines_id_seq'::regclass);


--
-- TOC entry 5686 (class 2604 OID 1324092)
-- Name: work_management_permissions id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.work_management_permissions ALTER COLUMN id SET DEFAULT nextval('projects.work_management_permissions_id_seq'::regclass);


--
-- TOC entry 5687 (class 2604 OID 1324093)
-- Name: work_streams id; Type: DEFAULT; Schema: projects; Owner: topcoder
--

ALTER TABLE ONLY projects.work_streams ALTER COLUMN id SET DEFAULT nextval('projects.work_streams_id_seq'::regclass);


--
-- TOC entry 5735 (class 2604 OID 1352767)
-- Name: events id; Type: DEFAULT; Schema: timeline; Owner: topcoder
--

ALTER TABLE ONLY timeline.events ALTER COLUMN id SET DEFAULT nextval('timeline.events_id_seq'::regclass);


--
-- TOC entry 7622 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA academy; Type: ACL; Schema: -; Owner: academy
--

GRANT CREATE ON SCHEMA academy TO PUBLIC;


--
-- TOC entry 7624 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA emails; Type: ACL; Schema: -; Owner: emails
--

GRANT ALL ON SCHEMA emails TO PUBLIC;


--
-- TOC entry 7625 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA gamification; Type: ACL; Schema: -; Owner: gamification
--

GRANT ALL ON SCHEMA gamification TO PUBLIC;


--
-- TOC entry 7626 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA messages; Type: ACL; Schema: -; Owner: messages
--

GRANT ALL ON SCHEMA messages TO PUBLIC;


--
-- TOC entry 7628 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA notifications; Type: ACL; Schema: -; Owner: notifications
--

GRANT ALL ON SCHEMA notifications TO PUBLIC;


--
-- TOC entry 7630 (class 0 OID 0)
-- Dependencies: 18
-- Name: SCHEMA projects; Type: ACL; Schema: -; Owner: projects
--

REVOKE ALL ON SCHEMA projects FROM pg_database_owner;
REVOKE USAGE ON SCHEMA projects FROM PUBLIC;
GRANT ALL ON SCHEMA projects TO projects;
GRANT ALL ON SCHEMA projects TO finance;
GRANT ALL ON SCHEMA projects TO PUBLIC;


--
-- TOC entry 7631 (class 0 OID 0)
-- Dependencies: 22
-- Name: SCHEMA resources; Type: ACL; Schema: -; Owner: resources
--

GRANT USAGE ON SCHEMA resources TO challenges;


--
-- TOC entry 7633 (class 0 OID 0)
-- Dependencies: 26
-- Name: SCHEMA skills; Type: ACL; Schema: -; Owner: skills
--

GRANT ALL ON SCHEMA skills TO PUBLIC;
GRANT ALL ON SCHEMA skills TO member_skills;


--
-- TOC entry 7636 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA timeline; Type: ACL; Schema: -; Owner: timeline
--

GRANT ALL ON SCHEMA timeline TO PUBLIC;


--
-- TOC entry 7641 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE "CertificationCategory"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationCategory" TO academy;


--
-- TOC entry 7643 (class 0 OID 0)
-- Dependencies: 348
-- Name: SEQUENCE "CertificationCategory_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationCategory_id_seq" TO academy;


--
-- TOC entry 7644 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE "CertificationEnrollments"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationEnrollments" TO academy;


--
-- TOC entry 7646 (class 0 OID 0)
-- Dependencies: 350
-- Name: SEQUENCE "CertificationEnrollments_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationEnrollments_id_seq" TO academy;


--
-- TOC entry 7647 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE "CertificationResource"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationResource" TO academy;


--
-- TOC entry 7648 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE "CertificationResourceProgresses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."CertificationResourceProgresses" TO academy;


--
-- TOC entry 7650 (class 0 OID 0)
-- Dependencies: 353
-- Name: SEQUENCE "CertificationResourceProgresses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationResourceProgresses_id_seq" TO academy;


--
-- TOC entry 7652 (class 0 OID 0)
-- Dependencies: 354
-- Name: SEQUENCE "CertificationResource_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."CertificationResource_id_seq" TO academy;


--
-- TOC entry 7653 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE "DataVersion"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."DataVersion" TO academy;


--
-- TOC entry 7654 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE "FccCertificationProgresses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccCertificationProgresses" TO academy;


--
-- TOC entry 7656 (class 0 OID 0)
-- Dependencies: 357
-- Name: SEQUENCE "FccCertificationProgresses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccCertificationProgresses_id_seq" TO academy;


--
-- TOC entry 7657 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE "FccCompletedLessons"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccCompletedLessons" TO academy;


--
-- TOC entry 7658 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE "FccCourses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccCourses" TO academy;


--
-- TOC entry 7660 (class 0 OID 0)
-- Dependencies: 360
-- Name: SEQUENCE "FccCourses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccCourses_id_seq" TO academy;


--
-- TOC entry 7661 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE "FccLessons"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccLessons" TO academy;


--
-- TOC entry 7662 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE "FccModuleProgresses"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccModuleProgresses" TO academy;


--
-- TOC entry 7664 (class 0 OID 0)
-- Dependencies: 363
-- Name: SEQUENCE "FccModuleProgresses_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccModuleProgresses_id_seq" TO academy;


--
-- TOC entry 7665 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE "FccModules"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FccModules" TO academy;


--
-- TOC entry 7667 (class 0 OID 0)
-- Dependencies: 365
-- Name: SEQUENCE "FccModules_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FccModules_id_seq" TO academy;


--
-- TOC entry 7668 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE "FreeCodeCampCertification"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."FreeCodeCampCertification" TO academy;


--
-- TOC entry 7670 (class 0 OID 0)
-- Dependencies: 367
-- Name: SEQUENCE "FreeCodeCampCertification_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."FreeCodeCampCertification_id_seq" TO academy;


--
-- TOC entry 7671 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE "ResourceProvider"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."ResourceProvider" TO academy;


--
-- TOC entry 7673 (class 0 OID 0)
-- Dependencies: 369
-- Name: SEQUENCE "ResourceProvider_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."ResourceProvider_id_seq" TO academy;


--
-- TOC entry 7674 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."SequelizeMeta" TO academy;


--
-- TOC entry 7675 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE "TopcoderCertification"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."TopcoderCertification" TO academy;


--
-- TOC entry 7677 (class 0 OID 0)
-- Dependencies: 372
-- Name: SEQUENCE "TopcoderCertification_id_seq"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT ALL ON SEQUENCE academy."TopcoderCertification_id_seq" TO academy;


--
-- TOC entry 7678 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE "TopcoderUdemyCourse"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."TopcoderUdemyCourse" TO academy;


--
-- TOC entry 7679 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE "UdemyCourse"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."UdemyCourse" TO academy;


--
-- TOC entry 7680 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE "fccCertsModulesLessons"; Type: ACL; Schema: academy; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE academy."fccCertsModulesLessons" TO academy;


--
-- TOC entry 7682 (class 0 OID 0)
-- Dependencies: 385
-- Name: TABLE "Emails"; Type: ACL; Schema: emails; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE emails."Emails" TO emails;


--
-- TOC entry 7684 (class 0 OID 0)
-- Dependencies: 386
-- Name: SEQUENCE "Emails_id_seq"; Type: ACL; Schema: emails; Owner: topcoder
--

GRANT ALL ON SEQUENCE emails."Emails_id_seq" TO emails;


--
-- TOC entry 7690 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification."SequelizeMeta" TO gamification;


--
-- TOC entry 7691 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE badge_custom_fields; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.badge_custom_fields TO gamification;


--
-- TOC entry 7692 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE member_badges; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.member_badges TO gamification;


--
-- TOC entry 7693 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE organization; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization TO gamification;


--
-- TOC entry 7694 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE organization_badges; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization_badges TO gamification;


--
-- TOC entry 7695 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE organization_badges_custom_fields; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization_badges_custom_fields TO gamification;


--
-- TOC entry 7696 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE organization_badges_tags; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.organization_badges_tags TO gamification;


--
-- TOC entry 7697 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE tags; Type: ACL; Schema: gamification; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE gamification.tags TO gamification;


--
-- TOC entry 7732 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages."SequelizeMeta" TO messages;


--
-- TOC entry 7733 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE email_logs; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.email_logs TO messages;


--
-- TOC entry 7735 (class 0 OID 0)
-- Dependencies: 336
-- Name: SEQUENCE email_logs_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.email_logs_id_seq TO messages;


--
-- TOC entry 7736 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE post_attachments; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.post_attachments TO messages;


--
-- TOC entry 7738 (class 0 OID 0)
-- Dependencies: 338
-- Name: SEQUENCE post_attachments_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.post_attachments_id_seq TO messages;


--
-- TOC entry 7739 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE post_user_stats; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.post_user_stats TO messages;


--
-- TOC entry 7740 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE posts; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.posts TO messages;


--
-- TOC entry 7742 (class 0 OID 0)
-- Dependencies: 341
-- Name: SEQUENCE posts_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.posts_id_seq TO messages;


--
-- TOC entry 7743 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE reference_lookups; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.reference_lookups TO messages;


--
-- TOC entry 7744 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE topics; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE messages.topics TO messages;


--
-- TOC entry 7746 (class 0 OID 0)
-- Dependencies: 344
-- Name: SEQUENCE topics_id_seq; Type: ACL; Schema: messages; Owner: topcoder
--

GRANT ALL ON SEQUENCE messages.topics_id_seq TO messages;


--
-- TOC entry 7747 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE "NotificationSettings"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."NotificationSettings" TO notifications;


--
-- TOC entry 7749 (class 0 OID 0)
-- Dependencies: 388
-- Name: SEQUENCE "NotificationSettings_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."NotificationSettings_id_seq" TO notifications;


--
-- TOC entry 7750 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE "Notifications"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."Notifications" TO notifications;


--
-- TOC entry 7752 (class 0 OID 0)
-- Dependencies: 390
-- Name: SEQUENCE "Notifications_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."Notifications_id_seq" TO notifications;


--
-- TOC entry 7753 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE "ScheduledEvents"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."ScheduledEvents" TO notifications;


--
-- TOC entry 7755 (class 0 OID 0)
-- Dependencies: 392
-- Name: SEQUENCE "ScheduledEvents_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."ScheduledEvents_id_seq" TO notifications;


--
-- TOC entry 7756 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE "ServiceSettings"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications."ServiceSettings" TO notifications;


--
-- TOC entry 7758 (class 0 OID 0)
-- Dependencies: 394
-- Name: SEQUENCE "ServiceSettings_id_seq"; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications."ServiceSettings_id_seq" TO notifications;


--
-- TOC entry 7759 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE bk_notifications_20200609; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.bk_notifications_20200609 TO notifications;


--
-- TOC entry 7760 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE bulk_message_user_refs; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.bulk_message_user_refs TO notifications;


--
-- TOC entry 7762 (class 0 OID 0)
-- Dependencies: 397
-- Name: SEQUENCE bulk_message_user_refs_id_seq; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications.bulk_message_user_refs_id_seq TO notifications;


--
-- TOC entry 7763 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE bulk_messages; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.bulk_messages TO notifications;


--
-- TOC entry 7765 (class 0 OID 0)
-- Dependencies: 399
-- Name: SEQUENCE bulk_messages_id_seq; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT ALL ON SEQUENCE notifications.bulk_messages_id_seq TO notifications;


--
-- TOC entry 7766 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE tmpbtable; Type: ACL; Schema: notifications; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE notifications.tmpbtable TO notifications;


--
-- TOC entry 7767 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects."SequelizeMeta" TO projects;


--
-- TOC entry 7768 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE building_blocks; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.building_blocks TO projects;


--
-- TOC entry 7770 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE building_blocks_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.building_blocks_id_seq TO projects;


--
-- TOC entry 7771 (class 0 OID 0)
-- Dependencies: 303
-- Name: TABLE copilot_applications; Type: ACL; Schema: projects; Owner: projects
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.copilot_applications TO topcoder;


--
-- TOC entry 7773 (class 0 OID 0)
-- Dependencies: 302
-- Name: SEQUENCE copilot_applications_id_seq; Type: ACL; Schema: projects; Owner: projects
--

GRANT ALL ON SEQUENCE projects.copilot_applications_id_seq TO topcoder;


--
-- TOC entry 7774 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE copilot_opportunities; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.copilot_opportunities TO projects;


--
-- TOC entry 7776 (class 0 OID 0)
-- Dependencies: 242
-- Name: SEQUENCE copilot_opportunities_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.copilot_opportunities_id_seq TO projects;


--
-- TOC entry 7777 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE copilot_requests; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.copilot_requests TO projects;


--
-- TOC entry 7779 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE copilot_requests_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.copilot_requests_id_seq TO projects;


--
-- TOC entry 7780 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE customer_payments; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.customer_payments TO projects;


--
-- TOC entry 7782 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE customer_payments_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.customer_payments_id_seq TO projects;


--
-- TOC entry 7783 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE form; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.form TO projects;


--
-- TOC entry 7785 (class 0 OID 0)
-- Dependencies: 248
-- Name: SEQUENCE form_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.form_id_seq TO projects;


--
-- TOC entry 7786 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE milestone_templates; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.milestone_templates TO projects;


--
-- TOC entry 7787 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE milestones; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.milestones TO projects;


--
-- TOC entry 7789 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE milestones_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.milestones_id_seq TO projects;


--
-- TOC entry 7790 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE org_config; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.org_config TO projects;


--
-- TOC entry 7792 (class 0 OID 0)
-- Dependencies: 253
-- Name: SEQUENCE org_config_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.org_config_id_seq TO projects;


--
-- TOC entry 7793 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE phase_products; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.phase_products TO projects;


--
-- TOC entry 7795 (class 0 OID 0)
-- Dependencies: 255
-- Name: SEQUENCE phase_products_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.phase_products_id_seq TO projects;


--
-- TOC entry 7796 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE phase_work_streams; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.phase_work_streams TO projects;


--
-- TOC entry 7797 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE plan_config; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.plan_config TO projects;


--
-- TOC entry 7799 (class 0 OID 0)
-- Dependencies: 258
-- Name: SEQUENCE plan_config_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.plan_config_id_seq TO projects;


--
-- TOC entry 7800 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE price_config; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.price_config TO projects;


--
-- TOC entry 7802 (class 0 OID 0)
-- Dependencies: 260
-- Name: SEQUENCE price_config_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.price_config_id_seq TO projects;


--
-- TOC entry 7803 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE product_categories; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.product_categories TO projects;


--
-- TOC entry 7805 (class 0 OID 0)
-- Dependencies: 262
-- Name: SEQUENCE product_milestone_templates_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.product_milestone_templates_id_seq TO projects;


--
-- TOC entry 7806 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE product_templates; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.product_templates TO projects;


--
-- TOC entry 7807 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE product_templates_backup; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.product_templates_backup TO projects;


--
-- TOC entry 7809 (class 0 OID 0)
-- Dependencies: 265
-- Name: SEQUENCE product_templates_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.product_templates_id_seq TO projects;


--
-- TOC entry 7810 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE project_attachments; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_attachments TO projects;


--
-- TOC entry 7812 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE project_attachments_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_attachments_id_seq TO projects;


--
-- TOC entry 7814 (class 0 OID 0)
-- Dependencies: 268
-- Name: SEQUENCE project_estimation_items_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_estimation_items_id_seq TO projects;


--
-- TOC entry 7815 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE project_estimation_items; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_estimation_items TO projects;


--
-- TOC entry 7816 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE project_estimations; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_estimations TO projects;


--
-- TOC entry 7818 (class 0 OID 0)
-- Dependencies: 271
-- Name: SEQUENCE project_estimations_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_estimations_id_seq TO projects;


--
-- TOC entry 7819 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE project_history; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_history TO projects;


--
-- TOC entry 7821 (class 0 OID 0)
-- Dependencies: 273
-- Name: SEQUENCE project_history_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_history_id_seq TO projects;


--
-- TOC entry 7822 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE project_member_invites; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_member_invites TO projects;


--
-- TOC entry 7824 (class 0 OID 0)
-- Dependencies: 275
-- Name: SEQUENCE project_member_invites_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_member_invites_id_seq TO projects;


--
-- TOC entry 7825 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE project_members; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_members TO projects;


--
-- TOC entry 7827 (class 0 OID 0)
-- Dependencies: 277
-- Name: SEQUENCE project_members_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_members_id_seq TO projects;


--
-- TOC entry 7828 (class 0 OID 0)
-- Dependencies: 278
-- Name: SEQUENCE project_phase_approval_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_phase_approval_id_seq TO projects;


--
-- TOC entry 7829 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE project_phase_approval; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_phase_approval TO projects;


--
-- TOC entry 7830 (class 0 OID 0)
-- Dependencies: 280
-- Name: SEQUENCE project_phase_member_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_phase_member_id_seq TO projects;


--
-- TOC entry 7831 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE project_phase_member; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_phase_member TO projects;


--
-- TOC entry 7832 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE project_phases; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_phases TO projects;


--
-- TOC entry 7834 (class 0 OID 0)
-- Dependencies: 283
-- Name: SEQUENCE project_phases_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_phases_id_seq TO projects;


--
-- TOC entry 7835 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE project_settings; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_settings TO projects;


--
-- TOC entry 7837 (class 0 OID 0)
-- Dependencies: 285
-- Name: SEQUENCE project_settings_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_settings_id_seq TO projects;


--
-- TOC entry 7838 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE project_templates; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_templates TO projects;


--
-- TOC entry 7839 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE project_templates_backup; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_templates_backup TO projects;


--
-- TOC entry 7841 (class 0 OID 0)
-- Dependencies: 288
-- Name: SEQUENCE project_templates_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.project_templates_id_seq TO projects;


--
-- TOC entry 7842 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE project_types; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.project_types TO projects;


--
-- TOC entry 7843 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE projects; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.projects TO projects;


--
-- TOC entry 7845 (class 0 OID 0)
-- Dependencies: 291
-- Name: SEQUENCE projects_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.projects_id_seq TO projects;


--
-- TOC entry 7846 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE scope_change_requests; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.scope_change_requests TO projects;


--
-- TOC entry 7848 (class 0 OID 0)
-- Dependencies: 293
-- Name: SEQUENCE scope_change_requests_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.scope_change_requests_id_seq TO projects;


--
-- TOC entry 7849 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE status_history; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.status_history TO projects;


--
-- TOC entry 7851 (class 0 OID 0)
-- Dependencies: 295
-- Name: SEQUENCE status_history_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.status_history_id_seq TO projects;


--
-- TOC entry 7852 (class 0 OID 0)
-- Dependencies: 296
-- Name: TABLE timelines; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.timelines TO projects;


--
-- TOC entry 7854 (class 0 OID 0)
-- Dependencies: 297
-- Name: SEQUENCE timelines_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.timelines_id_seq TO projects;


--
-- TOC entry 7855 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE work_management_permissions; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.work_management_permissions TO projects;


--
-- TOC entry 7857 (class 0 OID 0)
-- Dependencies: 299
-- Name: SEQUENCE work_management_permissions_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.work_management_permissions_id_seq TO projects;


--
-- TOC entry 7858 (class 0 OID 0)
-- Dependencies: 300
-- Name: TABLE work_streams; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE projects.work_streams TO projects;


--
-- TOC entry 7860 (class 0 OID 0)
-- Dependencies: 301
-- Name: SEQUENCE work_streams_id_seq; Type: ACL; Schema: projects; Owner: topcoder
--

GRANT ALL ON SEQUENCE projects.work_streams_id_seq TO projects;


--
-- TOC entry 7861 (class 0 OID 0)
-- Dependencies: 413
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."SequelizeMeta" TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."SequelizeMeta" TO member_skills;


--
-- TOC entry 7862 (class 0 OID 0)
-- Dependencies: 414
-- Name: TABLE event; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.event TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.event TO member_skills;


--
-- TOC entry 7863 (class 0 OID 0)
-- Dependencies: 415
-- Name: TABLE legacy_skill_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.legacy_skill_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.legacy_skill_map TO member_skills;


--
-- TOC entry 7864 (class 0 OID 0)
-- Dependencies: 416
-- Name: TABLE prod_challenge_emsi_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_challenge_emsi_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_challenge_emsi_skills TO member_skills;


--
-- TOC entry 7865 (class 0 OID 0)
-- Dependencies: 417
-- Name: TABLE prod_job_emsi_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_job_emsi_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_job_emsi_skills TO member_skills;


--
-- TOC entry 7866 (class 0 OID 0)
-- Dependencies: 418
-- Name: TABLE prod_user_emsi_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_user_emsi_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_user_emsi_skills TO member_skills;


--
-- TOC entry 7867 (class 0 OID 0)
-- Dependencies: 419
-- Name: TABLE prod_v5_skills; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_v5_skills TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.prod_v5_skills TO member_skills;


--
-- TOC entry 7868 (class 0 OID 0)
-- Dependencies: 420
-- Name: TABLE skill; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill TO member_skills;


--
-- TOC entry 7869 (class 0 OID 0)
-- Dependencies: 421
-- Name: TABLE skill_category; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_category TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_category TO member_skills;


--
-- TOC entry 7870 (class 0 OID 0)
-- Dependencies: 422
-- Name: TABLE skill_event; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event TO member_skills;


--
-- TOC entry 7871 (class 0 OID 0)
-- Dependencies: 423
-- Name: TABLE skill_event_type; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event_type TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_event_type TO member_skills;


--
-- TOC entry 7872 (class 0 OID 0)
-- Dependencies: 424
-- Name: TABLE skill_replacement; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_replacement TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_replacement TO member_skills;


--
-- TOC entry 7873 (class 0 OID 0)
-- Dependencies: 425
-- Name: TABLE skill_to_emsi_skill_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_to_emsi_skill_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.skill_to_emsi_skill_map TO member_skills;


--
-- TOC entry 7874 (class 0 OID 0)
-- Dependencies: 426
-- Name: TABLE source_type; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.source_type TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.source_type TO member_skills;


--
-- TOC entry 7875 (class 0 OID 0)
-- Dependencies: 427
-- Name: TABLE user_skill; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill TO member_skills;


--
-- TOC entry 7876 (class 0 OID 0)
-- Dependencies: 428
-- Name: TABLE user_skill_display_mode; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_display_mode TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_display_mode TO member_skills;


--
-- TOC entry 7877 (class 0 OID 0)
-- Dependencies: 429
-- Name: TABLE user_skill_level; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_level TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.user_skill_level TO member_skills;


--
-- TOC entry 7878 (class 0 OID 0)
-- Dependencies: 430
-- Name: TABLE vw_all_skills_with_category; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_all_skills_with_category TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_all_skills_with_category TO member_skills;


--
-- TOC entry 7879 (class 0 OID 0)
-- Dependencies: 431
-- Name: TABLE vw_skill_to_emsi_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_skill_to_emsi_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_skill_to_emsi_map TO member_skills;


--
-- TOC entry 7880 (class 0 OID 0)
-- Dependencies: 432
-- Name: TABLE "vw_user_AI_skill_counts"; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."vw_user_AI_skill_counts" TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills."vw_user_AI_skill_counts" TO member_skills;


--
-- TOC entry 7881 (class 0 OID 0)
-- Dependencies: 433
-- Name: TABLE vw_v5_skill_to_std_skill_map; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_v5_skill_to_std_skill_map TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.vw_v5_skill_to_std_skill_map TO member_skills;


--
-- TOC entry 7882 (class 0 OID 0)
-- Dependencies: 434
-- Name: TABLE work_skill; Type: ACL; Schema: skills; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.work_skill TO skills;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE skills.work_skill TO member_skills;


--
-- TOC entry 7883 (class 0 OID 0)
-- Dependencies: 412
-- Name: TABLE "SequelizeMeta"; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas."SequelizeMeta" TO taas;


--
-- TOC entry 7884 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE interviews; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.interviews TO taas;


--
-- TOC entry 7885 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE job_candidates; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.job_candidates TO taas;


--
-- TOC entry 7886 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE jobs; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.jobs TO taas;


--
-- TOC entry 7887 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE legacy_skill_map; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.legacy_skill_map TO taas;


--
-- TOC entry 7888 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE payment_schedulers; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.payment_schedulers TO taas;


--
-- TOC entry 7889 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE resource_bookings; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.resource_bookings TO taas;


--
-- TOC entry 7890 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE role_search_requests; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.role_search_requests TO taas;


--
-- TOC entry 7891 (class 0 OID 0)
-- Dependencies: 408
-- Name: TABLE roles; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.roles TO taas;


--
-- TOC entry 7892 (class 0 OID 0)
-- Dependencies: 409
-- Name: TABLE user_meeting_settings; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.user_meeting_settings TO taas;


--
-- TOC entry 7893 (class 0 OID 0)
-- Dependencies: 410
-- Name: TABLE work_period_payments; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.work_period_payments TO taas;


--
-- TOC entry 7894 (class 0 OID 0)
-- Dependencies: 411
-- Name: TABLE work_periods; Type: ACL; Schema: taas; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE taas.work_periods TO taas;


--
-- TOC entry 7895 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE "DocusignEnvelope"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."DocusignEnvelope" TO terms;


--
-- TOC entry 7896 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE "TermsForResource"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsForResource" TO terms;


--
-- TOC entry 7897 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE "TermsOfUse"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUse" TO terms;


--
-- TOC entry 7898 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE "TermsOfUseAgreeabilityType"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseAgreeabilityType" TO terms;


--
-- TOC entry 7899 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE "TermsOfUseDependency"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseDependency" TO terms;


--
-- TOC entry 7900 (class 0 OID 0)
-- Dependencies: 381
-- Name: TABLE "TermsOfUseDocusignTemplateXref"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseDocusignTemplateXref" TO terms;


--
-- TOC entry 7901 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE "TermsOfUseType"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."TermsOfUseType" TO terms;


--
-- TOC entry 7902 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE "UserTermsOfUseBanXref"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."UserTermsOfUseBanXref" TO terms;


--
-- TOC entry 7903 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE "UserTermsOfUseXref"; Type: ACL; Schema: terms; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE terms."UserTermsOfUseXref" TO terms;


--
-- TOC entry 7904 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE events; Type: ACL; Schema: timeline; Owner: topcoder
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE timeline.events TO timeline;


--
-- TOC entry 7906 (class 0 OID 0)
-- Dependencies: 346
-- Name: SEQUENCE events_id_seq; Type: ACL; Schema: timeline; Owner: topcoder
--

GRANT ALL ON SEQUENCE timeline.events_id_seq TO timeline;


-- Completed on 2025-10-27 07:52:24 AEDT

--
-- PostgreSQL database dump complete
--

\unrestrict s16NovA9EFBc13dBHlnDEcS07mSi2bKZrbuVMRHyMVer1OegddV4BfKSOHzAqYR

