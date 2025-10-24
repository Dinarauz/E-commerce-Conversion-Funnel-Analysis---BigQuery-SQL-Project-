SELECT
  s.browser,
  s.operating_system,
  COUNT(DISTINCT h.visitor_id) AS visitors,
  COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) AS purchases,
  ROUND(
    COUNT(DISTINCT CASE WHEN h.ecommerce_action = '6' THEN h.visitor_id END) * 100.0 /
    NULLIF(COUNT(DISTINCT h.visitor_id), 0), 2
  ) AS conversion_rate
FROM `my-project-funnel-475721.funnel_analysis.ga_hits_flattened` h
JOIN `my-project-funnel-475721.funnel_analysis.ga_sessions_flattened` s
  ON h.visitor_id = s.visitor_id AND h.session_id = s.session_id
WHERE s.device_type = 'mobile'
GROUP BY s.browser, s.operating_system
HAVING visitors > 100
ORDER BY conversion_rate DESC;