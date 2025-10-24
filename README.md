# E-commerce Conversion Funnel Analysis - BigQuery SQL Project
<img width="1920" height="1080" alt="Google Analytics Funnel Analysis" src="https://github.com/user-attachments/assets/9a08c145-d81f-4ebc-8f58-fd9ef25f3754" />

In this project I utilized BigQuery SQL to see how customers move through an online store's purchase process from browsing to buying.

## What this project is about:
I analyzed a year's worth of Google Merchandise Store data (900K+ sessions) to understand why people leave without buying or how many % of people ended buying. 

## Questions I wanted to answer:
1. How many visitors actually end up buying something?
2. At what point do most people leave the site?
3. Does mobile vs desktop make a difference?
4. How bad is the cart abondonment problem ?

## What I found:
1. Only 1.4% of visitors actually end up buying something (which is kind of low!)
2. 74.84% of people who add items to cart don't complete the purchase (huge problem)
3. Mobile users convert 43% worse than desktop users - meaning there must be something wrong with the mobile experience.

## The Numbers:
1. Total Sessions : 903,653
2. Unique Visitors: 714,167
3. Purchases: 9,988 people 
5. Total Revenue: $4.98 M

## Funnel Analysis Overview
All Visitors        → 714,167 (100%)    ← Everyone who visited
Product Views       → 233,685 (32.73%)  ← Looked at a product
Add to Cart         → 39,882 (5.59%)    ← Added something to cart
Begin Checkout      → 16,869 (2.36%)    ← Started checkout
Complete Purchase   → 9,988 (1.40%)     ← Actually bought

## Device Breakdown
• **Desktop**: 1.73% conversion rate
• **Tablet**: 1.27% conversion rate
• **Mobile**: 0.99% conversion rate

## How I built this project

**Things I have used:**
1. **DataSet**: Google Analytics Sample Data - Free Dataset from Google (https://console.cloud.google.com/marketplace/product/obfuscated-ga360-data/obfuscated-ga360-data?project=my-project-funnel-475721)
2. BigQuery SQL - I did all the analysis there
3. Power BI - created the dashboards to visualize my project

**Things I learned:**
• **Nested Data** - Had to "unnest" arrays (lists of things stored in one row)
• **Struct fields** - Like folders within folders (device.browser instead of just browser)
• **Wildcard Tables** - Query multiple tables at once with ga_sessions_*

## Challenges: 
The raw data was super nested - one session could have 100+ hits (pageviews, clicks, etc.) all stored in arrays. Had to flatten everything into separate tables first before I could analyze it properly.

## Some SQL I Wrote:

**Finding Who Bought vs. Who just Browsed**
-- This creates the funnel stages for each visitor
WITH funnel_stages AS (
  SELECT 
    visitor_id,
    MAX(CASE WHEN ecommerce_action = '2' THEN 1 END) AS viewed_product,
    MAX(CASE WHEN ecommerce_action = '3' THEN 1 END) AS added_to_cart,
    MAX(CASE WHEN ecommerce_action = '6' THEN 1 END) AS purchased
  FROM ga_hits_flattened
  GROUP BY visitor_id
)
-- Then count how many people reached each stage
SELECT 
  COUNT(*) as total_visitors,
  SUM(viewed_product) as looked_at_products,
  SUM(added_to_cart) as put_in_cart,
  SUM(purchased) as actually_bought
FROM funnel_stages;

**Calculating Cart Abandonment by Device:**
-- Who adds to cart but doesn't buy? Let's check by device
SELECT 
  device_type,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) AS added_to_cart,
  COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END) AS purchased,
  -- Calculate abandonment rate
  ROUND(
    (COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END) - 
     COUNT(DISTINCT CASE WHEN ecommerce_action = '6' THEN visitor_id END)) * 100.0 /
    COUNT(DISTINCT CASE WHEN ecommerce_action = '3' THEN visitor_id END), 2
  ) AS abandonment_rate
FROM ga_hits_flattened h
JOIN ga_sessions_flattened s USING(visitor_id, session_id)
GROUP BY device_type;

## Dashboard






