WITH deduplicated_data AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY event_time DESC) AS row_num
    FROM {{ ref('ordering') }}
)
SELECT *
FROM deduplicated_data
WHERE row_num = 1
