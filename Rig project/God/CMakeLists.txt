cmake_minimum_required(VERSION 2.8.11)

project(God)



include_directories(
    /home/aron/Desktop/Test_area/Rig project/God/
    /home/aron/Desktop/Test_area/Rig project/God/

)

# Linker options
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS}  ")

# Library path
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS} -L\".\" -L\"/usr/include/hiredis\" -L\"/usr/local/include/\" ")

# Define the C sources
set ( C_SRCS
    main.c
    redis_helper.c
    Helpers.c
)

set_source_files_properties(
    ${C_SRCS} PROPERTIES COMPILE_FLAGS 
    " -g -O0 -Wall")

add_executable(God ${CXX_SRCS} ${C_SRCS})

target_link_libraries(God
    hiredis
    sqlite3
)

