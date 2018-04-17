## Setup the local database
library(DBI)
library(odbc)
library(tidyverse)
library(nycflights13)


con <- dbConnect(
  drv = odbc(),
  driver = "PostgreSQL ODBC Driver(UNICODE)",
  server = "localhost",
  port = 5432,
  database = "postgres",
  uid = "postgres",
  password = "password"
)

dbSendQuery(con, "CREATE ROLE rdb LOGIN password 'rdbpass';")
dbSendQuery(con, "CREATE DATABASE datawarehouse;")
dbSendQuery(con, "ALTER DATABASE datawarehouse OWNER TO rdb;")
dbDisconnect(con)


con <- dbConnect(
  drv = odbc(),
  driver = "PostgreSQL ODBC Driver(UNICODE)",
  server = "localhost",
  database = "datawarehouse",
  port = 5432,
  uid = "rdb",
  password = "rdbpass"
)

dbSendQuery(con, "CREATE SCHEMA nycflights13;")
dbWriteTable(con, SQL("nycflights13.flights"), flights)
dbWriteTable(con, SQL("nycflights13.airports"), airports)
dbWriteTable(con, SQL("nycflights13.planes"), planes)
dbWriteTable(con, SQL("nycflights13.weather"), weather)
dbWriteTable(con, SQL("nycflights13.airlines"), airlines)

dbDisconnect(con)

# dbSendQuery(con, "DROP DATABASE datawarehouse;")
# dbSendQuery(con, "DROP ROLE rdb;")
