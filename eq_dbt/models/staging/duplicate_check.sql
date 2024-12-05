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
    FROM {{ ref('null_value_check') }}
)
SELECT *
FROM deduplicated_rows
