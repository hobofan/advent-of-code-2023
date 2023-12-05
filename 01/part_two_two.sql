-- Different attempt to solve overlapping problem
CREATE TEMPORARY TABLE input_raw AS
       SELECT * FROM read_csv('input', columns = { 'column0': 'VARCHAR'});

CREATE TEMPORARY TABLE input AS
SELECT
    input_raw.column0 AS raw,
    regexp_replace(raw, 'oneight', '18', 'g') AS rep_18,
    regexp_replace(rep_18, 'threeight', '38', 'g') AS rep_38,
    regexp_replace(rep_38, 'fiveight', '58', 'g') AS rep_58,
    regexp_replace(rep_58, 'nineight', '98', 'g') AS rep_98,
    regexp_replace(rep_98, 'one', '1', 'g') AS rep_1,
    regexp_replace(rep_1, 'two', '2', 'g') AS rep_2,
    regexp_replace(rep_2, 'three', '3', 'g') AS rep_3,
    regexp_replace(rep_3, 'four', '4', 'g') AS rep_4,
    regexp_replace(rep_4, 'five', '5', 'g') AS rep_5,
    regexp_replace(rep_5, 'six', '6', 'g') AS rep_6,
    regexp_replace(rep_6, 'seven', '7', 'g') AS rep_7,
    regexp_replace(rep_7, 'eight', '8', 'g') AS rep_8,
    regexp_replace(rep_8, 'nine', '9', 'g') AS rep_9,
    rep_9 as column0
FROM input_raw;

CREATE TEMPORARY TABLE first_and_last AS
       SELECT
           len(regexp_extract_all(column0, '(\d)')) AS numbers_amount,
           regexp_extract(column0, '(\d)') AS first_number,
           regexp_extract(reverse(column0), '(\d)') AS last_number,
       FROM input;

SELECT raw, column0 FROM input;
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
