/*
由于hive暂不支持多行注释，此版本不能直接复制到facade进行查询，主要用于gitlab展示。
看代码之前请先对照注释。

2017-10-01号新增用户的（设备id、城市、手机操作系统、手机品牌、性别、年龄等）
本次取数日期基于2017-10-01，基础属性一般都可以取单天的，因为基础属性比较稳定，可在注册日期进行提取。
注: 性别与年龄可以取分析的日期最后一天

本次取数用到的表:
growth.m_device_activation -- 激活表，可提取当日新增用户的device_id。
growth.o_pgl_channel_all -- 渠道关系表，可根据device_id获取激活渠道、激活厂商等信息
dm_strategy.m_device_level_impression -- 展现表，天汇总展现
dm_strategy.device_user_age_gender -- 用户年龄、性别表

facade链接: http://facade.byted.org/query_editor/edit/1588903
*/
insert into dm_strategy_test.ch_week_active_days_user_basic_feature PARTITION(p_date = '${DATE}')
SELECT
/*
device_id,app_name,os,os_version,city,
province,app_version,model,brand,resolution
*/
    a.device_id as device_id,
     
    -- 城市分级（0代表缺失或空值），具体见如下链接：
    -- https://baike.baidu.com/item/%E4%B8%AD%E5%9B%BD%E5%9F%8E%E5%B8%82%E6%96%B0%E5%88%86%E7%BA%A7%E5%90%8D%E5%8D%95/12702007?fr=aladdin  
    -- 由于城市粒度已经分得比较细了，所以放弃省份特征。
    case 
    when city is null or city = '' then -1
    when city in ('北京','上海','广州','深圳') then 1
    when city in ('成都','杭州','武汉','重庆','南京','天津','苏州','西安','长沙','沈阳','青岛','郑州','大连','东莞','宁波') then 2 
    when city in ('厦门','福州','无锡','合肥','昆明','哈尔滨','济南','佛山','长春','温州','石家庄','南宁','常州','泉州','南昌','贵阳','太原','烟台','嘉兴','南通','金华','珠海','惠州','徐州','海口','乌鲁木齐','绍兴','中山','台州','兰州') then 3 
    when city in ('潍坊','保定','镇江','扬州','桂林','唐山','三亚','湖州','呼和浩特','廊坊','洛阳','威海','盐城','临沂','江门','汕头','泰州','漳州','邯郸','济宁','芜湖','淄博','银川','柳州','绵阳','湛江','鞍山','赣州','大庆','宜昌','包头','咸阳','秦皇岛','株洲','莆田','吉林','淮安','肇庆','宁德','衡阳','南平','连云港','丹东','丽江','揭阳','延边朝鲜族自治州','舟山','九江','龙岩','沧州','抚顺','襄阳','上饶','营口','三明','蚌埠','丽水','岳阳','清远','荆州','泰安','衢州','盘锦','东营','南阳','马鞍山','南充','西宁','孝感','齐齐哈尔') then 4 
    when city in ('乐山','湘潭','遵义','宿迁','新乡','信阳','滁州','锦州','潮州','黄冈','开封','德阳','德州','梅州','鄂尔多斯','邢台','茂名','大理白族自治州','韶关','商丘','安庆','黄石','六安','玉林','宜春','北海','牡丹江','张家口','梧州','日照','咸宁','常德','佳木斯','红河哈尼族彝族自治州','黔东南苗族侗族自治州','阳江','晋中','渭南','呼伦贝尔','恩施土家族苗族自治州','河源','郴州','阜阳','聊城','大同','宝鸡','许昌','赤峰','运城','安阳','临汾','宣城','曲靖','西双版纳傣族自治州','邵阳','葫芦岛','平顶山','辽阳','菏泽','本溪','驻马店','汕尾','焦作','黄山','怀化','四平','榆林','十堰','宜宾','滨州','抚州','淮南','周口','黔南布依族苗族自治州','泸州','玉溪','眉山','通化','宿州','枣庄','内江','遂宁','吉安','通辽','景德镇','阜新','雅安','铁岭','承德','娄底') then 5
    when city in ('克拉玛依','长治','永州','绥化','巴音郭楞蒙古自治州','拉萨','云浮','益阳','百色','资阳','荆门','松原','凉山彝族自治州','达州','伊犁哈萨克自治州','广安','自贡','汉中','朝阳','漯河','钦州','贵港','安顺','鄂州','广元','河池','鹰潭','乌兰察布','铜陵','昌吉回族自治州','衡水','黔西南布依族苗族自治州','濮阳','锡林郭勒盟','巴彦淖尔','鸡西','贺州','防城港','兴安盟','白山','三门峡','忻州','双鸭山','楚雄彝族自治州','新余','来宾','淮北','亳州','湘西土家族苗族自治州','吕梁','攀枝花','晋城','延安','毕节','张家界','酒泉','崇左','萍乡','乌海','伊春','六盘水','随州','德宏傣族景颇族自治州','池州','黑河','哈密','文山壮族苗族自治州','阿坝藏族羌族自治州','天水','辽源','张掖','铜仁','鹤壁','儋州','保山','安康','白城','巴中','普洱','鹤岗','莱芜','阳泉','甘孜藏族自治州','嘉峪关','白银','临沧','商洛','阿克苏地区','海西蒙古族藏族自治州','大兴安岭地区','七台河','朔州','铜川','定西','迪庆藏族自治州','日喀则','庆阳','昭通','喀什地区','怒江傈僳族自治州','海东','阿勒泰地区','平凉','石嘴山','武威','阿拉善盟','塔城地区','林芝','金昌','吴忠','中卫','陇南','山南','吐鲁番','博尔塔拉蒙古自治州','临夏回族自治州','固原','甘南藏族自治州','昌都','阿里地区','海南藏族自治州','和田地区','克孜勒苏柯尔克孜自治州','海北藏族自治州','那曲地区','玉树藏族自治州','黄南藏族自治州','果洛藏族自治州','三沙') then 6
    else 0
    end as city,  
    
    case 
    when os is null or os = '' then -1
    when os = 'android' then 1
    when os = 'ios' then 2
    else 0 end as os, --手机操作系统
   
    case os 
    when 'android' then round(cast(substr(os_version, 1, 3) as double) + 3, 1) 
    else round(cast(substr(os_version, 1, 3) as double), 1) end as os_version,   --手机操作系统版本

    case
    when substr(resolution, 1, 2) in ('27', '26', '25', '24', '23', '22', '21', '20') then 6 
    when substr(resolution, 1, 2) in ('19', '18', '17', '16') then 5 
    when substr(resolution, 1, 2) in ('15', '14', '13', '12', '11', '10') then 4 
    when substr(resolution, 1, 2) in ('98', '97', '96', '95', '94', '93', '92') then 3
    when substr(resolution, 1, 2) in ('89', '88', '87', '86', '85', '84', '80') then 2 
    when substr(resolution, 1, 2) in ('78', '55', '64') then 1 else 0 end as resolution,  --手机分辨率

    --根据中国手机市场的手机占有率细分手机品牌（0代表缺失或空值），具体见如下链接：
    --http://money.163.com/17/0726/13/CQ997T45002580S6.html
    case 
    when brand is null or brand = '' then 0
    when brand = '华为' then 1 when brand = 'oppo' then 2 when brand = 'vivo' then 3
    when brand = '小米' then 4 when brand = '苹果' then 5 when brand = '三星' then 6
    else 7 end as brand,

    model,

    case channel_account_subclass  -- 区分不同的频道来源
    when 'AppStore' then 12
    when 'CP付费' then 11
    when '主流商店' then 10 
    when '厂商商店' then 9 
    when '厂商预装' then 8 
    when 'Wap产品' then 7 
    when '展示类广告' then 6 
    when '搜索引擎广告' then 5 
    when '方案商' then 4
    when '越狱商店' then 3 
    when '运营商' then 2
    when '刷机商' then 1 
    else 0 end as channel_category,   --频道来源(重新定义类别变量)

    case                              -- 用户年龄离散化 
    when age is null or age = '' then 0
    when age = '-18' then 1 
    when age = '18-23' then 2 
    when age = '24-30' then 3 
    when age = '31-40' then 4 
    when age = '41-50' then 5 
    when age = '50-' then 6 
    else user_age_gender.age end as age,             

    case                              -- 用户性别离散化
    when gender is null or gender = '' then 0 
    when gender = 'male' then 1 
    when gender = 'female' then 2 
    else user_age_gender.gender end as gender,

    a.app_name as app_name

from
    (
        SELECT
            -- 求2017.05.01号新增用户的设备id、app、激活渠道
            device_id,
            app_name,     
            CASE WHEN TRIM(channel) NOT IN (  
                '2345001',
                '2345002',
                '2345003',
                '2345004',
                '2345005'
            )
            AND TRIM(channel) like '2345%' THEN '2345' ELSE TRIM(channel) END AS activation_channel
        FROM
            growth.m_device_activation -- table 1 
        WHERE
            p_date = '${DATE}'      
            and from_id = 0
            and app_name in (
                'news_article',
                'news_article_lite',
                'video_article'
            )
    ) a
    left join (
        -- 通过join匹配出app、激活渠道对应的平台类型
        SELECT
            channel_name,
            app_name,
            channel_account_subclass
        FROM
            growth.o_pgl_channel_all -- table 2 
        WHERE
            date = '${date}'
            and app_name in (
                'news_article',
                'news_article_lite',
                'video_article'
            )
      )b on a.activation_channel = b.channel_name
    and a.app_name = b.app_name

   left join (
        select
        -- 通过join匹配出用户的操作系统、版本、省份、城市、手机品牌、分辨率等特征。
            distinct device_id,
            app_name,
            os,
            os_version,
            city,
            province,
            app_version,
            model,
            brand,
            resolution
        from
            dm_strategy.m_device_level_impression  -- table 3
        where
            date = '${date}'
            and app_name in (
                'news_article',
                'news_article_lite',
                'video_article'
            )
    ) c on a.device_id = c.device_id
    and a.app_name = c.app_name

    left join (
    -- 加入了用户性别特征
        select
            device_id,
            uid,
            ut,
            age,
            gender,
            app_id,
            
            case 
            when app_id = '13' then 'news_article' 
            when app_id = '32' then 'video_article' 
            when app_id = '35' then 'news_article_lite' 
            end as app_name
            
        from
            dm_strategy.device_user_age_gender    
        where
            date = '${date+112}'
            and app_id in ('13', '32', '35')
    ) d on a.device_id = d.device_id
    and a.app_name = d.app_name