
  create or replace   view dev.analytics.duplicate_check
  
   as (
    WITH deduplicated_rows AS (
    SELECT DISTINCT
        time,
        latitude,
        longitude,
        depth,  
        mag,
        magType,
        nst,
        gap,
        dmin,
        rms,
        net,
        id,
        updated,
        place,
        type,
        horizontalError,
        depthError,
        magError,
        magNst,
        status,
        locationSource,
        magSource
    FROM dev.analytics.null_value_check
)
SELECT *
FROM deduplicated_rows
  );
