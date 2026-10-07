"""
================================================
E-Commerce Sales Analysis — Tanzania (2023-2024)
================================================
Author  : Leonard Yohanes Mathayo
Tool    : Python (pandas, matplotlib, seaborn, scipy)
Dataset : ecommerce_sales_data.csv (500 orders, 2 years)
Goal    : Explore sales trends, top categories, revenue
          by city, and customer behaviour patterns.
================================================
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

# ── 0. SETTINGS ─────────────────────────────────────────────────────────────
sns.set_theme(style="whitegrid", palette="deep")
plt.rcParams.update({"figure.dpi": 150, "figure.figsize": (10, 5)})

# ── 1. LOAD & INSPECT ────────────────────────────────────────────────────────
df = pd.read_csv("ecommerce_sales_data.csv", parse_dates=["order_date"])
print("Shape:", df.shape)
print("\nData Types:\n", df.dtypes)
print("\nMissing Values:\n", df.isnull().sum())
print("\nBasic Stats:\n", df.describe())

# ── 2. DATA CLEANING ─────────────────────────────────────────────────────────
df["month"]   = df["order_date"].dt.to_period("M")
df["quarter"] = df["order_date"].dt.to_period("Q")
df["year"]    = df["order_date"].dt.year

# Remove negative revenue
df = df[df["total_revenue_tzs"] > 0]
print(f"\nClean dataset: {df.shape[0]} rows")

# ── 3. DESCRIPTIVE STATISTICS ────────────────────────────────────────────────
print("\n── Revenue Summary ──")
print(df["total_revenue_tzs"].describe().apply(lambda x: f"{x:,.0f}"))

print("\n── Revenue by Category ──")
cat_summary = df.groupby("category")["total_revenue_tzs"].agg(["sum","mean","count"])
cat_summary.columns = ["Total Revenue (TZS)","Avg Revenue (TZS)","Orders"]
cat_summary = cat_summary.sort_values("Total Revenue (TZS)", ascending=False)
print(cat_summary.applymap(lambda x: f"{x:,.0f}"))

print("\n── Revenue by City ──")
city_rev = df.groupby("city")["total_revenue_tzs"].sum().sort_values(ascending=False)
print(city_rev.apply(lambda x: f"TZS {x:,.0f}"))

print("\n── Channel Performance ──")
channel = df.groupby("channel")["total_revenue_tzs"].agg(["sum","count"])
channel["avg_order"] = channel["sum"] / channel["count"]
print(channel)

# ── 4. MONTHLY REVENUE TREND ─────────────────────────────────────────────────
monthly = df.groupby("month")["total_revenue_tzs"].sum().reset_index()
monthly["month_str"] = monthly["month"].astype(str)

fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(monthly["month_str"], monthly["total_revenue_tzs"]/1e6,
        color="#1B4F8A", linewidth=2.5, marker="o", markersize=5)
ax.fill_between(monthly["month_str"], monthly["total_revenue_tzs"]/1e6,
                alpha=0.15, color="#1B4F8A")
ax.set_title("Monthly Revenue Trend (2023–2024)", fontsize=14, fontweight="bold")
ax.set_xlabel("Month")
ax.set_ylabel("Revenue (TZS Millions)")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
plt.savefig("monthly_revenue_trend.png")
plt.close()

# ── 5. REVENUE BY CATEGORY ───────────────────────────────────────────────────
fig, ax = plt.subplots(figsize=(9, 5))
colors = ["#1B4F8A","#2E86C1","#5DADE2","#85C1E9","#AED6F1"]
bars = ax.bar(cat_summary.index, cat_summary["Total Revenue (TZS)"]/1e6,
              color=colors, edgecolor="white", linewidth=0.8)
for bar in bars:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5,
            f'{bar.get_height():.1f}M', ha="center", va="bottom", fontsize=9)
ax.set_title("Total Revenue by Product Category (TZS Millions)", fontsize=13, fontweight="bold")
ax.set_ylabel("Revenue (TZS Millions)")
plt.tight_layout()
plt.savefig("revenue_by_category.png")
plt.close()

# ── 6. PAYMENT METHOD DISTRIBUTION ──────────────────────────────────────────
pay_counts = df["payment_method"].value_counts()
fig, ax = plt.subplots(figsize=(7, 7))
wedges, texts, autotexts = ax.pie(
    pay_counts, labels=pay_counts.index, autopct="%1.1f%%",
    colors=["#1B4F8A","#2E86C1","#5DADE2","#AED6F1"],
    startangle=90, wedgeprops={"edgecolor":"white","linewidth":2})
ax.set_title("Payment Method Distribution", fontsize=13, fontweight="bold")
plt.tight_layout()
plt.savefig("payment_distribution.png")
plt.close()

# ── 7. CUSTOMER RATING vs. DELIVERY DAYS ────────────────────────────────────
fig, ax = plt.subplots(figsize=(9, 5))
sns.boxplot(data=df, x="customer_rating", y="delivery_days",
            palette="Blues", ax=ax)
ax.set_title("Customer Rating vs. Delivery Days", fontsize=13, fontweight="bold")
ax.set_xlabel("Customer Rating (1=Poor, 5=Excellent)")
ax.set_ylabel("Delivery Days")
plt.tight_layout()
plt.savefig("rating_vs_delivery.png")
plt.close()

# ── 8. STATISTICAL TEST: Rating between channels ────────────────────────────
print("\n── ANOVA: Customer Rating by Sales Channel ──")
groups = [df[df["channel"]==c]["customer_rating"].values for c in df["channel"].unique()]
f_stat, p_val = stats.f_oneway(*groups)
print(f"F-statistic : {f_stat:.4f}")
print(f"P-value     : {p_val:.4f}")
print("Result      :", "Significant difference (p<0.05)" if p_val < 0.05 else "No significant difference")

# ── 9. CORRELATION MATRIX ────────────────────────────────────────────────────
numeric_cols = ["customer_age","quantity","unit_price_tzs","discount_pct",
                "delivery_days","customer_rating","total_revenue_tzs"]
corr = df[numeric_cols].corr()

fig, ax = plt.subplots(figsize=(9, 7))
mask = np.triu(np.ones_like(corr, dtype=bool))
sns.heatmap(corr, mask=mask, annot=True, fmt=".2f", cmap="Blues",
            ax=ax, linewidths=0.5, cbar_kws={"shrink":0.8})
ax.set_title("Correlation Matrix — Numeric Variables", fontsize=13, fontweight="bold")
plt.tight_layout()
plt.savefig("correlation_matrix.png")
plt.close()

print("\n✅ Analysis complete. All charts saved.")
