CREATE TEMPORARY TABLE input AS
       SELECT * FROM read_csv('input', columns = { 'column0': 'VARCHAR'});

CREATE TEMPORARY TABLE first_and_last AS
       SELECT
           len(regexp_extract_all(column0, '(\d)')) AS numbers_amount,
           regexp_extract(column0, '(\d)') AS first_number,
           regexp_extract(reverse(column0), '(\d)') AS last_number,
       FROM input;

SELECT * FROM input;
SELECT * FROM first_and_last;

-- Solution if first and last digit have to be distinct
-- SELECT
--         CASE
--             WHEN numbers_amount = 1
--             THEN
--                 CAST(first_number AS INTEGER)
--             ELSE
--                 CAST(concat(first_number, last_number) AS INTEGER)
--         END AS number
-- FROM first_and_last;

SELECT
    SUM(
            CAST(concat(first_number, last_number) AS INTEGER)
    ) AS total
FROM first_and_last;
