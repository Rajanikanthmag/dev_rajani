
USE CATALOG dih_stream;

CREATE SCHEMA IF NOT EXISTS live_inventory;

DROP TABLE IF EXISTS dih_stream.live_inventory.tbl_matta_fair;

CREATE TABLE IF NOT EXISTS dih_stream.live_inventory.tbl_matta_fair (
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


