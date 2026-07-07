USE [Assets]
GO

/*
  HR company mapping support
  - Adds HRConnect + HRDatabase to GSET.Countries
  - Adds HRCompanyProfileID to GSET.Companies
  - Seeds Lebanon (LB) for testing with HR database name
  Safe to run multiple times.
*/

IF COL_LENGTH('GSET.Countries', 'HRConnect') IS NULL
BEGIN
    ALTER TABLE GSET.Countries
    ADD HRConnect bit NOT NULL CONSTRAINT DF_Countries_HRConnect DEFAULT (0);
END
GO

IF COL_LENGTH('GSET.Countries', 'HRDatabase') IS NULL
BEGIN
    ALTER TABLE GSET.Countries
    ADD HRDatabase nvarchar(50) NULL;
END
GO

IF COL_LENGTH('GSET.Companies', 'HRCompanyProfileID') IS NULL
BEGIN
    ALTER TABLE GSET.Companies
    ADD HRCompanyProfileID smallint NULL;
END
GO

/* Lebanon test setup */
UPDATE GSET.Countries
SET HRConnect = 1,
    HRDatabase = N'HRLEB'
WHERE CountryID = 'LB';
GO

/* Optional check */
SELECT CountryID, Country, HRConnect, HRDatabase
FROM GSET.Countries
WHERE CountryID = 'LB';
GO

/* Optional check from HR DB (must exist and caller must have access) */
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'HRLEB')
BEGIN
    EXEC('SELECT TOP (50) CompanyProfileId, PrmName FROM [HRLEB].[dbo].[vw_AssetsCompanies] ORDER BY PrmName');
END
GO
