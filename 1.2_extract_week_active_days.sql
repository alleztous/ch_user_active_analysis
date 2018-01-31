/*
由于hive暂不支持多行注释，此版本不能直接复制到facade进行查询，主要用于gitlab作为示例展示。
看代码之前请先对照注释。

本次query用到的表:
growth.m_device_activation -- 激活表，可提取当日新增用户的device_id。
growth.m_device_distinct_clean -- 活跃表，可提取每天所有用户的活跃信息。

facade链接: http://facade.byted.org/query_editor/edit/1588031
'${date}'从2017-10-01到2017-10-31
*/
INSERT INTO dm_strategy_test.ch_week_active_days PARTITION(p_date = '${DATE}')
SELECT
    device_id,
    sum(CASE week WHEN 1 THEN active_days ELSE 0 END) AS week1_active_days,
    sum(CASE week WHEN 2 THEN active_days ELSE 0 END) AS week2_active_days,
    sum(CASE week WHEN 3 THEN active_days ELSE 0 END) AS week3_active_days,
    sum(CASE week WHEN 4 THEN active_days ELSE 0 END) AS week4_active_days,
    sum(CASE week WHEN 5 THEN active_days ELSE 0 END) AS week5_active_days,
    sum(CASE week WHEN 6 THEN active_days ELSE 0 END) AS week6_active_days,
    sum(CASE week WHEN 7 THEN active_days ELSE 0 END) AS week7_active_days,
    sum(CASE week WHEN 8 THEN active_days ELSE 0 END) AS week8_active_days,
    sum(CASE week WHEN 9 THEN active_days ELSE 0 END) AS week9_active_days,
    sum(CASE week WHEN 10 THEN active_days ELSE 0 END) AS week10_active_days,
    sum(CASE week WHEN 11 THEN active_days ELSE 0 END) AS week11_active_days,
    sum(CASE week WHEN 12 THEN active_days ELSE 0 END) AS week12_active_days,
    sum(CASE week WHEN 13 THEN active_days ELSE 0 END) AS week13_active_days,
    sum(CASE week WHEN 14 THEN active_days ELSE 0 END) AS week14_active_days,
    sum(CASE week WHEN 15 THEN active_days ELSE 0 END) AS week15_active_days,
    sum(CASE week WHEN 16 THEN active_days ELSE 0 END) AS week16_active_days,
    sum(CASE week WHEN 1 THEN duration ELSE 0 END) AS week1_duration,
    sum(CASE week WHEN 2 THEN duration ELSE 0 END) AS week2_duration,
    sum(CASE week WHEN 3 THEN duration ELSE 0 END) AS week3_duration,
    sum(CASE week WHEN 4 THEN duration ELSE 0 END) AS week4_duration,
    sum(CASE week WHEN 5 THEN duration ELSE 0 END) AS week5_duration,
    sum(CASE week WHEN 6 THEN duration ELSE 0 END) AS week6_duration,
    sum(CASE week WHEN 7 THEN duration ELSE 0 END) AS week7_duration,
    sum(CASE week WHEN 8 THEN duration ELSE 0 END) AS week8_duration,
    sum(CASE week WHEN 9 THEN duration ELSE 0 END) AS week9_duration,
    sum(CASE week WHEN 10 THEN duration ELSE 0 END) AS week10_duration,
    sum(CASE week WHEN 11 THEN duration ELSE 0 END) AS week11_duration,
    sum(CASE week WHEN 12 THEN duration ELSE 0 END) AS week12_duration,
    sum(CASE week WHEN 13 THEN duration ELSE 0 END) AS week13_duration,
    sum(CASE week WHEN 14 THEN duration ELSE 0 END) AS week14_duration,
    sum(CASE week WHEN 15 THEN duration ELSE 0 END) AS week15_duration,
    sum(CASE week WHEN 16 THEN duration ELSE 0 END) AS week16_duration
FROM(
        SELECT
            g1.device_id AS device_id,
            week,
            duration,
            active_days
        FROM(
                --选择当日的新增用户
                SELECT
                    device_id
                FROM
                    growth.m_device_activation
                WHERE
                    p_date = '${DATE}'
                    AND from_id = 0
                    AND app_name = 'news_article'
            ) AS g1
            LEFT JOIN(
                --从活跃表中匹配新增用户随后16周的活跃天数与活跃时长
                SELECT
                    device_id,
                    sum(duration) AS duration,
                    COUNT(duration) AS active_days,
                    CEILING(DATEDIFF(p_date, '${DATE}')/7) AS week
                FROM
                    growth.m_device_distinct_clean
                WHERE
                    p_date BETWEEN '${DATE+1}'
                    AND '${DATE+112}' --一共分析16周的行为
                    AND duration is not null
                    AND (
                        duration > 0
                        or duration = 0
                    )
                    AND app_name = 'news_article'
                GROUP BY
                    device_id,
                    CEILING(DATEDIFF(p_date, '${DATE}')/7)
            ) AS g2 on g1.device_id = g2.device_id
    ) g3
GROUP BY
    device_id