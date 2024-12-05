
  create or replace   view dev.analytics.null_value_check
  
   as (
    SELECT *
FROM dev.raw_data.earthquake_data
WHERE latitude IS NOT NULL
  AND longitude IS NOT NULL
  AND depth IS NOT NULL
  AND mag IS NOT NULL
  AND id IS NOT NULL     
  AND magType IS NOT NULL
  AND nst IS NOT NULL
  AND gap IS NOT NULL
  AND dmin IS NOT NULL
  AND rms IS NOT NULL
  AND net IS NOT NULL
  AND updated IS NOT NULL
  AND place IS NOT NULL
  AND type IS NOT NULL
  AND horizontalError IS NOT NULL
  AND depthError IS NOT NULL
  AND magError IS NOT NULL
  AND magNst IS NOT NULL
  AND status IS NOT NULL
  AND locationSource IS NOT NULL
  AND magSource IS NOT NULL
  );

