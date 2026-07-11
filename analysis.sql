-- Cyclistic — Phase 4 (Analyze): member vs casual behavior on cyclistic.trips_clean

-- 1. Ridership split (opportunity size)
SELECT member_casual, COUNT(*) AS rides,
       ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER (),1) AS pct
FROM cyclistic.trips_clean
GROUP BY member_casual;

-- 2. Ride length (avg, median, max) — median via APPROX_QUANTILES for skew
SELECT member_casual,
       ROUND(AVG(ride_length_min),1) AS avg_min,
       ROUND(APPROX_QUANTILES(ride_length_min,2)[OFFSET(1)],1) AS median_min,
       ROUND(MAX(ride_length_min),1) AS max_min
FROM cyclistic.trips_clean
GROUP BY member_casual;

-- 3. Rides & duration by day of week
SELECT day_num, day_of_week, member_casual,
       COUNT(*) AS rides, ROUND(AVG(ride_length_min),1) AS avg_min
FROM cyclistic.trips_clean
GROUP BY day_num, day_of_week, member_casual
ORDER BY day_num, member_casual;

-- 4. Rides by month (seasonality)
SELECT month_num, month_name, member_casual, COUNT(*) AS rides
FROM cyclistic.trips_clean
GROUP BY month_num, month_name, member_casual
ORDER BY month_num, member_casual;

-- 5. Weekday rides by hour (commute peaks)
SELECT start_hour, member_casual, COUNT(*) AS rides
FROM cyclistic.trips_clean
WHERE day_num BETWEEN 2 AND 6
GROUP BY start_hour, member_casual
ORDER BY start_hour, member_casual;

-- 6. Bike-type preference
SELECT rideable_type,
       COUNTIF(member_casual='casual') AS casual_rides,
       COUNTIF(member_casual='member') AS member_rides
FROM cyclistic.trips_clean
GROUP BY rideable_type
ORDER BY rideable_type;

-- 7. Casual riders' top 10 starting stations (where to target)
SELECT start_station_name, COUNT(*) AS casual_rides
FROM cyclistic.trips_clean
WHERE member_casual='casual' AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY casual_rides DESC
LIMIT 10;
