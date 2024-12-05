select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select magnitude
from dev.analytics.earthquake_info
where magnitude is null



      
    ) dbt_internal_test