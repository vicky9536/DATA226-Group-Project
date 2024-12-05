
  create or replace   view dev.analytics.negative_mag
  
   as (
    WITH cleaned_data AS (
    SELECT *
    FROM dev.analytics.duplicate_check
    WHERE mag >= 0
)

SELECT *
FROM cleaned_data
  );

