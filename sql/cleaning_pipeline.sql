SELECT 
    vendor_id, 
    pickup_datetime, 
    dropoff_datetime, 
    passenger_count, 
    trip_distance, 
    fare_amount 
FROM `nyc-taxi-data` 
WHERE fare_amount > 0 
  AND trip_distance > 0 
  AND passenger_count BETWEEN 1 AND 6;

