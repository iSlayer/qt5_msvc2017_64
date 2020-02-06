# qt5_msvc2017_64
A dockerfile that will build an image with Qt 5.12.3 and Visual Studio 2017 with compiler msvc2017_64. 

## Information
When the docker image starts running, a .bat script in the home directory: C:\Users\ContainerUser\vcvars64.bat is executed to setup the visual studio compiler environment variables. Then everything should be ready to build and run.

## Example:
Below is an example on how to build and run Qt5 projects using one of the Qt5 Example projects.

    cd C:\Qt\Examples\Qt-5.12.3\qtestlib\tutorial1
    mkdir build && cd build
    %QTDIR%\bin\qmake.exe ..\tutorial1.pro -spec win32-msvc "CONFIG+=qtquickcompiler" && C:\Qt\Tools\QtCreator\bin\jom.exe qmake_all
    C:\Qt\Tools\QtCreator\bin\jom.exe
    cd release
    tutorial1.exe
