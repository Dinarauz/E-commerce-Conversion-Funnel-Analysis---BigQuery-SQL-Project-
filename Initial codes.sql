-- see data
SELECT *
FROM bigquery-public-data.google_analytics_sample.ga_sessions_20170801

-- column names
SELECT column_name, data_type
FROM `bigquery-public-data.google_analytics_sample.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'ga_sessions_20170801'
ORDER BY ordinal_position;

SELECT *
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
LIMIT 5;

--create schema
CREATE SCHEMA IF NOT EXISTS `my-project-funnel-475721.funnel_analysis`;

--create ga_sessions flattened version
CREATE OR REPLACE TABLE `my-project-funnel-475721.funnel_analysis.ga_sessions_flattened` AS

SELECT
  -- Visitor & Session IDs
  fullVisitorId AS visitor_id,
  visitId AS session_id,
  visitNumber AS visit_number,
  
  -- Date & Time
  PARSE_DATE('%Y%m%d', date) AS session_date,
  TIMESTAMP_SECONDS(visitStartTime) AS session_start_timestamp,
  
  -- Channel & Traffic Source
  channelGrouping AS channel_group,
  trafficSource.source AS traffic_source,
  trafficSource.medium AS traffic_medium,
  trafficSource.campaign AS campaign_name,
  trafficSource.keyword AS search_keyword,
  
  -- Device Information
  device.deviceCategory AS device_type,
  device.browser AS browser,
  device.operatingSystem AS operating_system,
  device.isMobile AS is_mobile,
  
  -- Geography
  geoNetwork.country AS country,
  geoNetwork.region AS region,
  geoNetwork.city AS city,
  
  -- Session Metrics
  totals.visits AS total_visits,
  totals.hits AS total_hits,
  totals.pageviews AS total_pageviews,
  totals.timeOnSite AS time_on_site_seconds,
  totals.bounces AS bounces,
  totals.transactions AS transactions,
  totals.transactionRevenue AS transaction_revenue_micros,
  totals.newVisits AS new_visits,
  
  -- Social Engagement
  socialEngagementType AS social_engagement_type

FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`

WHERE
  -- Get full year of data (Aug 2016 - Jul 2017)
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170731';

  CREATE OR REPLACE TABLE `my-project-funnel-475721.funnel_analysis.ga_hits_flattened` AS

SELECT
  -- Session identifiers
  fullVisitorId AS visitor_id,
  visitId AS session_id,
  PARSE_DATE('%Y%m%d', date) AS session_date,
  
  -- Hit information
  hit.hitNumber AS hit_number,
  hit.type AS hit_type,
  hit.time AS hit_time_milliseconds,
  hit.isEntrance AS is_entrance,
  hit.isExit AS is_exit,
  
  -- Page information
  hit.page.pagePath AS page_path,
  hit.page.pageTitle AS page_title,
  
  -- E-commerce action (THIS IS KEY FOR FUNNEL!)
  hit.eCommerceAction.action_type AS ecommerce_action,
  
  -- Event information
  hit.eventInfo.eventCategory AS event_category,
  hit.eventInfo.eventAction AS event_action,
  hit.eventInfo.eventLabel AS event_label,
  
  -- Transaction information
  hit.transaction.transactionId AS transaction_id,
  hit.transaction.transactionRevenue AS transaction_revenue_micros

FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS hit

WHERE
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170731';

  CREATE OR REPLACE TABLE `my-project-funnel-475721.funnel_analysis.ga_products_flattened` AS

SELECT
  -- Session identifiers
  fullVisitorId AS visitor_id,
  visitId AS session_id,
  PARSE_DATE('%Y%m%d', date) AS session_date,
  hit.hitNumber AS hit_number,
  
  -- Product information
  product.productSKU AS product_sku,
  product.v2ProductName AS product_name,
  product.v2ProductCategory AS product_category,
  product.productQuantity AS product_quantity,
  product.productRevenue AS product_revenue_micros,
  product.isClick AS is_product_click,
  product.isImpression AS is_product_impression,
  
  -- E-commerce action
  hit.eCommerceAction.action_type AS ecommerce_action

FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS hit,
  UNNEST(hit.product) AS product

WHERE
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170731'
  AND product.productSKU IS NOT NULL;

  SELECT *
  FROM my-project-funnel-475721.funnel_analysis.ga_hits_flattened

    SELECT *
  FROM my-project-funnel-475721.funnel_analysis.ga_products_flattened

  SELECT *
  FROM my-project-funnel-475721.funnel_analysis.ga_sessions_flattened


  -- Basic Conversion Funnel
SELECT
  COUNT(DISTINCT visitor_id) AS total_visitors,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '2' THEN visitor_id END) AS product_detail_views,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS add_to_cart,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '5' THEN visitor_id END) AS checkout,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS purchases
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`;