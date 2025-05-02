# codegen
This shell script is generate c/c++ source.

# Example

## Generate c code.

Generate c code. create action folder, and create action.c in action folder.

```
% ./codegen.sh c person person
```


## Generate c++ code.

Generate c++ code. create action folder, and create sample::Action class


```
% ./codegen.sh cpp action sample Action
% ls action
Action.cpp  Action.h  main.cpp  Makefile
```

## Generate c++ shared library.

Generate c++ shared library. create action folder, and create sample::Action class.

shared library name is libact.so

```
% ./codegen.sh cpp lib action sample Action act
% ls action
Action.cpp  Action.h  main.cpp  Makefile
```

Create shared library.

```
% make
g++ -O0 -Wall -g -fPIC -shared -o libact.so Action.cpp
% ls
Action.cpp  Action.h  libact.so  main.cpp  Makefile
```

Compile main process.

```
% make test
g++ main.cpp -O0 -Wall -g -fPIC -o main -I. -L$YOUR_DIRECTORY/action -lact
% ls
Action.cpp  Action.h  libact.so  main  main.cpp  Makefile
```

## Generate python code.

Generate python code. Create a project folder and generate a class file and main.py in the folder.

```
% ./codegen.sh py project_name class_name
% ls project_name
class_name.py  main.py
```

Example of generated files:

- `class_name.py`:
  ```python
  # -*- coding: utf-8 -*-
  
  class class_name:
      def __init__(self):
          pass
  
      def execute(self):
          print('')
  ```
- `main.py`:
  ```python
  # -*- coding: utf-8 -*-
  
  from class_name import class_name
  
  if __name__ == '__main__':
      cls = class_name()
      cls.execute()
  ```

## Generate ruby code.

Generate ruby code. Create a project folder and generate a class file and main.rb in the folder.

```
% ./codegen.sh rb project_name class_name
% ls project_name
class_name.rb  main.rb
```

Example of generated files:

- `class_name.rb`:
  ```ruby
  class ClassName
    def initialze()
    end

    def execute()
    end
  end
  ```
- `main.rb`:
  ```ruby
  require './class_name.rb'

  def main
    k = ClassName.new()
    k.execute()
  end

  if __FILE__ == $0
    main
  end
  ```

## Generate go code.

Generate go code. Create a project folder and generate a module folder, go file, main.go, and build.sh in the folder.

```
% ./codegen.sh go project_name module_name
% ls project_name
build.sh  main.go  module_name/
% ls project_name/module_name
module_name.go
```

Example of generated files:

- `module_name/module_name.go`:
  ```go
  package project_name

  import "fmt"

  func Execute() {
      fmt.Printf("Hello World\n")
  }
  ```
- `main.go`:
  ```go
  package main

  import "project_name/module_name"

  func main() {
    module_name.Execute()
  }
  ```
- `build.sh`:
  ```sh
  go build project_name/module_name.go
  go mod init module_name
  go build main.go
  ```

