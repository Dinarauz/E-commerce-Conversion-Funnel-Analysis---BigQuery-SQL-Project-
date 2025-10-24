SELECT
  'Total Visitors' AS funnel_stage,
  1 AS stage_order,
  COUNT(DISTINCT visitor_id) AS visitors
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`

UNION ALL

SELECT
  'Product Views' AS funnel_stage,
  2 AS stage_order,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '2' THEN visitor_id END) AS visitors
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`

UNION ALL

SELECT
  'Add to Cart' AS funnel_stage,
  3 AS stage_order,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS visitors
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`

UNION ALL

SELECT
  'Checkout' AS funnel_stage,
  4 AS stage_order,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '5' THEN visitor_id END) AS visitors
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`

UNION ALL

SELECT
  'Purchase' AS funnel_stage,
  5 AS stage_order,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS visitors
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`

ORDER BY stage_order;