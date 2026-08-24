SELECT 
    EXTRACT(DAYOFWEEK FROM pickup_datetime) AS day_of_week,
    EXTRACT(HOUR FROM pickup_datetime) AS hour_of_day,
    COUNT(*) AS total_trips,
    ROUND(AVG(fare_amount), 2) AS avg_fare,
    ROUND(AVG(trip_distance), 2) AS avg_distance
FROM `nyc-taxi-data`
WHERE fare_amount > 0 AND trip_distance > 0
GROUP BY day_of_week, hour_of_day
ORDER BY total_trips DESC;

