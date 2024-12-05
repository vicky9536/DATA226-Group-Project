
    
    

select
    event_id as unique_field,
    count(*) as n_records

from dev.analytics.data_reliability_check
where event_id is not null
group by event_id
having count(*) > 1


