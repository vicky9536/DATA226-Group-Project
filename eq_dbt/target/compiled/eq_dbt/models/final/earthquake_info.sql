with raw_data as (
    select * from dev.analytics.mag_binning
)

select
    event_time,
    magnitude,
    latitude,
    longitude,
    depth_km,
    magnitude_type,
    location_description,
    severity,
    event_type,
    event_id,
from raw_data
order by
    event_time desc