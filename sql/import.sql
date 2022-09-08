INSERT INTO :pwstable
SELECT eventdata.*
FROM tmp
  CROSS JOIN LATERAL json_populate_record(null:::pwstable, data) AS eventdata
ORDER BY eventdata."Timestamp";
TRUNCATE table tmp;