-- Cyclistic — Phase 3 (Process): build a clean analysis table from the staging table.
-- Staging table `cyclistic.trips_raw` was loaded with all columns as STRING for
-- bulletproof ingestion; here we cast types, derive fields, and remove bad rows.

CREATE OR REPLACE TABLE cyclistic.trips_clean AS
WITH typed AS (
  SELECT
    ride_id,
    LOWER(TRIM(rideable_type)) AS rideable_type,
    SAFE_CAST(started_at AS TIMESTAMP) AS started_at,
    SAFE_CAST(ended_at   AS TIMESTAMP) AS ended_at,
    NULLIF(TRIM(start_station_name), '') AS start_station_name,
    NULLIF(TRIM(start_station_id),   '') AS start_station_id,
    NULLIF(TRIM(end_station_name),   '') AS end_station_name,
    NULLIF(TRIM(end_station_id),     '') AS end_station_id,
    SAFE_CAST(start_lat AS FLOAT64) AS start_lat,
    SAFE_CAST(start_lng AS FLOAT64) AS start_lng,
    SAFE_CAST(end_lat   AS FLOAT64) AS end_lat,
    SAFE_CAST(end_lng   AS FLOAT64) AS end_lng,
    LOWER(TRIM(member_casual)) AS member_casual
  FROM cyclistic.trips_raw
),
deduped AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
  FROM typed
)
SELECT
  ride_id, rideable_type, started_at, ended_at,
  start_station_name, start_station_id, end_station_name, end_station_id,
  start_lat, start_lng, end_lat, end_lng, member_casual,
  ROUND(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 60, 2) AS ride_length_min,
  FORMAT_TIMESTAMP('%A', started_at)  AS day_of_week,
  EXTRACT(DAYOFWEEK FROM started_at)  AS day_num,      -- 1=Sun .. 7=Sat
  FORMAT_TIMESTAMP('%B', started_at)  AS month_name,
  EXTRACT(MONTH FROM started_at)      AS month_num,
  EXTRACT(HOUR  FROM started_at)      AS start_hour,
  CASE
    WHEN EXTRACT(MONTH FROM started_at) IN (12,1,2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM started_at) IN (3,4,5)  THEN 'Spring'
    WHEN EXTRACT(MONTH FROM started_at) IN (6,7,8)  THEN 'Summer'
    ELSE 'Fall'
  END AS season
FROM deduped
WHERE rn = 1                                                    -- de-duplicate ride_id
  AND started_at >= TIMESTAMP('2025-07-01')                    -- scope to 12-month window
  AND started_at <  TIMESTAMP('2026-07-01')
  AND ended_at > started_at                                    -- remove zero/negative durations
  AND TIMESTAMP_DIFF(ended_at, started_at, SECOND) <= 86400    -- remove > 24h outliers
  AND member_casual IN ('member','casual');
