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
OPTIMIZE dih_stream.live_inventory.tbl_matta_fair;
insert into
  dih_stream.live_inventory.tbl_matta_fair (
    flight_num,
    flight_date,
    origin,
    dest,
    dep_date,
    dep_time,
    ac_type,
    class,
    booked_count,
    available_count,
    capacity
  )
select
  --processed_inventory_id as inv_id
  left(
    processed_inventory_id,
    len(processed_inventory_id) - 11
  ) as flight_num,
  right(processed_inventory_id, 10) as flight_date,
  boardPoint_iata_code as origin,
  offPoint_iata_code as dest --,scheduled_departure_datetime as dep_time
,
  left(
    scheduled_departure_datetime,
    len(scheduled_departure_datetime) - 9
  ) as dep_date,
  right(scheduled_departure_datetime, 8) as dep_time,
  aircraft_equipment_aircraft_type as ac_type,
  leg_counter_cabin_code as class,
  sum(leg_counter_inventory_counter_booking) as booked_count,
  sum(leg_counter_availability_counter_gross) as available_count,
  sum(leg_counter_capacity_authorization_level) as capacity
from
  (
    select
      distinct processed_inventory_id,
      processed_inventory_version,
      boardPoint_iata_code,
      offPoint_iata_code,
      scheduled_departure_datetime,
      aircraft_equipment_aircraft_type,
      leg_counter_cabin_code,
      leg_counter_inventory_counter_booking,
      leg_counter_availability_counter_gross -- ,leg_counter_availability_counter_net
      -- ,leg_counter_inventory_control_netted_protection
      -- ,leg_counter_blockSpaces_marketing_flight_flightdesignator_carrier_code
      -- ,leg_counter_blockSpaces_marketing_flight_flightdesignator_flight_number
      -- ,leg_counter_capacity_saleable_capacity
,
      leg_counter_capacity_authorization_level,
      rank() over (
        partition by processed_inventory_id
        order by
          processed_inventory_version desc
      ) as rnk
    from
      dih_stream.dih_inv_pdl.inv_pdl_leg
    where
      scheduled_departure_datetime between current_timestamp()
      and date_add(current_timestamp(), 365) --and boardPoint_iata_code = 'KUL'
      --  where processed_inventory_id= 'MH-144-2023-11-29'
      --  and leg_counter_cabin_code = 'J'
  )
where
  rnk = '1'
group by
  processed_inventory_id,
  boardPoint_iata_code,
  offPoint_iata_code,
  scheduled_departure_datetime,
  aircraft_equipment_aircraft_type,
  leg_counter_cabin_code;