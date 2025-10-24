-- DETAILED FUNNEL WITH STAGE-BY-STAGE CONVERSION
WITH funnel AS (
  SELECT
    COUNT(DISTINCT visitor_id) AS total_visitors,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '2' THEN visitor_id END) AS product_views,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS add_to_cart,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '5' THEN visitor_id END) AS checkout,
    COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS purchases
  FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened`
)

SELECT
  'Total Visitors' AS stage,
  total_visitors AS visitors,
  NULL AS conversion_from_previous,
  100.0 AS percent_of_total
FROM funnel

UNION ALL

SELECT
  'Product Detail View' AS stage,
  product_views AS visitors,
  ROUND(SAFE_DIVIDE(product_views * 100.0, total_visitors), 2) AS conversion_from_previous,
  ROUND(SAFE_DIVIDE(product_views * 100.0, total_visitors), 2) AS percent_of_total
FROM funnel

UNION ALL

SELECT
  'Add to Cart' AS stage,
  add_to_cart AS visitors,
  ROUND(SAFE_DIVIDE(add_to_cart * 100.0, product_views), 2) AS conversion_from_previous,
  ROUND(SAFE_DIVIDE(add_to_cart * 100.0, total_visitors), 2) AS percent_of_total
FROM funnel

UNION ALL

SELECT
  'Checkout' AS stage,
  checkout AS visitors,
  ROUND(SAFE_DIVIDE(checkout * 100.0, add_to_cart), 2) AS conversion_from_previous,
  ROUND(SAFE_DIVIDE(checkout * 100.0, total_visitors), 2) AS percent_of_total
FROM funnel

UNION ALL

SELECT
  'Purchase' AS stage,
  purchases AS visitors,
  ROUND(SAFE_DIVIDE(purchases * 100.0, checkout), 2) AS conversion_from_previous,
  ROUND(SAFE_DIVIDE(purchases * 100.0, total_visitors), 2) AS percent_of_total
FROM funnel

ORDER BY percent_of_total DESC;
```

This will show you a nice table like:
```
Stage                   | Visitors  | Conversion from Previous | % of Total
------------------------|-----------|--------------------------|------------
Total Visitors          | 712,272   | -                        | 100%
Product Detail View     | 98,941    | 13.9%                    | 13.9%
Add to Cart             | 39,700    | 40.1%                    | 5.6%
Checkout                | 18,209    | 45.9%                    | 2.6%
Purchase                | 9,988     | 54.8%                    | 1.4%