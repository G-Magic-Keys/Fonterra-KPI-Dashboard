CREATE DATABASE FonterraKPI;
GO

USE FonterraKPI;
GO

-- =============================================
-- TABLE 1: MONTHLY KPI ACTUALS
-- Tracks the 4 KPIs month by month
-- =============================================

CREATE TABLE MonthlyKPI (
    ID              INT IDENTITY(1,1) PRIMARY KEY,
    MonthYear       DATE,
    Month_Name      VARCHAR(20),
    Season          VARCHAR(20),    -- Spring/Summer/Autumn/Winter
    MAPE_Pct        DECIMAL(5,2),   -- Forecast error %
    Inventory_Days  INT,            -- Days of forward cover
    OTIF_Pct        DECIMAL(5,2),   -- On Time In Full %
    WriteOffs_NZD   DECIMAL(10,2),  -- NZ$ millions
    Scenario        VARCHAR(20)     -- Base/Optimistic/Disruption
);
GO

-- =============================================
-- TABLE 2: KPI TARGETS
-- One row per KPI showing current vs target
-- =============================================

CREATE TABLE KPITargets (
    ID              INT IDENTITY(1,1) PRIMARY KEY,
    KPI_Name        VARCHAR(50),
    Current_Value   DECIMAL(10,2),
    Target_Value    DECIMAL(10,2),
    Unit            VARCHAR(20),
    Status          VARCHAR(10),    -- Red/Amber/Green
    Source          VARCHAR(100)
);
GO
CREATE TABLE MarketPerformance (
    ID              INT IDENTITY(1,1) PRIMARY KEY,
    Market          VARCHAR(50),
    Export_Share_Pct DECIMAL(5,2),  -- % of total exports
    OTIF_Pct        DECIMAL(5,2),
    Stockout_Events INT,            -- Number of stockouts per year
    Inv_Days        INT,
    Priority_Tier   INT             -- 1, 2, or 3
);
GO
CREATE TABLE SeasonalIndex (
    ID              INT IDENTITY(1,1) PRIMARY KEY,
    Month_Name      VARCHAR(10),
    Month_Num       INT,
    Supply_Index    INT,            -- Relative supply (avg = 100)
    Demand_Index    INT,            -- Relative demand (avg = 100)
    Gap_Index       INT             -- Demand minus Supply
);
GO

INSERT INTO MonthlyKPI 
(MonthYear, Month_Name, Season, MAPE_Pct, Inventory_Days, OTIF_Pct, WriteOffs_NZD, Scenario)
VALUES
-- FY2024/25 (Aug 2024 - Jul 2025)
('2024-08-01', 'Aug 2024', 'Winter',   14.2, 52, 79.5,  9.2,  'Base'),
('2024-09-01', 'Sep 2024', 'Spring',   16.8, 48, 76.3,  10.1, 'Base'),
('2024-10-01', 'Oct 2024', 'Spring',   18.5, 44, 74.1,  11.3, 'Base'),
('2024-11-01', 'Nov 2024', 'Spring',   17.9, 42, 75.8,  10.8, 'Base'),
('2024-12-01', 'Dec 2024', 'Summer',   15.3, 45, 78.2,  9.5,  'Base'),
('2025-01-01', 'Jan 2025', 'Summer',   13.7, 47, 80.1,  8.7,  'Base'),
('2025-02-01', 'Feb 2025', 'Summer',   12.4, 49, 82.3,  7.9,  'Base'),
('2025-03-01', 'Mar 2025', 'Autumn',   11.8, 50, 83.5,  7.2,  'Base'),
('2025-04-01', 'Apr 2025', 'Autumn',   11.2, 51, 84.1,  6.8,  'Base'),
('2025-05-01', 'May 2025', 'Autumn',   10.9, 50, 84.8,  6.5,  'Base'),
('2025-06-01', 'Jun 2025', 'Winter',   11.5, 49, 83.9,  6.9,  'Base'),
('2025-07-01', 'Jul 2025', 'Winter',   12.1, 48, 83.2,  7.3,  'Base'),

-- FY2025/26 (Aug 2025 - Jul 2026) — improving trend
('2025-08-01', 'Aug 2025', 'Winter',   11.8, 47, 84.5,  7.0,  'Base'),
('2025-09-01', 'Sep 2025', 'Spring',   13.2, 45, 82.1,  8.2,  'Base'),
('2025-10-01', 'Oct 2025', 'Spring',   14.5, 43, 80.3,  9.0,  'Base'),
('2025-11-01', 'Nov 2025', 'Spring',   13.9, 41, 81.5,  8.5,  'Base'),
('2025-12-01', 'Dec 2025', 'Summer',   12.1, 44, 83.8,  7.5,  'Base'),
('2026-01-01', 'Jan 2026', 'Summer',   10.8, 46, 85.2,  6.8,  'Base'),
('2026-02-01', 'Feb 2026', 'Summer',   9.5,  45, 87.1,  5.9,  'Base'),
('2026-03-01', 'Mar 2026', 'Autumn',   8.8,  44, 88.5,  5.4,  'Base'),
('2026-04-01', 'Apr 2026', 'Autumn',   8.2,  43, 89.3,  5.0,  'Base'),
('2026-05-01', 'May 2026', 'Autumn',   7.8,  42, 90.1,  4.7,  'Base'),
('2026-06-01', 'Jun 2026', 'Winter',   7.5,  41, 91.2,  4.4,  'Base'),
('2026-07-01', 'Jul 2026', 'Winter',   7.1,  40, 92.0,  4.1,  'Base');
GO

INSERT INTO KPITargets 
(KPI_Name, Current_Value, Target_Value, Unit, Status, Source)
VALUES
('Forecast Error (MAPE)',    12.5,  6.0,  '%',         'Red',   'Gartner Supply Chain Benchmarks'),
('Inventory Days Cover',     47.0,  38.0, 'Days',      'Amber', 'Fonterra FY24 Annual Report'),
('OTIF Rate',                82.5,  95.0, '%',         'Red',   'Gartner FMCG Top Quartile'),
('Inventory Write-Offs',     90.0,  30.0, 'NZD Million','Red',  'Fonterra FY24 + Industry Avg');
GO

INSERT INTO MarketPerformance 
(Market, Export_Share_Pct, OTIF_Pct, Stockout_Events, Inv_Days, Priority_Tier)
VALUES
('China',           30.0, 80.2, 8,  45, 1),
('Algeria',         12.0, 83.5, 5,  42, 1),
('UAE',              7.0, 85.1, 3,  40, 1),
('Southeast Asia',   9.0, 82.8, 6,  44, 2),
('Middle East',      6.0, 84.2, 4,  41, 2),
('Americas',         5.0, 87.3, 2,  38, 2),
('Europe',           4.0, 88.1, 2,  37, 2),
('Other Markets',   27.0, 79.5, 12, 48, 3);
GO

INSERT INTO SeasonalIndex 
(Month_Name, Month_Num, Supply_Index, Demand_Index, Gap_Index)
VALUES
('Aug',  1,  28,  82,  54),
('Sep',  2,  72,  78,   6),
('Oct',  3, 118,  70, -48),
('Nov',  4, 135,  68, -67),
('Dec',  5, 122,  88, -34),
('Jan',  6,  98, 100,   2),
('Feb',  7,  78,  96,  18),
('Mar',  8,  62,  90,  28),
('Apr',  9,  46,  87,  41),
('May', 10,  35,  85,  50),
('Jun', 11,  24,  83,  59),
('Jul', 12,  22,  80,  58);
GO

SELECT * FROM MonthlyKPI;
SELECT * FROM KPITargets;
SELECT * FROM MarketPerformance;
SELECT * FROM SeasonalIndex;