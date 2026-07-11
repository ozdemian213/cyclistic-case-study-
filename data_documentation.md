# Cyclistic Case Study — Data Documentation

## 1. Business context
This dataset supports the Cyclistic bike-share analysis. **Business task:** analyze 12 months of trip data to identify how annual members and casual riders use the bikes differently, in order to inform a marketing strategy that converts casual riders into annual members.

## 2. Source & provenance
| Attribute | Detail |
|---|---|
| Dataset | Divvy (Cyclistic) historical trip data |
| Publisher / operator | Lyft Bikes and Scooters, LLC ("Divvy"); credited in the case study as Motivate International Inc. |
| Official source | https://divvybikes.com/system-data |
| File naming | `YYYYMM-divvy-tripdata.zip` (one CSV per month) |
| License | Divvy Data License Agreement |
| Update cadence | Monthly |
| Window used | 12 most recent complete months (2025-07 → 2026-06) |

## 3. Schema (13 columns)
| Column | Type | Notes |
|---|---|---|
| ride_id | STRING | 16-char unique trip ID |
| rideable_type | STRING | classic_bike, electric_bike |
| started_at | TIMESTAMP | Trip start |
| ended_at | TIMESTAMP | Trip end |
| start_station_name | STRING | May be NULL (esp. e-bikes) |
| start_station_id | STRING | May be NULL |
| end_station_name | STRING | May be NULL |
| end_station_id | STRING | May be NULL |
| start_lat / start_lng | FLOAT | Start coordinates |
| end_lat / end_lng | FLOAT | May be NULL |
| member_casual | STRING | "member" or "casual" — only rider-type signal |

## 4. Pre-processing already applied by the publisher
- Staff/maintenance trips removed.
- Trips under 60 seconds removed.
- Personally identifiable information stripped.

## 5. ROCCC credibility assessment
| Criterion | Rating | Rationale |
|---|---|---|
| **Reliable** | Strong | Machine-logged trip records; publisher pre-filters staff/short trips. |
| **Original** | Strong | First-party data from the system operator. |
| **Comprehensive** | Partial | Complete trip attributes, but **no rider-level identifiers** — no user ID, demographics, revenue, or weather. Analysis rests on `member_casual`. |
| **Current** | Strong | Updated monthly; most-recent-12-months window. |
| **Cited** | Strong | Public licensed dataset with a clearly identified provider. |

## 6. Key limitation
The data contains **no personally identifiable information and no user IDs**. We can describe *how* members and casual riders behave differently, but **cannot directly measure an individual casual rider converting to a member**, nor distinguish tourists from local casual riders. All conclusions are behavioral, not causal.

## 7. Cleaning results (Phase 3 – Process)
Cleaning was performed in BigQuery via a single reproducible `CREATE TABLE AS SELECT` query (raw table left untouched as an immutable staging layer).

| Metric | Value |
|---|---|
| Raw rows | 5,932,349 |
| Rows removed | 5,679 (0.10%) |
| Clean rows | 5,926,670 |

Removal breakdown (categories may overlap):
| Reason | Rows | Rationale |
|---|---|---|
| Ride length > 24h | 5,539 | Likely undocked/lost bikes (business rule). |
| Outside analysis window | 102 | Month-boundary spillover. |
| Duplicate ride_id | 35 | ride_id must be unique; kept first via ROW_NUMBER(). |
| Zero/negative duration | 29 | ended_at <= started_at; impossible. |
| Unparseable timestamp | 0 | All timestamps valid. |
| Invalid rider type | 0 | Only "member"/"casual" present. |

Calculated fields added: `ride_length_min`, `day_of_week`, `month_name`, `start_hour`, `season`.

Decision of note: rows with NULL station names were **kept** (legitimate e-bike dock-less trips); deleting them would bias the data against electric bikes.
