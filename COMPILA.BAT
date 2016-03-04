set JAVAPATH="C:\Archivos de programa\Java\j2sdk1.4.2_19"
set PATH=%JAVAPATH%\bin;%path%

cd WEB-INF\classes

::javac -target 1.4 -classpath %JAVAPATH%\lib\j2ee.jar;%JAVAPATH%\lib\commons-dbcp-1.3.jar;%JAVAPATH%\lib\commons-pool-1.4.jar ConsultaOracle.java
::javac -target 1.4 -classpath %JAVAPATH%\lib\j2ee.jar;%JAVAPATH%\lib\commons-dbcp-1.3.jar;%JAVAPATH%\lib\commons-pool-1.4.jar ConsultaOracleDes.java
::VER VERSION
::javap -v ConsultaOracle > versionConsultaPool.txt

cd conexion

::javac -target 1.4 -classpath %JAVAPATH%\lib\j2ee.jar;%JAVAPATH%\lib\commons-dbcp-1.3.jar;%JAVAPATH%\lib\commons-pool-1.4.jar conexionOracle.java
::javac -target 1.4 -classpath %JAVAPATH%\lib\j2ee.jar conexionOracle.java
javac -target 1.4 -classpath %JAVAPATH%\lib\j2ee.jar conexionOracleDes.java
::VER VERSION
::javap -v conexionOracle > versionConexionPool.txt


pause