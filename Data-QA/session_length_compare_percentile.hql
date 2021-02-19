with tick_histogram as (
    select
        tick,
        count(1) as freq
    from event.mediawiki_client_session_tick
    where
        year=2021 and
        month=1 and
        day<22
    group by tick
    order by tick asc
    limit 1000
),
session_histogram_from_raw as (
    select
        one.tick as session_length,
        one.freq - coalesce(two.freq, 0) as freq
    from tick_histogram as one
    left join tick_histogram as two
    on one.tick + 1 = two.tick
),
session_histogram_from_intermediate as (
    select
        session_length,
        count(1) as freq
    from mforns.session_length
    where
        year=2021
    group by session_length
    order by session_length asc
    limit 1000
)
select
    coalesce(raw.session_length, itm.session_length) as session_length,
    coalesce(raw.freq, 0) as raw_freq,
    coalesce(itm.freq, 0) as itm_freq,
    coalesce(itm.freq, 0) - coalesce(raw.freq, 0) as offset
from session_histogram_from_raw as raw
full outer join session_histogram_from_intermediate as itm
    on raw.session_length = itm.session_length
;