with raw_data as (
    select * from dev.analytics.negative_mag
)

select
    time as event_time,
    latitude,
    longitude,
    depth as depth_km,
    mag as magnitude,
    magType as magnitude_type,
    nst as station_count,
    gap as azimuthal_gap,
    dmin as min_distance_km,
    rms as rms_residual,
    net as network,
    id as event_id,
    updated as last_updated,
    place as location_description,
    type as event_type,
    horizontalError as horizontal_error_km,
    depthError as depth_error_km,
    magError as magnitude_error,
    magNst as magnitude_station_count,
    status as processing_status,
    locationSource as location_source,
    magSource as magnitude_source
from raw_data