WITH categorized_earthquakes AS (
    SELECT
        event_time,
        magnitude,
        latitude,
        longitude,
        depth_km,
        magnitude_type,
        location_description,
        event_type,
        event_id,
        CASE 
            WHEN magnitude < 4.0 THEN 'Low'
            WHEN magnitude >= 4.0 AND magnitude < 6.0 THEN 'Moderate'
            ELSE 'High'
        END AS severity
    FROM dev.analytics.unique_id
)

SELECT *
FROM categorized_earthquakes
order by
    event_time desc