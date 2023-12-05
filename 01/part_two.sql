CREATE TEMPORARY TABLE input AS
       SELECT * FROM read_csv('input', columns = { 'column0': 'VARCHAR'});

CREATE TEMPORARY TABLE extracted_numbers AS
       SELECT
           regexp_extract_all(column0, '(one|two|three|four|five|six|seven|eight|nine|\d)') AS numbers_as_numbers_or_strings_first,
           regexp_extract_all(reverse(column0), '(eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|\d)') AS numbers_as_numbers_or_strings_last,
       FROM input;

CREATE TEMPORARY TABLE parsed_numbers AS
SELECT
    list_transform(
            numbers_as_numbers_or_strings_first,
            x -> CASE
                WHEN x = 'one'
                    THEN 1
                WHEN x = 'two'
                    THEN 2
                WHEN x = 'three'
                    THEN 3
                WHEN x = 'four'
                    THEN 4
                WHEN x = 'five'
                    THEN 5
                WHEN x = 'six'
                    THEN 6
                WHEN x = 'seven'
                    THEN 7
                WHEN x = 'eight'
                    THEN 8
                WHEN x = 'nine'
                    THEN 9
                ELSE
                        x
                END
    ) AS numbers_first,
    list_transform(
            numbers_as_numbers_or_strings_last,
            x -> CASE
                     WHEN x = 'eno'
                         THEN 1
                     WHEN x = 'owt'
                         THEN 2
                     WHEN x = 'eerht'
                         THEN 3
                     WHEN x = 'ruof'
                         THEN 4
                     WHEN x = 'evif'
                         THEN 5
                     WHEN x = 'xis'
                         THEN 6
                     WHEN x = 'neves'
                         THEN 7
                     WHEN x = 'thgie'
                         THEN 8
                     WHEN x = 'enin'
                         THEN 9
                     ELSE
                         x
                END
    ) AS numbers_last,
FROM extracted_numbers;

CREATE TEMPORARY TABLE first_and_last AS
SELECT
    numbers_first[1] AS first_number,
    numbers_last[1] AS last_number,
FROM parsed_numbers;

SELECT * FROM input;
SELECT * FROM extracted_numbers;
SELECT * FROM parsed_numbers;
SELECT * FROM first_and_last;

SELECT CAST(concat(first_number, last_number) AS INTEGER) AS concated
FROM first_and_last;

SELECT
    SUM(
            CAST(concat(first_number, last_number) AS INTEGER)
    ) AS total
FROM first_and_last;
