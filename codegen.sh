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
if [ "$#" != 3 ]; then
    echo "USAGE:"
    echo "codegen.sh project namespace class"
    exit
fi

PROJECT=$1
NAMESPACE=$2
CLASS=$3

mkdir $PROJECT
create_makefile $PROJECT > $PROJECT/Makefile
create_cpp $NAMESPACE > $PROJECT/$CLASS.cpp
create_h $NAMESPACE $CLASS > $PROJECT/$CLASS.h
create_main  $NAMESPACE > $PROJECT/main.cpp
