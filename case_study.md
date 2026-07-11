# Cyclistic Bike-Share: Converting Casual Riders into Annual Members

*Google Data Analytics Capstone · A full analysis of 5.93M bike trips (Jul 2025–Jun 2026)*

**One-line summary:** Cyclistic's growth depends on converting casual riders into annual members. I analyzed a year of ride data and found that casual riders behave like leisure/tourist users (long, weekend, summer, lakefront trips) while members behave like commuters (short, weekday, year-round, rush-hour) — and turned that into three targeted, measurable marketing recommendations.

---

## 1. Ask — the business task
Cyclistic's finance team established that annual members are far more profitable than casual riders, and the Director of Marketing believes future growth lies in converting existing casual riders into members. My assigned question:

> **How do annual members and casual riders use Cyclistic bikes differently?**

**Business task:** Analyze 12 months of trip data to identify behavioral differences between the two groups, to inform a marketing strategy that converts casual riders into members.

**Stakeholders:** Lily Moreno (Director of Marketing, decision-maker); the marketing analytics team; and the detail-oriented executive team who approve the program.

## 2. Prepare — the data
- **Source:** Divvy public trip data (operated by Lyft), under the Divvy Data License. 12 most recent complete months.
- **Size:** 5,932,349 trips, 13 fields (timestamps, stations, coordinates, bike type, rider type).
- **Credibility (ROCCC):** Reliable, Original (first-party), Current, and Cited — but only *partially* Comprehensive: it contains **no personally identifiable information**, so I can describe *how* the groups differ but cannot track an individual converting. This boundary shapes every claim in the project.

## 3. Process — cleaning (BigQuery)
Loaded all 12 months into a single staging table (all fields as STRING for bulletproof ingestion), then built a clean table via one reproducible query. From 5,932,349 rows, I removed **5,679 (0.10%)**: 5,539 rides over 24 hours (likely undocked bikes), 102 outside the analysis window, 35 duplicate ride_ids, and 29 with zero/negative duration. I added calculated fields: ride_length_min, day_of_week, month, season, and start_hour. Rows missing a station name were **kept** (legitimate dock-less e-bike trips) to avoid biasing against electric bikes. Final dataset: **5,926,670 rides.**

## 4. Analyze — key findings (SQL)
| Dimension | Casual | Member |
|---|---|---|
| Share of rides | 35.6% (2.11M) | 64.4% (3.81M) |
| Avg ride length | 18.6 min | 12.1 min |
| Busiest days | Sat / Sun | Tue–Thu |
| Seasonality | ~13× summer surge | ~4× |
| Weekday hours | flat, no rush peak | sharp 8am & 5pm peaks |
| Top locations | lakefront / tourist sites | dispersed grid |

**Interpretation:** casual riders are leisure/tourist users; members are utility/commuters. Every dimension points the same way, which makes the conclusion robust.

## 5. Share — dashboard
An executive Tableau dashboard presents all six views with consistent color (orange = casual, blue = member) and insight-driven titles. **[View the interactive dashboard on Tableau Public →](https://public.tableau.com/app/profile/demian.ozorio.delfin/viz/CyclisticBike-ShareCaseStudy_17837417214950/ByMonth)**

## 6. Act — recommendations
1. **Time campaigns for May–August**, when casual volume peaks (~13× winter).
2. **Launch a weekend/seasonal membership tier** with an in-app upgrade-credit path that matches how casuals actually ride.
3. **Geo-target lakefront/tourist stations** with messaging that reframes the bike as a money-saving daily commute.

Each is measurable; because the data lacks rider IDs, I also recommend adding promo-code / in-app conversion tracking to quantify impact.

## 7. Limitations & next steps
- No rider-level IDs → cannot measure individual conversion or distinguish tourists from local casual riders. Pairing ride data with (privacy-safe) membership-signup data would enable true conversion analysis.
- No weather or pricing data → seasonality is described, not fully explained.
- Next: A/B test the recommendations and build a conversion-tracking pipeline.

## Tools
BigQuery (SQL) · Tableau Public · Google Cloud
