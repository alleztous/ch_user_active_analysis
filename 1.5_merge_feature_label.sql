-- 检查device_id数量是否相同

select
    count(*)
from
    dm_strategy_test.ch_week_active_days
where
    p_date = '2017-10-01'



select
    count(*)
from
    dm_strategy_test.ch_week_active_days_user_basic_feature
where
    p_date = '2017-10-01'
    and app_name = 'news_article'

select count(*) from dm_strategy_test.ch_week_active_days_basic_feature_label_res1


create table dm_strategy_test.ch_week_active_days_basic_feature_label_res1 AS
SELECT
    ch1.device_id AS device_id,
    ch1.week1_active_days AS week1_active_days, ch1.week2_active_days AS week2_active_days,
    ch1.week3_active_days AS week3_active_days, ch1.week4_active_days AS week4_active_days,
    ch1.week5_active_days AS week5_active_days, ch1.week6_active_days AS week6_active_days,
    ch1.week7_active_days AS week7_active_days, ch1.week8_active_days AS week8_active_days,
    ch1.week9_active_days AS week9_active_days, ch1.week10_active_days AS week10_active_days,
    ch1.week11_active_days AS week11_active_days, ch1.week12_active_days AS week12_active_days,
    ch1.week13_active_days AS week13_active_days, ch1.week14_active_days AS week14_active_days,
    ch1.week15_active_days AS week15_active_days, ch1.week16_active_days AS week16_active_days,   
    ch1.week1_duration AS week1_duration, ch1.week2_duration AS week2_duration,
    ch1.week3_duration AS week3_duration, ch1.week4_duration AS week4_duration,
    ch1.week5_duration AS week5_duration, ch1.week6_duration AS week6_duration,
    ch1.week7_duration AS week7_duration, ch1.week8_duration AS week8_duration,
    ch1.week9_duration AS week9_duration, ch1.week10_duration AS week10_duration,
    ch1.week11_duration AS week11_duration, ch1.week12_duration AS week12_duration,
    ch1.week13_duration AS week13_duration, ch1.week14_duration AS week14_duration,
    ch1.week15_duration AS week15_duration, ch1.week16_duration AS week16_duration, 
	ch2.city AS city, ch2.os AS os, ch2.os_version AS os_version,
    ch2.brand AS brand ,ch2.model AS model ,ch2.channel_category AS channel_category,
    ch2.age AS age, ch2.gender AS gender
FROM(
        SELECT
            *
        from
            dm_strategy_test.ch_week_active_days
        WHERE
            p_date = 
    ) ch1
    LEFT JOIN(
        SELECT
            *
        FROM
            dm_strategy_test.ch_week_active_days_user_basic_feature
        WHERE
            p_date = '2017-10-01'
            AND app_name = 'news_article'
    ) ch2 on ch1.device_id = ch2.device_id


-- test
select
    *
from
    dm_strategy_test.ch_week_active_days_user_basic_feature
where
    p_date = '2017-10-01'
limit
    100

-- test
select * from dm_strategy_test.ch_inner_join_test_a
select * from dm_strategy_test.ch_inner_join_test_b
-- join
select * from dm_strategy_test.ch_inner_join_test_a as a inner join dm_strategy_test.ch_inner_join_test_b as b on a.s_number = b.s_number 
select a.s_number,b.s_number,a.content,b.content from dm_strategy_test.ch_inner_join_test_a as a inner join dm_strategy_test.ch_inner_join_test_b as b on a.s_number = b.s_number 

