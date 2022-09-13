INSERT INTO :pwstable
SELECT eventdata.*
FROM tmp
  CROSS JOIN LATERAL json_populate_record(null:::pwstable, data) AS eventdata
WHERE eventdata."EventName" != 'player_device_info'
ORDER BY eventdata."Timestamp";
INSERT into :devicetable
SELECT
	x."OxfordStudyEntityId",
	x."EntityId",
	x."EventId", 
	d."Platform",
	d."Version",
	d."SupportsLocationService",
	d."GraphicsMultiThreaded",
  d."SupportsAccelerometer",
  d."StreamingAssetsPath",
  d."GraphicsShaderLevel",
  d."GraphicsDeviceName",
  d."GraphicsMemorySize",
  d."PersistentDataPath",
  d."ProcessorFrequency",
  d."SupportsGyroscope",
  d."GraphicsDeviceId",
  d."SystemMemorySize",
  d."OperatingSystem",
  d."TargetFrameRate",
  d."RunInBackground",
  d."DeviceUniqueId",
  d."ProcessorCount",
  l."ContinentCode",
  l."CountryCode",
  l."Longitude",
  l."Latitude",
  l."City",
  l."IP",
  d."ProcessorType",
  d."UnityVersion",
  d."GraphicsType",
  d."DeviceModel",
  d."DeviceType",
  d."UserAgent",
  d."DataPath",
  d."PlayerIP",
	x."Timestamp"
FROM tmp
  CROSS JOIN LATERAL json_to_record(data) AS x(
	  "OxfordStudyEntityId" text,
  	"EventName" text,
	  "EntityId" text, 
	  "EventId" text, 
	  "DeviceInfo" json,
	  "Timestamp" timestamp
  )
  CROSS JOIN LATERAL json_populate_record(null:::devicetable, data -> 'DeviceInfo') AS d
  CROSS JOIN LATERAL json_populate_record(null:::devicetable, data -> 'DeviceInfo' -> 'PlayerLocation') AS l
WHERE x."EventName" = 'player_device_info';
TRUNCATE table tmp;