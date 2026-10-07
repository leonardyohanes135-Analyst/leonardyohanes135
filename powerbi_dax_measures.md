# Power BI Dashboard — E-Commerce Sales Analysis
## Author: Leonard Yohanes Mathayo
## Dataset: ecommerce_sales_data.csv

---

## Dashboard Pages

### Page 1: Executive Summary
- KPI cards: Total Revenue, Total Orders, Avg Rating, Return Rate
- Line chart: Monthly Revenue Trend (2023–2024)
- Donut chart: Revenue by Category
- Map visual: Revenue by City

### Page 2: Sales Performance
- Bar chart: Revenue by Channel
- Clustered bar: Orders by Payment Method
- Matrix: Category × City revenue breakdown
- Waterfall: Discount impact on revenue

### Page 3: Customer Insights
- Histogram: Customer Age Distribution
- Bar: Rating by Delivery Tier
- Scatter: Order Value vs. Customer Rating
- Slicer: Gender, City, Year

---

## DAX Measures

### Core Metrics
```dax
Total Revenue = SUM(sales[total_revenue_tzs])

Total Orders = COUNTROWS(sales)

Average Order Value =
    DIVIDE([Total Revenue], [Total Orders])

Avg Customer Rating =
    AVERAGE(sales[customer_rating])

Return Rate % =
    DIVIDE(
        COUNTROWS(FILTER(sales, sales[returned] = "Yes")),
        [Total Orders]
    ) * 100

Avg Delivery Days = AVERAGE(sales[delivery_days])
```

### Time Intelligence
```dax
Revenue Previous Month =
    CALCULATE(
        [Total Revenue],
        PREVIOUSMONTH('Calendar'[Date])
    )

MoM Revenue Growth % =
    DIVIDE(
        [Total Revenue] - [Revenue Previous Month],
        [Revenue Previous Month]
    ) * 100

Revenue YTD =
    CALCULATE(
        [Total Revenue],
        DATESYTD('Calendar'[Date])
    )

Revenue Same Period Last Year =
    CALCULATE(
        [Total Revenue],
        SAMEPERIODLASTYEAR('Calendar'[Date])
    )

YoY Growth % =
    DIVIDE(
        [Total Revenue] - [Revenue Same Period Last Year],
        [Revenue Same Period Last Year]
    ) * 100
```

### Customer Metrics
```dax
Unique Customers =
    DISTINCTCOUNT(sales[customer_id])

Revenue Per Customer =
    DIVIDE([Total Revenue], [Unique Customers])

High Value Customers =
    CALCULATE(
        [Unique Customers],
        FILTER(
            SUMMARIZE(sales, sales[customer_id],
                "cust_rev", SUM(sales[total_revenue_tzs])),
            [cust_rev] > AVERAGE(sales[total_revenue_tzs]) * 3
        )
    )
```

### Rankings
```dax
Category Revenue Rank =
    RANKX(
        ALL(sales[category]),
        [Total Revenue],
        ,
        DESC,
        DENSE
    )

City Revenue Rank =
    RANKX(
        ALL(sales[city]),
        [Total Revenue],
        ,
        DESC,
        DENSE
    )
```

### Conditional KPI Colors (for card formatting)
```dax
Rating Color =
    IF([Avg Customer Rating] >= 4, "Green",
        IF([Avg Customer Rating] >= 3, "Orange", "Red"))

Return Rate Status =
    IF([Return Rate %] <= 5, "Good",
        IF([Return Rate %] <= 10, "Warning", "Critical"))
```

---

## Calendar Table (Required for Time Intelligence)
```dax
Calendar =
ADDCOLUMNS(
    CALENDAR(DATE(2023,1,1), DATE(2024,12,31)),
    "Year",       YEAR([Date]),
    "Month",      MONTH([Date]),
    "MonthName",  FORMAT([Date], "MMMM"),
    "Quarter",    "Q" & QUARTER([Date]),
    "WeekDay",    WEEKDAY([Date]),
    "DayName",    FORMAT([Date], "DDDD")
)
```

---

## Data Model Relationships
- sales[order_date] → Calendar[Date] (Many-to-One)
- All slicers connected to sales table

## Key Insights (Sample Findings)
- Electronics leads revenue at ~30% share
- Dar es Salaam accounts for ~40% of all orders
- Mobile Money is the dominant payment method (50%)
- Express delivery correlates with higher customer ratings
- WhatsApp channel shows highest average order value
