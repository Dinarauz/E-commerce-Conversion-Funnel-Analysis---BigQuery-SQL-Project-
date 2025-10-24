-- See all ecommerce action types in your data
SELECT 
  ecommerce_action,
  COUNT(*) as action_count,
  COUNT(DISTINCT visitor_id) as unique_visitors
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`
WHERE ecommerce_action IS NOT NULL
GROUP BY ecommerce_action
ORDER BY ecommerce_action;

-- BASIC CONVERSION FUNNEL
SELECT
  COUNT(DISTINCT visitor_id) AS total_visitors,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '2' THEN visitor_id END) AS product_detail_views,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS add_to_cart,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '5' THEN visitor_id END) AS checkout,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS purchases
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`;


-- FUNNEL WITH CONVERSION RATES
WITH funnel_counts AS (
  SELECT
    COUNT(DISTINCT visitor_id) AS total_visitors,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '2' THEN visitor_id END) AS product_views,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS add_to_cart,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '5' THEN visitor_id END) AS checkout,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS purchases
  FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`
)

SELECT
  total_visitors,
  product_views,
  add_to_cart,
  checkout,
  purchases,
  
  -- Conversion rates (from previous stage)
  ROUND(product_views * 100.0 / total_visitors, 2) AS pct_viewed_product,
  ROUND(add_to_cart * 100.0 / product_views, 2) AS pct_added_to_cart,
  ROUND(checkout * 100.0 / add_to_cart, 2) AS pct_started_checkout,
  ROUND(purchases * 100.0 / checkout, 2) AS pct_completed_purchase,
  
  -- Overall conversion rate
  ROUND(purchases * 100.0 / total_visitors, 2) AS overall_conversion_rate

FROM funnel_counts;

-- CART ABANDONMENT ANALYSIS
SELECT
  COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS added_to_cart,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS purchased,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) - 
    COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS abandoned_cart,
  
  -- Cart abandonment rate
  ROUND(
    (COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) - 
     COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END)) * 100.0 /
    COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END), 2
  ) AS cart_abandonment_rate

FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`;

-- FUNNEL BY DEVICE TYPE
SELECT
  s.device_type,
  COUNT(DISTINCT h.visitor_id) AS total_visitors,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '2' THEN h.visitor_id END) AS product_views,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '3' THEN h.visitor_id END) AS add_to_cart,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) AS purchases,
  
  -- Conversion rate
  ROUND(
    COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) * 100.0 /
    COUNT(DISTINCT h.visitor_id), 2
  ) AS conversion_rate

FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened` h
JOIN `my-project-funnel-475721.funnel_analysis.ga_sessions_flattened` s
  ON h.visitor_id = s.visitor_id 
  AND h.session_id = s.session_id

GROUP BY s.device_type
ORDER BY conversion_rate DESC;

-- FUNNEL BY TRAFFIC SOURCE
SELECT
  s.traffic_source,
  COUNT(DISTINCT h.visitor_id) AS total_visitors,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) AS purchases,
  
  -- Conversion rate
  ROUND(
    COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) * 100.0 /
    COUNT(DISTINCT h.visitor_id), 2
  ) AS conversion_rate,
  
  -- Total revenue
  SUM(CASE WHEN h.ecommerce_action = '6' THEN h.transaction_revenue_micros / 1000000 END) AS total_revenue

FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened` h
JOIN `my-project-funnel-475721.funnel_analysis.ga_sessions_flattened` s
  ON h.visitor_id = s.visitor_id 
  AND h.session_id = s.session_id

GROUP BY s.traffic_source
HAVING total_visitors > 100  -- Only sources with meaningful traffic
ORDER BY conversion_rate DESC
LIMIT 10;

-- FUNNEL BY COUNTRY
SELECT
  s.country,
  COUNT(DISTINCT h.visitor_id) AS total_visitors,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) AS purchases,
  ROUND(
    COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) * 100.0 /
    COUNT(DISTINCT h.visitor_id), 2
  ) AS conversion_rate

FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened` h
JOIN `my-project-funnel-475721.funnel_analysis.ga_sessions_flattened` s
  ON h.visitor_id = s.visitor_id 
  AND h.session_id = s.session_id

GROUP BY s.country
HAVING total_visitors > 50
ORDER BY conversion_rate DESC
LIMIT 15;