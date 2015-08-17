#!/bin/sh

#
# create Makefile
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
        echo "build c project"
        TYPE=CLANG
        ;;
    "cpp")
        echo "build c++ project"
        TYPE=CPP
        ;;
    *)
        echo "error"
        exit
        ;;
esac

if [ $TYPE = "CLANG" ]; then
    PROJECT=$2
    if [ $# != 3 ]; then
        echo "USAGE:"
        echo "codegen.sh c project file"
        exit
    fi
    FILE=$3
    echo "$PROJECT"
    echo "$FILE"
else 
    if [ $# -eq 4 ]; then
        PROJECT=$2
        NAMESPACE=$3
        CLASS=$4
        echo "$PROJECT"
        echo "$NAMESPACE"
        echo "$CLASS"

        mkdir $PROJECT
        create_makefile $PROJECT > $PROJECT/Makefile
        create_cpp $NAMESPACE > $PROJECT/$CLASS.cpp
        create_h $NAMESPACE $CLASS > $PROJECT/$CLASS.h
        create_main  $NAMESPACE > $PROJECT/main.cpp
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
        
        echo "$PROJECT"
        echo "$NAMESPACE"
        echo "$CLASS"
        echo "$SONAME"

        mkdir $PROJECT
        create_lib_makefile $PROJECT > $PROJECT/Makefile
        create_cpp $NAMESPACE > $PROJECT/$CLASS.cpp
        create_h $NAMESPACE $CLASS > $PROJECT/$CLASS.h
        create_main  $NAMESPACE > $PROJECT/main.cpp
    else
        echo "invalid argument"
        echo $#
    fi
fi

