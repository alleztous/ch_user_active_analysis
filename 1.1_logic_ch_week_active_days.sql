/*
由于hive暂不支持多行注释，此版本不能直接复制到facade进行查询，主要用于gitlab作为示例展示。
看代码之前请先对照注释。

facade链接: 直接在开发机上创建表
*/
create table dm_strategy_test.ch_week_active_days(  
  -- 创建分区表，使用batch批量生成每日的数据
  device_id bigint,     
  week1_active_days int, week2_active_days int,      -- week*_active_days代表新增用户到了第*周的活跃天数  
  week3_active_days int, week4_active_days int,  
  week5_active_days int, week6_active_days int,  
  week7_active_days int, week8_active_days int,  
  week9_active_days int,  week10_active_days int,
  week11_active_days int, week12_active_days int, 
  week13_active_days int, week14_active_days int,  
  week15_active_days int, week16_active_days int,
  week1_duration int, week2_duration int,            -- week*_duration代表新增用户到了第*周的活跃时长
  week3_duration int, week4_duration int,  
  week5_duration int, week6_duration int,  
  week7_duration int, week8_duration int,  
  week9_duration int, week10_duration int,
  week11_duration int, week12_duration int, 
  week13_duration int, week14_duration int,  
  week15_duration int, week16_duration int) 
  partitioned by (p_date string)