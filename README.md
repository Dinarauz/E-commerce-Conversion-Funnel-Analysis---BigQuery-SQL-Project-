# E-commerce Conversion Funnel Analysis for Google Merchandise Store using BigQuery SQL
<img width="1920" height="1080" alt="Google Analytics Funnel Analysis" src="https://github.com/user-attachments/assets/9a08c145-d81f-4ebc-8f58-fd9ef25f3754" />

In this project I analyzed 900K+ sessions using BigQuery SQL to see how customers move through an online store's purchase process from browsing to buying.

## Business Problem:
The Google Merchandise Store (like most e-commerce sites) was losing potential customers somewhere between landing on the site and completing a purchase. They needed to understand: 

## Questions I wanted to answer:
1. How many visitors actually end up buying something?
2. Where exactly are we losing customers in the purchase journey?
3. Does mobile vs desktop make a difference?
4. How bad is the cart abondonment problem ?
5. Which countries makes the most profit?
6. What are top traffic sources?

**What I'm solving:** Identifying the specific drop-off points in the conversion funnel and quantifying the revenue impact of fixing them.

## Key Insights:
1. Massive drop-off at product view - 67% of visitors never even look at a product page
2. Mobile is broken - Mobile converts at 0.99% vs desktop's 1.73% (43% worse)
3. Cart abandonment crisis - 74.84% of people who add items don't complete purchase
4. Direct traffic converts best - 2.3% conversion rate vs 0.8% for social media
5. Checkout is the killer - We lose 41% of users between cart and starting checkout
6. Geographic Spread - Customers from 200+ countries, with US dominating

## Business Recommendations
1. **Need to fix mobile experience immediately**
   • Mobile is 42% of traffic but only 23% of revenue
   • We need to focus on site speed and simplified navigation
2. **Simplify checkout process**
   • Reduce from 5 steps to 2-3 steps
   • Add guest checkout option (no forced account creation)
   
## The Numbers:
1. **Total Sessions:** 903,653
2. **Unique Visitors:** 714,167
3. **Purchases:** 9,988 people 
5. **Total Revenue:** $4.98 M

## Funnel Analysis Overview
All Visitors        → 712,272 (100%)    ← Everyone who visited
Product Views       → 233,685 (32.73%)  ← Looked at a product
Add to Cart         → 39,8820 (5.59%)    ← Added something to cart
Begin Checkout      → 16,869 (2.36%)    ← Started checkout
Complete Purchase   → 9,988 (1.40%)     ← Actually bought

## Device Breakdown
• **Desktop**: 1.73% conversion rate
• **Tablet**: 0.66% conversion rate
• **Mobile**: 0.49% conversion rate

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

## Dashboard - Built an interactive Power BI dashboard with:
<img width="711" height="540" alt="image" src="https://github.com/user-attachments/assets/d26e6cec-ab94-4702-b413-0063b3aaca7f" />

1. Funnel visualization showing where people drop off
2. Device comparison charts (mobile vs desktop performance) <img width="947" height="541" alt="image" src="https://github.com/user-attachments/assets/7f10bf5f-ebd4-417f-bed9-a59f798829bd" />

3. Traffic source breakdown (where visitors come from) <img width="947" height="540" alt="image" src="https://github.com/user-attachments/assets/9b56459f-2846-4bbb-92d1-e362500a530c" />

4. Time trends (when do people buy?) <img width="947" height="540" alt="image" src="https://github.com/user-attachments/assets/4efc2737-a436-4605-a9ac-3df92e52ac6b" />

5. Key metrics cards for quick insights

## About the Data
**Using Google's public Analytics dataset:**
• **Time Period:** 1 full year (Aug 2016 - Jul 2017)
• **Size:** 900K+ sessions, 80M+ individual actions
• **Source:** Google Analytics Sample Dataset(https://console.cloud.google.com/marketplace/product/obfuscated-ga360-data/obfuscated-ga360-data)

## How to Run This
1. Get access to BigQuery (Google Cloud - it's free for queries under 1TB)
2. Find the dataset or you can use my code here (https://github.com/Dinarauz/E-commerce-Conversion-Funnel-Analysis---BigQuery-SQL-Project-/blob/main/Initial%20codes.sql):
   • It's in: bigquery-public-data.google_analytics_sample
   • Tables are named like ga_sessions_20160801
3. Create flattened tables first (the data is super nested) (I have attached all of my queries as well as clean csv files)
4. Run the analysis queries in order
5. Export to Power BI for visualizations



