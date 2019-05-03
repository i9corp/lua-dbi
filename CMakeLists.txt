cmake_minimum_required(VERSION 3.7)
project(dbdpostgresql)

set(CMAKE_C_STANDARD 11)

set(DBDMYSQL dbdmysql)
set(DBDPSQL dbdpostgresql)
set(DBDSQLITE3 dbdsqlite3)
set(DBDDB2 dbddb2)
set(DBDORACLE dbdoracle)

include_directories(.)
#include_directories(db2)
#include_directories(mysql)
#include_directories(oracle)
#include_directories(dbd/postgresql)
#include_directories(sqlite3)

#add_library(${DBDMYSQL} SHARED mysql/connection.c mysql/dbd_mysql.h mysql/main.c mysql/statement.c common.c common.h)
#target_link_libraries(${DBDMYSQL} mysql)

#add_library(${DBDPSQL} SHARED postgresql/connection.c postgresql/dbd_postgresql.h postgresql/main.c postgresql/statement.c common.c common.h)
#target_link_libraries(${DBDMYSQL} postgresql)
#
#add_library(${DBDDB2} SHARED db2/connection.c db2/dbd_db2.h db2/main.c db2/statement.c common.c common.h)
#target_link_libraries(${DBDMYSQL} db2)
#
#add_library(${DBDSQLITE3} SHARED sqlite3/connection.c sqlite3/dbd_sqlite3.h sqlite3/main.c sqlite3/statement.c common.c common.h)
#target_link_libraries(${DBDMYSQL} sqlite3)
#
#add_library(${DBDORACLE} SHARED oracle/connection.c oracle/dbd_oracle.h oracle/main.c oracle/statement.c common.c common.h)
#target_link_libraries(${DBDMYSQL} oracle)

find_package(Lua51 REQUIRED)
find_package(PostgreSQL REQUIRED)

include_directories(${PostgreSQL_INCLUDE_DIRS} ${LUA_INCLUDE_DIR})

add_library(${PROJECT_NAME} SHARED dbd/postgresql/connection.c dbd/postgresql/dbd_postgresql.h dbd/postgresql/main.c dbd/postgresql/statement.c dbd/common.c dbd/common.h)
target_link_libraries(${PROJECT_NAME} ${PostgreSQL_LIBRARIES} ${LUA_LIBRARIES})