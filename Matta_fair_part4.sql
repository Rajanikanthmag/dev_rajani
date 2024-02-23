CREATE TABLE IF NOT EXISTS substring({{schema_name}}{{table_name}},2,len({{schema_name}}{{table_name}})) (
  flight_num String,
  flight_date String,
  origin String,
  dest String,
  dep_date String,
  dep_time String,
  ac_type String,
  class String,
  booked_count INTEGER,
  available_count INTEGER,
  capacity INTEGER
);


