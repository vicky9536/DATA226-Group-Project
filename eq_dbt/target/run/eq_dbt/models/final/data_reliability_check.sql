
  
    

        create or replace transient table dev.analytics.data_reliability_check
         as
        (with raw_data as (
    select * from dev.analytics.unique_id
)

select
    event_time,
    latitude,
    longitude,
    magnitude,
    location_description,
    station_count,   -- higher number increases the confidence
    azimuthal_gap,   -- smaller gaps indicate better coverage by stations
    min_distance_km, -- dist between epicenter and the nearest station, shorter the better
    rms_residual,    -- root mean square of residuals, lower the better
    horizontal_error_km,     -- the uncertainty in horizontal loc, smaller the better
    depth_error_km,          -- uncertainty in depth, smaller the better
    magnitude_error,         -- smaller the better
    magnitude_station_count, -- higher the better
    processing_status,       -- reviewed > automatic
    location_source,
    magnitude_source,
    event_id,
    (station_count + magnitude_station_count) as tot_station_cnt,
    (azimuthal_gap + min_distance_km + rms_residual + horizontal_error_km + depth_error_km + magnitude_error) as reliability_index
from raw_data
order by
    event_time desc
        );
      
  