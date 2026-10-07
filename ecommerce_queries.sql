-- ============================================================
-- E-Commerce Sales Analysis — SQL Project
-- Author  : Leonard Yohanes Mathayo
-- Tool    : SQL (SQLite / PostgreSQL compatible)
-- Dataset : ecommerce_sales_data.csv → imported as 'sales'
-- Goal    : Business intelligence queries for sales insights
-- ============================================================

-- ── 0. CREATE TABLE ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sales (
    order_id        TEXT PRIMARY KEY,
    order_date      DATE,
    customer_id     TEXT,
    customer_gender TEXT,
    customer_age    INTEGER,
    city            TEXT,
    category        TEXT,
    quantity        INTEGER,
    unit_price_tzs  REAL,
    discount_pct    REAL,
    channel         TEXT,
    payment_method  TEXT,
    delivery_days   INTEGER,
    returned        TEXT,
    customer_rating INTEGER,
    total_revenue_tzs REAL
);

-- ── 1. OVERVIEW: Total orders, revenue, avg order value ─────
SELECT
    COUNT(*)                              AS total_orders,
    COUNT(DISTINCT customer_id)           AS unique_customers,
    SUM(total_revenue_tzs)                AS total_revenue,
    ROUND(AVG(total_revenue_tzs), 0)      AS avg_order_value,
    ROUND(AVG(customer_rating), 2)        AS avg_rating,
    SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) AS total_returns
FROM sales;

-- ── 2. REVENUE BY PRODUCT CATEGORY ──────────────────────────
SELECT
    category,
    COUNT(*)                                    AS orders,
    SUM(quantity)                               AS units_sold,
    SUM(total_revenue_tzs)                      AS total_revenue,
    ROUND(AVG(total_revenue_tzs), 0)            AS avg_revenue,
    ROUND(100.0 * SUM(total_revenue_tzs) /
          (SELECT SUM(total_revenue_tzs) FROM sales), 2) AS revenue_share_pct
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- ── 3. TOP 5 CITIES BY REVENUE ───────────────────────────────
SELECT
    city,
    COUNT(*)                AS orders,
    SUM(total_revenue_tzs)  AS total_revenue,
    ROUND(AVG(customer_rating), 2) AS avg_rating
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 5;

-- ── 4. MONTHLY REVENUE TREND ─────────────────────────────────
SELECT
    STRFTIME('%Y-%m', order_date)  AS year_month,
    COUNT(*)                        AS orders,
    SUM(total_revenue_tzs)          AS monthly_revenue,
    ROUND(AVG(total_revenue_tzs),0) AS avg_order_value
FROM sales
GROUP BY year_month
ORDER BY year_month;

-- ── 5. CHANNEL PERFORMANCE COMPARISON ───────────────────────
SELECT
    channel,
    COUNT(*)                                AS total_orders,
    SUM(total_revenue_tzs)                  AS revenue,
    ROUND(AVG(total_revenue_tzs), 0)        AS avg_order,
    ROUND(AVG(customer_rating), 2)          AS avg_rating,
    SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) AS returns
FROM sales
GROUP BY channel
ORDER BY revenue DESC;

-- ── 6. PAYMENT METHOD USAGE ──────────────────────────────────
SELECT
    payment_method,
    COUNT(*)                AS transactions,
    SUM(total_revenue_tzs)  AS total_revenue,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM sales), 2) AS usage_pct
FROM sales
GROUP BY payment_method
ORDER BY transactions DESC;

-- ── 7. CUSTOMER SEGMENTATION BY AGE GROUP ───────────────────
SELECT
    CASE
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN customer_age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*)                         AS orders,
    SUM(total_revenue_tzs)           AS revenue,
    ROUND(AVG(customer_rating), 2)   AS avg_rating
FROM sales
GROUP BY age_group
ORDER BY age_group;

-- ── 8. GENDER-BASED PURCHASING BEHAVIOUR ────────────────────
SELECT
    customer_gender,
    COUNT(*)                            AS total_orders,
    SUM(total_revenue_tzs)              AS total_revenue,
    ROUND(AVG(total_revenue_tzs), 0)    AS avg_order_value,
    ROUND(AVG(discount_pct), 2)         AS avg_discount_used,
    ROUND(AVG(customer_rating), 2)      AS avg_rating
FROM sales
GROUP BY customer_gender;

-- ── 9. RETURN RATE BY CATEGORY ───────────────────────────────
SELECT
    category,
    COUNT(*)                                     AS total_orders,
    SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(100.0 * SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS return_rate_pct
FROM sales
GROUP BY category
ORDER BY return_rate_pct DESC;

-- ── 10. DELIVERY SPEED vs. CUSTOMER RATING ──────────────────
SELECT
    CASE
        WHEN delivery_days <= 2  THEN 'Express (1-2 days)'
        WHEN delivery_days <= 5  THEN 'Standard (3-5 days)'
        WHEN delivery_days <= 10 THEN 'Slow (6-10 days)'
        ELSE 'Very Slow (10+ days)'
    END AS delivery_tier,
    COUNT(*)                         AS orders,
    ROUND(AVG(customer_rating), 2)   AS avg_rating,
    ROUND(AVG(total_revenue_tzs), 0) AS avg_revenue
FROM sales
GROUP BY delivery_tier
ORDER BY avg_rating DESC;

-- ── 11. HIGH VALUE CUSTOMERS (TOP 10) ────────────────────────
SELECT
    customer_id,
    customer_gender,
    customer_age,
    city,
    COUNT(*)                  AS total_orders,
    SUM(total_revenue_tzs)    AS lifetime_value,
    ROUND(AVG(customer_rating),2) AS avg_rating
FROM sales
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 10;

-- ── 12. DISCOUNT IMPACT ON REVENUE ──────────────────────────
SELECT
    discount_pct,
    COUNT(*)                         AS orders,
    ROUND(AVG(total_revenue_tzs), 0) AS avg_revenue,
    ROUND(AVG(customer_rating), 2)   AS avg_rating
FROM sales
GROUP BY discount_pct
ORDER BY discount_pct;
