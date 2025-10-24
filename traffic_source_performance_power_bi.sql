SELECT
  s.traffic_source,
  s.traffic_medium,
  COUNT(DISTINCT h.visitor_id) AS total_visitors,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) AS purchases,
  ROUND(
    COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) * 100.0 /
    NULLIF(COUNT(DISTINCT h.visitor_id), 0), 2
  ) AS conversion_rate,
  SUM(CASE WHEN h.ecommerce_action = '6' THEN h.transaction_revenue_micros / 1000000 END) AS total_revenue
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened` h
JOIN `my-project-funnel-475721.funnel_analysis.ga_sessions_flattened` s
  ON h.visitor_id = s.visitor_id AND h.session_id = s.session_id
GROUP BY s.traffic_source, s.traffic_medium
HAVING total_visitors > 50
ORDER BY conversion_rate DESC
LIMIT 20;