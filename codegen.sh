#!/bin/sh

#
# create c Makefile
#
create_c_makefile()
{
cat << EOT
CXX=gcc
CXXFLAGS= -O0 -Wall -g
LDFLAGS= 
TARGET=main

OPT= 
INC=
LIB=

SRC=\$(shell ls *.c)
HEAD=\$(shell ls *.h)
OBJ=\$(SRC:. c=.o)

all: \$(TARGET)

\$(TARGET): \$(OBJ)
	\$(CXX) \$(CXXFLAGS) -o \$(TARGET) \$(OBJ) \$(LIB)

clean:
	\$(RM) \$(TARGET) *.o
EOT
}


#
# create c header file
#
create_c_h()
{
HEADER=`echo $FILE | tr "[a-z]" "[A-Z]"`

cat << EOT
#ifndef ${HEADER}_H_
#define ${HEADER}_H_
/**
 *
 */
int execute();
#endif // ${HEADER}_H_
EOT
}


#
# create c file
#
create_c()
{
cat << EOT
#include <stdio.h>
#include "$FILE.h"

int execute() {
    return 0;
}
EOT
}


#
# create main
#
create_c_main()
{
cat << EOT
#include <stdio.h>
#include "$FILE.h"

int main(int argc, char **args) {
    return 0;
}
EOT
}




#
# create c++ Makefile
#
create_makefile()
{
cat << EOT
CXX=g++
CXXFLAGS= -O0 -Wall -g
LDFLAGS= 
TARGET=main

OPT= 
INC=
LIB=

SRC=\$(shell ls *.cpp)
HEAD=\$(shell ls *.h)
OBJ=\$(SRC:. cpp=.o)

all: \$(TARGET)

\$(TARGET): \$(OBJ)
	\$(CXX) \$(CXXFLAGS) -o \$(TARGET) \$(OBJ) \$(LIB)

clean:
	\$(RM) \$(TARGET) *.o
EOT
}

#
# create Makefile for shared library
#
create_lib_makefile()
{
cat << EOT
CXX=g++
CXXFLAGS= -O0 -Wall -g -fPIC
LDFLAGS= 
TARGET=lib$SONAME.so
TEST_TARGET=main

OPT= 
INC=
LIB=

SRC=$CLASS.cpp
HEAD=$CLASS.h
OBJ=\$(SRC:. cpp=.o)

all: \$(TARGET)

\$(TARGET): \$(OBJ)
	\$(CXX) \$(CXXFLAGS) -shared -o \$(TARGET) \$(OBJ) \$(LIB)

clean:
	\$(RM) \$(TARGET) *.o

test:
	\$(CXX) main.cpp \$(CXXFLAGS) -o \$(TEST_TARGET) -I. -L\$(CURDIR) -l$SONAME
EOT
}

#
# create cpp file
#
create_cpp()
{
cat << EOT
#include <iostream>
#include "$CLASS.h"

using namespace std;
using namespace $NAMESPACE;

EOT
}

#
# create header file
#
create_h()
{
HEADER=`echo $CLASS | tr "[a-z]" "[A-Z]"`
cat << EOT
#ifndef ${HEADER}_H_
#define ${HEADER}_H_

namespace $NAMESPACE {

/**
 * @class $CLASS
 */
class $CLASS {
public:
    $CLASS() {}
    ~$CLASS() {}
private:

};
} // end of namespace
#endif // ${HEADER}_H_
EOT
}

#
# create main
#
create_main()
{
cat << EOT
#include <iostream>
#include "$CLASS.h"

using namespace std;
using namespace $NAMESPACE;

int main(int argc, char **args) {
    return 0;
}
EOT
}

#
# main processing of shell script
#
case "$1" in
    "c")
        #echo "build c project"
        TYPE=CLANG
        ;;
    "cpp")
        #echo "build c++ project"
        TYPE=CPP
        ;;
    *)
        echo ""
        echo "ERROR!"
        echo ""
        echo "please specify codegen.sh c or codegen.sh cpp"
        echo ""
        exit
        ;;
esac

if [ $TYPE = "CLANG" ]; then
    PROJECT=$2
    if [ $# != 3 ]; then
        echo ""
        echo "USAGE:"
        echo ""
        echo "\tcodegen.sh c project_name file_name\n"
        exit
    fi
    FILE=$3
    if [ ! -e $PROJECT ]; then
        mkdir $PROJECT
    fi
    if [ ! -e $PROJECT/Makefile ]; then
       create_c_makefile $PROJECT > $PROJECT/Makefile
    fi
    if [ ! -e $PROJECT/$FILE.h ]; then
        create_c_h $FILE > $PROJECT/$FILE.h
    fi
    if [ ! -e $PROJECT/$FILE.c ]; then
        create_c $FILE > $PROJECT/$FILE.c
    fi
    if [ ! -e $PROJECT/main.c ]; then
        create_c_main $FILE > $PROJECT/main.c
    fi
    echo "$FILE"
else 
    if [ $# -eq 4 ]; then
        PROJECT=$2
        NAMESPACE=$3
        CLASS=$4

	if [ ! -e $PROJECT ]; then
	    mkdir $PROJECT
	fi
        if [ ! -e $PROJECT/Makefile ]; then
            create_makefile $PROJECT > $PROJECT/Makefile
	fi
        if [ ! -e $PROJECT/$CLASS ]; then
            create_cpp $NAMESPACE > $PROJECT/$CLASS.cpp
	fi
        if [ ! -e $PROJECT/$CLASS.hpp ]; then
            create_h $NAMESPACE $CLASS > $PROJECT/$CLASS.hpp
	fi
        if [ ! -e $PROJECT/main.cpp ]; then
            create_main  $NAMESPACE > $PROJECT/main.cpp
	fi
    elif [ $# -eq 6 ]; then
        case "$2" in
            "test")
                echo "test"
                #            exit
                ;;
            "lib")
                echo "lib"
                #            exit
                ;;
            *)
                echo "error"
                exit
                ;;
        esac
        PROJECT=$3
        NAMESPACE=$4
        CLASS=$5
        SONAME=$6
        	
	if [ ! -e $PROJECT ]; then
	    mkdir $PROJECT
	fi
        if [ ! -e $PROJECT/Makefile ]; then
            create_lib_makefile $PROJECT > $PROJECT/Makefile
	fi
        if [ ! -e $PROJECT/$CLASS ]; then
           create_cpp $NAMESPACE > $PROJECT/$CLASS.cpp
	fi
        if [ ! -e $PROJECT/$CLASS.hpp ]; then
            create_h $NAMESPACE $CLASS > $PROJECT/$CLASS.hpp
	fi
        if [ ! -e $PROJECT/main.cpp ]; then
            create_main  $NAMESPACE > $PROJECT/main.cpp
	fi
    else
        echo ""
        echo "invalid argument"
        echo ""
        echo "USAGE:"
        echo ""
        echo "\tcodegen.sh cpp project_name namespace class_name \n"
        echo "\tor...\n"
        echo "\tcodegen.sh cpp lib project_name namespace class_name so_name\n"
        exit
    fi
fi

