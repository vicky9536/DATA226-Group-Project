select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        processing_status as value_field,
        count(*) as n_records

    from dev.analytics.data_reliability_check
    group by processing_status

)

select *
from all_values
where value_field not in (
    'automatic','reviewed'
)



      
    ) dbt_internal_test