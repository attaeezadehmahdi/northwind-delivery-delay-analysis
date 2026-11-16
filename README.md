# Northwind Delivery Delay Analysis

## Overview

This project analyzes order shipment times using the Northwind database, SQL Server, and Power BI.

The objective is to investigate factors that may influence the time between placing an order and shipping it, including shipping country, time period, product, shipping company, and order quantity.

The project combines SQL-based analysis with an interactive Power BI dashboard and management reports to communicate the findings.

## Tools & Technologies

- **SQL Server:** Data exploration and analytical queries
- **Power BI:** Data visualization and dashboard development
- **Northwind Database:** Source database

## Project Structure

```text
northwind-delivery-delay-analysis/
│
├── data/
│   └── README.md
│
├── sql/
│   └── analysis/
│
├── powerbi/
│   └── northwind_delivery_analysis.pbix
│
├── reports/
│   ├── management_report.pdf
│ 
│       └── dashboard/
│       └── northwind_dashboard.pdf
│
└── README.md
```

## Business Questions

The analysis investigates five main questions:

1. **Shipping Country:** Do shipment times differ across countries?
2. **Time Period:** Are there noticeable changes in shipment times across years, quarters, or months?
3. **Product:** Do certain products have longer shipment times than others?
4. **Shipping Company:** Does the shipping company influence shipment time?
5. **Order Quantity:** Is there a relationship between order quantity and shipment time?

## SQL Analysis

SQL Server was used to explore the database and perform analytical queries.

The analysis focuses on:

- Comparing average shipment time across countries.
- Identifying products and categories with higher shipment times.
- Examining shipment-time patterns across different time periods.
- Comparing shipping companies based on order volume and average shipment time.
- Investigating the relationship between order quantity and shipment time.

The primary shipment-time measure is calculated as:

```sql
DATEDIFF(DAY, OrderDate, ShippedDate)
```

This measures the number of days between order placement and shipment.

## Power BI Dashboard

The Power BI dashboard contains four pages:

| Page | Description |
|---|---|
| Sales Overview | Overview of sales, orders, quantities, and sales by year and category. |
| Shipment Time Analysis | Analysis of average shipment time across years, quarters, months, and days. |
| Shipped Orders | Overview of shipped order volume and average shipment time over time. |
| Product & Category Analysis | Comparison of average shipment times across products and categories. |

### Key Metrics

- **Total Sales:** $1.35M
- **Total Orders:** 830
- **Total Quantity:** 51K
- **Average Shipment Time:** 8.49 days

### Dashboard Preview

[View the complete Power BI dashboard (PDF)](reports/dashboard/northwind_delivery_analysis.pdf)

## Key Findings

The analysis produced the following findings:

- **Shipping Country:** Ireland had an average shipment time approximately 37% above the overall average, while Sweden was approximately 25% above it. Finland had an average shipment time more than 30% below the overall average.
- **Time Period:** No meaningful relationship was identified between shipment time and the analyzed time periods. Average shipment time remained around 8 days.
- **Product:** Six products had average shipment times more than 25% above the overall average, with two exceeding 90%. Together, these products represented approximately 8.3% of total orders.
- **Shipping Company:** No meaningful differences in average shipment time were identified among shipping companies.
- **Order Quantity:** Orders containing 39–49 items had an average shipment time approximately 25% higher than the overall average. However, the variation in observations did not indicate a consistent relationship between quantity and shipment time.

## Management Reports

The project includes written reports presenting the analysis and findings:

- [English Management Report](reports/management_report.pdf)

## Conclusion

The analysis identified differences in shipment times across certain countries and products. However, the results did not indicate a consistent relationship between shipment time and time period, shipping company, or order quantity.

Combining SQL analysis and Power BI visualization provides a structured way to investigate shipment performance and communicate findings through business-oriented reporting.

---

**Note:** In this project, shipment time refers to the period between order placement and shipment, rather than the time between shipment and actual delivery.
