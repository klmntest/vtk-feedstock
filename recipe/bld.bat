mkdir wk
cd wk

set BUILD_CONFIG=Release

:: tell cmake where Python is
set PYTHON_LIBRARY=%PREFIX%\libs\python%PY_VER:~0,1%%PY_VER:~2,1%.lib

cmake .. -G "Ninja" ^
    -Wno-dev ^
    -DCMAKE_BUILD_TYPE=%BUILD_CONFIG% ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DBUILD_DOCUMENTATION:BOOL=OFF ^
    -DBUILD_TESTING:BOOL=OFF ^
    -DBUILD_EXAMPLES:BOOL=OFF ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DPYTHON_EXECUTABLE:FILEPATH="%PYTHON%" ^
    -DPYTHON_INCLUDE_DIR:PATH="%PREFIX%\include" ^
    -DPYTHON_LIBRARY:FILEPATH="%PYTHON_LIBRARY%" ^
    -DVTK_USE_SYSTEM_ZLIB:BOOL=ON ^
    -DModule_vtkPythonInterpreter:BOOL=OFF ^
    -DVTK_WRAP_PYTHON:BOOL=ON ^
    -DVTK_PYTHON_VERSION:STRING="%PY_VER%" ^
    -DVTK_INSTALL_PYTHON_MODULE_DIR:PATH="%SP_DIR%" ^
    -DVTK_HAS_FEENABLEEXCEPT:BOOL=OFF ^
    -DVTK_RENDERING_BACKEND=OpenGL2 ^
    -DModule_vtkRenderingMatplotlib=ON ^
	-DCMAKE_CXX_STANDARD=11 ^
    -DCMAKE_CXX_STANDARD_REQUIRED=ON ^
    -DCMAKE_CXX_EXTENSIONS=OFF 
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

REM write a dummy egg-info file so that
REM     > pkg_resources.require('vtk')
REM will work and mayavi / traits can import vtk
set egg_info_fname=%PKG_NAME%-%PKG_VERSION%-py%PY_VER%.egg-info
IF NOT EXIST %egg_info_fname% (
  ECHO Metadata-Version: 1.1>>%egg_info_fname%
  ECHO Name: ${PKG_NAME}>>%egg_info_fname%
  ECHO Version: ${PKG_VER}>>%egg_info_fname%
)
