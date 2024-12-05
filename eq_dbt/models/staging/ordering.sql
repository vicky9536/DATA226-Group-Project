with raw_data as (
    select * from {{ ref('rename_columns') }}
)

select
    event_time,
    latitude,
    longitude,
    depth_km,
    magnitude,
    magnitude_type,
    station_count,
    azimuthal_gap,
    min_distance_km,
    rms_residual,
    network,
    event_id,
    last_updated,
    location_description,
    event_type,
    horizontal_error_km,
    depth_error_km,
    magnitude_error,
    magnitude_station_count,
    processing_status,
    location_source,
    magnitude_source
from raw_data
order by
    event_time desc,
    magnitude desc
