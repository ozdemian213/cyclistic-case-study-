# 🚲 Cyclistic Bike-Share Case Study

**How do annual members and casual riders use Cyclistic bikes differently — and how can that convert casual riders into members?**

Google Data Analytics Capstone · Analysis of **5.93M bike trips** (Jul 2025–Jun 2026) using **BigQuery (SQL)** and **Tableau**.

> **TL;DR:** Casual riders behave like leisure/tourist users (long, weekend, summer, lakefront trips); members behave like commuters (short, weekday, year-round, rush-hour). I translated this into three timed, targeted, measurable marketing recommendations.

**🔗 [Interactive Tableau dashboard](https://public.tableau.com/app/profile/demian.ozorio.delfin/viz/CyclisticBike-ShareCaseStudy_17837417214950/ByMonth)**

---

## Business question
Cyclistic's growth strategy depends on converting casual riders into annual members (who are far more profitable). This project identifies the behavioral differences that make that conversion targetable.

## Process
- **Prepare:** Loaded 12 months of Divvy trip data into BigQuery. Assessed credibility with ROCCC — reliable first-party data, key limitation being no rider-level identifiers.
- **Process:** Cleaned in one reproducible query; removed 0.10% of rows (duplicates, invalid durations, >24h outliers, out-of-window); added ride_length, day, month, season, hour fields. Final: **5,926,670 rides.**
- **Analyze:** SQL EDA across volume, duration, day, season, hour, bike type, and station (see `analysis.sql`).
- **Share:** Executive Tableau dashboard with consistent color and insight-driven titles.

## Key findings
| | Casual | Member |
|---|---|---|
| Share of rides | 35.6% | 64.4% |
| Avg ride length | 18.6 min | 12.1 min |
| Peak days | Sat/Sun | Tue–Thu |
| Seasonality | ~13× summer surge | ~4× |
| Weekday pattern | flat | 8am & 5pm commute peaks |
| Top stations | lakefront/tourist | dispersed |

## Recommendations
1. **Time conversion campaigns for May–August**, when casual ridership peaks.
2. **Launch a weekend/seasonal membership tier** with an in-app upgrade-credit path.
3. **Geo-target lakefront/tourist stations**, selling everyday-commuter value.

## Tools
BigQuery · SQL · Tableau Public · Google Cloud

## Data
[Divvy public trip data](https://divvybikes.com/system-data) (operated by Lyft), used under the Divvy Data License. No personally identifiable information is included.

## Author
**Demian Ozorio Delfin**
