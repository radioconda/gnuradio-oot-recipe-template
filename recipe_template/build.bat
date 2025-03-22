setlocal EnableDelayedExpansion
@echo on

:: Make a build folder and change to it
cmake -E make_directory buildconda
cd buildconda

:: configure
cmake -G "Ninja" %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX="%PREFIX%\Library" ^
    -DCMAKE_PREFIX_PATH="%PREFIX%\Library" ^
    -DGR_PYTHON_DIR="%SP_DIR%" ^
    -DENABLE_DOXYGEN=OFF ^
    -DENABLE_TESTING=ON ^
    ..
if errorlevel 1 exit 1

:: build
cmake --build . --config Release -- -j%CPU_COUNT%
if errorlevel 1 exit 1

:: install
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: test
ctest --build-config Release --output-on-failure --timeout 120 -j%CPU_COUNT%
if errorlevel 1 exit 1
