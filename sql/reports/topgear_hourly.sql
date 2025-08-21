SELECT
    *
FROM
    challenges."Challenge" AS challenge
    INNER JOIN challenges."ChallengeBilling" AS billing ON challenge.id = billing."challengeId"
WHERE
    billing."billingAccountId" IN ('80001059', '80001072')