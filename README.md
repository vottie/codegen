# codegen
This shell script is generate c/c++ source.

#### example


cのソースを生成。personフォルダにperson.cを作成する


% ./codegen.sh c person person


---
c++のソースを生成。personフォルダにnamespace:sampleのPersonクラスを生成。


% ./codegen.sh cpp person sample Person


---
c++の共有ライブラリを生成。personフォルダにnamespace:sampleのPersonクラスを生成。makeでlibperson.soを作成し、make testでmainを実行する。


% ./codegen.sh cpp lib person sample Person person


