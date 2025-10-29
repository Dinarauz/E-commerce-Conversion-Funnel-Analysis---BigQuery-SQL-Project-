# E-commerce Conversion Funnel Analysis for Google Merchandise Store using BigQuery SQL
<img width="1920" height="1080" alt="Google Analytics Funnel Analysis" src="https://github.com/user-attachments/assets/9a08c145-d81f-4ebc-8f58-fd9ef25f3754" />

In this project I analyzed BigQuery SQL to see how customers move through an online store's purchase process from browsing to buying. The goal was to understand where and why users were dropping off.

## Business Problem:
The Google Merchandise Store (like most e-commerce sites) was losing potential customers somewhere between landing on the site and completing a purchase. They needed to understand: 

## Questions I wanted to answer:
1. Where exactly are we losing customers in the purchase journey?
2. How many visitors actually end up buying something?
3. Does mobile vs desktop make a difference?
4. How bad is the cart abondonment problem ?
5. Which countries makes the most profit?
6. What are top traffic sources?

**What I'm solving:** Identifying the specific drop-off points in the conversion funnel and quantifying the revenue impact of fixing them.

## Key Insights:
1. Massive drop-off at product view - 86.11% of visitors never even look at a product page
2. Checkout is the killer - We lose 54% of users between cart and starting checkout
3. Mobile is broken - Mobile converts at 0.49% vs desktop's 1.73% (72% worse)
4. Cart abandonment crisis - 74.84% of people who add items don't complete purchase
5. Customers from worldwide shop, with US dominating followed by Venezuela and Canada.
6. Direct traffic converts the best 2.76% conversion rate and makes the most revenue $1.3M and least one being outlooklive.com with total revenue $32.99
7. Total revenue $1.77M meanwhile total lost revenue $7.33M


## Business Recommendations
1. **Need to fix mobile experience immediately**
   • Mobile traffic leaks value 24% of visits but only 9% of purchases; converts 72% worse than desktop.
   • Focus on site speed, simplified navigation, and responsive checkout.
3. **Simplify checkout process**
   • Reduce from 5 steps to 2-3 steps
   • Add guest checkout option (no forced account creation)
   
## The Numbers:
1. **Total Sessions:** 903,653
2. **Unique Visitors:** 712,272
3. **Purchases:** 9,988 people 
5. **Total Revenue:** $1.77M
6. **Lost Revenue:** $7.33M

## Funnel Analysis Overview
All Visitors        → 712,272 (100%)    ← Everyone who visited
Product Views       → 98,941 (13.9%)  ← Looked at a product
Add to Cart         → 39,700 (5.6%)    ← Added something to cart
Begin Checkout      → 18,209 (2.6%)    ← Started checkout
Complete Purchase   → 9,988 (1.40%)     ← Actually bought

## Device Breakdown
• **Desktop**: 1.73% conversion rate
• **Tablet**: 0.66% conversion rate
• **Mobile**: 0.49% conversion rate

## Summary
Despite healthy site traffic, the majority of visitors never reach a product page, and mobile underperforms greatly. We need to address mobile UX and checkout friction because these are the biggest opportunity for conversion growth.

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



## How I Calculated Key Metrics

The table below summarizes all key metrics, formulas, and sample calculations used in the Google Merchandise Store analysis.

| **#** | **Metric**                    | **Formula**                                   | **Example Calculation**   | **Result / Insight**                          |
| :---: | :---------------------------- | :-------------------------------------------- | :------------------------ | :-------------------------------------------- |
|   1   | **Product View Rate**         | (Product Detail Views ÷ Total Visitors) × 100 | (98,941 ÷ 712,272) × 100  | **13.89%** of visitors view a product         |
|   2   | **Add-to-Cart Rate**          | (Add to Cart ÷ Product Views) × 100           | (39,700 ÷ 98,941) × 100   | **40.12%** of product viewers add to cart     |
|   3   | **Checkout Start Rate**       | (Begin Checkout ÷ Add to Cart) × 100          | (18,209 ÷ 39,700) × 100   | **45.87%** of cart users start checkout       |
|   4   | **Checkout Completion Rate**  | (Purchases ÷ Begin Checkout) × 100            | (9,988 ÷ 18,209) × 100    | **54.85%** complete checkout                  |
|   5   | **Overall Conversion Rate**   | (Purchases ÷ Total Visitors) × 100            | (9,988 ÷ 712,272) × 100   | **1.40%** overall conversion                  |
|   6   | **Cart Abandonment Rate**     | 1 − (Purchases ÷ Add to Cart)                 | 1 − (9,988 ÷ 39,700)      | **74.84%** abandonment                        |
|   7   | **Device Conversion Gap**     | (1 − (Mobile ÷ Desktop)) × 100                | 1 − (0.49 ÷ 1.73)         | **72% worse** on mobile                       |
|   8   | **Product View Drop-off**     | 100 − Product View Rate                       | 100 − 13.89               | **86.11%** never view a product               |
|   9   | **Traffic Source Comparison** | ((Better − Lower) ÷ Lower) × 100              | ((2.3 − 0.8) ÷ 0.8) × 100 | **187.5% higher** for direct traffic          |
|   10  | **Traffic vs. Revenue Share** | (Revenue Share ÷ Traffic Share) × 100         | (23 ÷ 42) × 100           | Mobile earns only **55%** of expected revenue |

Each formula shows how I derived the funnel metrics and comparative insights directly from the dataset. You can reuse these calculations for any e-commerce or Google Analytics analysis.
