cmake_minimum_required(VERSION 2.8.11)

project(Controller)



include_directories(
    /home/aron/Desktop/Test_area/Rig project/Controller/
    /home/aron/Desktop/Test_area/Rig project/Controller/

)

# Linker options
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS}  ")

# Library path
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS} -L\".\" ")

# Define the C sources
set ( C_SRCS
    main.c
    Core.c
    ../libss/ABE_IoPi.c
    ../God/redis_helper.c
)

set_source_files_properties(
    ${C_SRCS} PROPERTIES COMPILE_FLAGS 
    " -g -O0 -Wall")

add_executable(Controller ${CXX_SRCS} ${C_SRCS})

target_link_libraries(Controller
    hiredis
    sqlite3
)

