
-- ==========================================
-- SILVER 1: PREPARE AND DEDUPLICATE BOOKINGS
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_prepared
AS
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY booking_id
            ORDER BY booking_date DESC, guest_id ASC
        ) AS row_num
    FROM bronze_hotel_bookings
)

SELECT
    booking_id,
    NULLIF(TRIM(guest_id), '') AS guest_id,

    TRY_CAST(booking_date AS DATE) AS booking_date,
    TRY_CAST(check_in_date AS DATE) AS check_in_date,
    TRY_CAST(check_out_date AS DATE) AS check_out_date,

    COALESCE(
        TRY_CAST(nights AS INT),
        DATEDIFF(
            TRY_CAST(check_out_date AS DATE),
            TRY_CAST(check_in_date AS DATE)
        )
    ) AS nights,

    INITCAP(TRIM(hotel_name)) AS hotel_name,

    COALESCE(
        NULLIF(INITCAP(TRIM(city)), ''),
        'Unknown'
    ) AS city,

    INITCAP(TRIM(region)) AS region,

    COALESCE(
        NULLIF(INITCAP(TRIM(room_type)), ''),
        'Unknown'
    ) AS room_type,

    COALESCE(
        NULLIF(INITCAP(TRIM(booking_channel)), ''),
        'Unknown'
    ) AS booking_channel,

    TRY_CAST(guests AS INT) AS guests,
    TRY_CAST(room_rate AS DOUBLE) AS room_rate,

    COALESCE(
        TRY_CAST(total_amount AS DOUBLE),
        COALESCE(
            TRY_CAST(nights AS INT),
            DATEDIFF(
                TRY_CAST(check_out_date AS DATE),
                TRY_CAST(check_in_date AS DATE)
            )
        ) * TRY_CAST(room_rate AS DOUBLE)
    ) AS total_amount,

    COALESCE(
        TRY_CAST(discount_amount AS DOUBLE),
        0
    ) AS discount_amount,

    COALESCE(
        NULLIF(INITCAP(TRIM(meal_plan)), ''),
        'Unknown'
    ) AS meal_plan,

    INITCAP(TRIM(payment_method)) AS payment_method,
    INITCAP(TRIM(payment_status)) AS payment_status,
    INITCAP(TRIM(booking_status)) AS booking_status,

    TRY_CAST(guest_rating AS DOUBLE) AS guest_rating,

    source_file,
    loaded_at

FROM ranked
WHERE row_num = 1;


-- ==========================================
-- SILVER 2: CLEAN BOOKINGS
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_clean
AS
SELECT
    *,

    CASE
        WHEN booking_status = 'Completed'
        THEN total_amount - discount_amount
        ELSE 0
    END AS net_revenue

FROM silver_bookings_prepared

WHERE check_in_date IS NOT NULL
  AND check_out_date IS NOT NULL
  AND check_out_date > check_in_date
  AND room_rate IS NOT NULL
  AND room_rate >= 0;


-- ==========================================
-- SILVER 3: REJECTED BOOKINGS
-- ==========================================

CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_rejected
AS
SELECT
    *,

    CASE
        WHEN check_in_date IS NULL
          OR check_out_date IS NULL
        THEN 'Invalid or missing stay date'

        WHEN check_out_date <= check_in_date
        THEN 'Invalid check-out date'

        WHEN room_rate IS NULL
        THEN 'Missing or invalid room rate'

        WHEN room_rate < 0
        THEN 'Negative room rate'

        ELSE 'Unknown validation error'
    END AS reject_reason

FROM silver_bookings_prepared

WHERE check_in_date IS NULL
   OR check_out_date IS NULL
   OR check_out_date <= check_in_date
   OR room_rate IS NULL
   OR room_rate < 0;
