/*
由于hive暂不支持多行注释，此版本不能直接复制到facade进行查询，主要用于gitlab作为示例展示。
看代码之前请先对照注释。

facade链接: 直接在开发机上创建表
*/
create table dm_strategy_test.ch_week_active_days_user_basic_feature(  
  -- 创建分区表，使用batch批量生成每日的数据
  device_id bigint,     
  city int,
  os int,
  os_version int,
  resolution int,
  brand int,
  model string,
  channel_category int,
  age int,
  gender int,
  app_name string) 
  partitioned by (p_date string)

 
create table dm_strategy_test.ch_week_active_days_user_basic_feature(  
  -- 创建分区表，使用batch批量生成每日的数据
  device_id bigint,     
  city int,
  province int,
  os int,
  resolution int,
  app_version int,
  brand int,
  model string,
  channel_category int,
  age int,
  gender int,
  app_name string) 
  partitioned by (p_date string)  

