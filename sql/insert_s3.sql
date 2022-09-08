INSERT INTO pws
SELECT * FROM pws_s3
WHERE "Timestamp" > (SELECT MAX("Timestamp") FROM pws)
ORDER BY "Timestamp"