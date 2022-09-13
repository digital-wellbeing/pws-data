INSERT INTO pws
SELECT * FROM pws_s3
WHERE "Timestamp" > (SELECT MAX("Timestamp") FROM pws)
ORDER BY "Timestamp";
INSERT INTO pws_device_info
SELECT * FROM pws_device_info_s3
WHERE "Timestamp" > (SELECT MAX("Timestamp") FROM pws_device_info)
ORDER BY "Timestamp";