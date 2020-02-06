# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2019
LABEL Description="Qt 5.12.3 from official installation with msvc2017_64 visual studio compiler."

# # Disable crash dialog for release-mode runtimes
RUN reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
RUN reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DontShowUI /t REG_DWORD /d 1 /f

SHELL ["cmd", "/S", "/C"]

# Download the Visual Studio Build Tools bootstrapper.
RUN mkdir "C:\TEMP"
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
COPY .vsconfig C:\TEMP\.vsconfig

# For help on command-line syntax:
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio
# Install MSVC C++ compiler, CMake, and MSBuild.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --config C:\TEMP\.vsconfig || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Install Qt5 5.12.3
COPY qtifwsilent.qs C:\qtifwsilent.qs
RUN powershell -NoProfile -ExecutionPolicy Bypass -Command `
    $ErrorActionPreference = 'Stop'; `
    $Wc = New-Object System.Net.WebClient ; `
    $Wc.DownloadFile('http://download.qt.io/archive/qt/5.12/5.12.3/qt-opensource-windows-x86-5.12.3.exe', 'C:\qt.exe') ; `
    Echo 'Downloaded qt-opensource-windows-x86-5.12.3.exe' ; `
    $Env:QT_INSTALL_DIR = 'C:\Qt' ; `
    Start-Process C:\qt.exe -ArgumentList '--verbose --script C:/qtifwsilent.qs' -NoNewWindow -Wait ; `
    Remove-Item C:\qt.exe -Force ; `
    Remove-Item C:\qtifwsilent.qs -Force
ENV QTDIR_BIN C:\Qt\5.12.3\msvc2017_64\bin
ENV QTDIR C:\Qt\5.12.3\msvc2017_64
RUN dir "%QTDIR%" && dir "%QTDIR_BIN%"

# Install choco for psuedo package manager
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command `
    $Env:chocolateyVersion = '0.10.14' ; `
    $Env:chocolateyUseWindowsCompression = 'false' ; `
    "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
RUN choco install -y python2 --version 2.7.14 && refreshenv && python --version && pip --version
RUN choco install -y qbs && qbs --version
RUN choco install -y unzip --version 6.0 && unzip -v
RUN choco install -y zip --version 3.0 && zip -v
RUN choco install -y cmake
RUN choco install -y windows-sdk-10.1
RUN choco install -y vcredist2008 --version 9.0.30729.6161
RUN choco install -y vcredist2010
RUN choco install -y vcredist2017

# for building the documentation
RUN pip install beautifulsoup4 lxml

WORKDIR C:\Users\ContainerUser

RUN setx path "%path%;C:\Qt\5.12.3\msvc2017_64\bin;C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.16.27023\bin\Hostx64\x64"
RUN setx include "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.16.27023\include"
RUN setx lib "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.16.27023\lib\x64"

COPY vcvars64.bat C:\Users\ContainerUser\vcvars64.bat
CMD C:\Users\ContainerUser\vcvars64.bat && cmd
