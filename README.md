# codegen
This shell script is generate c/c++ source.

#### Example


Generate c code. create action folder, and create action.c in action folder.


% ./codegen.sh c person person


---
Generate c++ code. create action folder, and create sample::Action class


% ./codegen.sh cpp action sample Action

% ls action

Action.cpp  Action.h  main.cpp  Makefile





---
Generate c++ shared library. create action folder, and create sample::Action class.

shared library name is libact.so

% ./codegen.sh cpp lib action sample Action act

% ls action

Action.cpp  Action.h  main.cpp  Makefile


Create shared library.

% make

g++ -O0 -Wall -g -fPIC -shared -o libact.so Action.cpp

% ls

Action.cpp  Action.h  libact.so  main.cpp  Makefile

Compile main process.

% make test

g++ main.cpp -O0 -Wall -g -fPIC -o main -I. -L$YOUR_DIRECTORY/action -lact

% ls

Action.cpp  Action.h  libact.so  main  main.cpp  Makefile
