-- DATA CHECKS FOR NC SCORECARD

-- Nulls in cleaned production table vs source
SELECT
  'Clean Prod' AS TABLE,
  COUNT(VOTER_ID) AS N_VOTER_ID,
  COUNT(VOTER_STATUS) AS N_VOTER_STATUS,
  COUNT(PARTY) AS N_PARTY,
  COUNT(YEAR_OF_BIRTH) AS N_YEAR_OF_BIRTH,
  COUNT(GENDER) AS N_GENDER,
  COUNT(LATEST_REGISTRATION_DATE) AS N_LATEST_REGISTRATION_DATE,
  COUNT(STATE_FIPS) AS N_STATE_FIPS,
  COUNT(COUNTY_FIPS) AS N_COUNTY_FIPS,
  COUNT(COUNTY_NAME) AS N_COUNTY_NAME,
  COUNT(SCHOOL_DISTRICT_CODE) AS N_SCHOOL_DISTRICT_CODE,
  COUNT(SCHOOL_DISTRICT_NAME) AS N_SCHOOL_DISTRICT_NAME
FROM `tcc-research.nc_production.20250719_scorecard_nc`

UNION ALL

SELECT
  'Source' AS TABLE,
  COUNT(DISTINCT ncid) AS N_VOTER_ID,
  COUNT(voter_status_desc) AS N_VOTER_STATUS,
  COUNT(party_cd) AS N_PARTY,
  COUNT(birth_year) AS N_YEAR_OF_BIRTH,
  COUNT(gender_code) AS N_GENDER,
  COUNT(registr_dt) AS N_LATEST_REGISTRATION_DATE,
  NULL AS N_STATE_FIPS,
  NULL AS N_COUNTY_FIPS,
  COUNT(county_desc) AS N_COUNTY_NAME,
  NULL AS N_SCHOOL_DISTRICT_CODE,
  NULL AS N_SCHOOL_DISTRICT_NAME
FROM `tcc-research.nc_sources.20250719_nc_voter_registration_and_history`;
--less but makes sense because i sorted out removed and denied voters
-- Voter ID duplication
SELECT
  COUNT(VOTER_ID) AS N_VOTERS,
  COUNT(DISTINCT VOTER_ID) AS N_UNIQUE_VOTERS
FROM `tcc-research.nc_production.20250719_scorecard_nc`;

-- Voter status breakdown
SELECT
  VOTER_STATUS,
  COUNT(VOTER_ID) AS N_VOTERS
FROM `tcc-research.nc_production.20250719_scorecard_nc`
GROUP BY VOTER_STATUS
ORDER BY N_VOTERS DESC;

-- Registration date range
SELECT
  MAX(LATEST_REGISTRATION_DATE) AS max_REG,
  MIN(LATEST_REGISTRATION_DATE) AS min_REG
FROM `tcc-research.nc_production.20250719_scorecard_nc`;

--looks good
-- Year of birth checks
SELECT
  MAX(YEAR_OF_BIRTH) AS max_YOB,
  MIN(YEAR_OF_BIRTH) AS min_YOB
FROM `tcc-research.nc_production.20250719_scorecard_nc`;

SELECT
  YEAR_OF_BIRTH,
  COUNT(DISTINCT VOTER_ID) AS N_VOTERS
FROM `tcc-research.nc_production.20250719_scorecard_nc`
GROUP BY YEAR_OF_BIRTH
ORDER BY YEAR_OF_BIRTH;

-- Spot-check odd birth years
SELECT *
FROM `tcc-research.nc_sources.20250719_nc_voter_registration_and_history`
WHERE birth_year = '1753';

-- theres just three
-- Gender values sanity check
SELECT DISTINCT GENDER AS GENDER
FROM `tcc-research.nc_production.20250719_scorecard_nc`;

-- County mapping check
SELECT
  COUNTY_FIPS,
  COUNTY_NAME,
  COUNT(DISTINCT VOTER_ID) AS n_VOTER_ID
FROM `tcc-research.nc_production.20250719_scorecard_nc`
GROUP BY COUNTY_FIPS, COUNTY_NAME
ORDER BY n_VOTER_ID DESC;
-- Should have 100 counties (NC has 100 counties)
