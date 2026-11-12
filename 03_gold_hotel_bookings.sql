
-- ==========================================
-- GOLD 1: MONTHLY BOOKINGS
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW gold_monthly_bookings
AS
SELECT
    DATE_TRUNC('MONTH', check_in_date) AS stay_month,

    COUNT(*) AS total_bookings,

    SUM(
        CASE WHEN booking_status = 'Cancelled'
        THEN 1 ELSE 0 END
    ) AS cancelled_bookings,

    SUM(
        CASE WHEN booking_status = 'Completed'
        THEN nights ELSE 0 END
    ) AS room_nights,

    ROUND(SUM(net_revenue), 2) AS net_revenue

FROM silver_bookings_clean
GROUP BY DATE_TRUNC('MONTH', check_in_date);


-- ==========================================
-- GOLD 2: HOTEL SUMMARY
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW gold_hotel_summary
AS
SELECT
    region,
    city,
    hotel_name,

    COUNT(*) AS total_bookings,

    SUM(
        CASE WHEN booking_status = 'Completed'
        THEN nights ELSE 0 END
    ) AS room_nights,

    ROUND(SUM(net_revenue), 2) AS net_revenue,

    ROUND(
        SUM(net_revenue) /
        NULLIF(
            SUM(
                CASE WHEN booking_status = 'Completed'
                THEN nights ELSE 0 END
            ), 0
        ), 2
    ) AS adr

FROM silver_bookings_clean
GROUP BY region, city, hotel_name;


-- ==========================================
-- GOLD 3: ROOM TYPE SUMMARY
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW gold_room_type_summary
AS
SELECT
    room_type,

    COUNT(*) AS total_bookings,

    SUM(
        CASE WHEN booking_status = 'Completed'
        THEN nights ELSE 0 END
    ) AS room_nights,

    ROUND(SUM(net_revenue), 2) AS net_revenue,

    ROUND(AVG(guest_rating), 2) AS avg_guest_rating

FROM silver_bookings_clean
GROUP BY room_type;


-- ==========================================
-- GOLD 4: BOOKING CHANNEL SUMMARY
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW gold_channel_summary
AS
SELECT
    booking_channel,

    COUNT(*) AS total_bookings,

    SUM(
        CASE WHEN booking_status = 'Cancelled'
        THEN 1 ELSE 0 END
    ) AS cancelled_bookings,

    ROUND(
        100.0 * SUM(
            CASE WHEN booking_status = 'Cancelled'
            THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct,

    ROUND(SUM(net_revenue), 2) AS net_revenue

FROM silver_bookings_clean
GROUP BY booking_channel;


-- ==========================================
-- GOLD 5: DATA QUALITY SUMMARY
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality
AS
WITH
bronze AS (
    SELECT COUNT(*) AS bronze_count
    FROM bronze_hotel_bookings
),

prepared AS (
    SELECT COUNT(*) AS prepared_count
    FROM silver_bookings_prepared
),

clean AS (
    SELECT COUNT(*) AS clean_count
    FROM silver_bookings_clean
),

rejected AS (
    SELECT COUNT(*) AS rejected_count
    FROM silver_bookings_rejected
)

SELECT
    b.bronze_count AS bronze_rows,

    c.clean_count AS clean_rows,

    r.rejected_count AS rejected_rows,

    b.bronze_count - p.prepared_count
        AS duplicate_rows,

    r.rejected_count +
    (b.bronze_count - p.prepared_count)
        AS total_quality_issues,

    CASE
        WHEN b.bronze_count =
             c.clean_count +
             r.rejected_count +
             (b.bronze_count - p.prepared_count)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status

FROM bronze b
CROSS JOIN prepared p
CROSS JOIN clean c
CROSS JOIN rejected r;
