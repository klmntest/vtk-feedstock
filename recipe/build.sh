#!/bin/bash
mkdir build
cd build 

if [ "$(uname -s)" == "Linux" ]; then
  DYNAMIC_EXT="so"
  SCREEN_ARGS=(
      "-DVTK_USE_X=OFF"
      "-DVTK_OPENGL_HAS_OSMESA:BOOL=ON"
  )
fi

if [ "$(uname -s)" == "Darwin" ]; then
  DYNAMIC_EXT="dylib" 
  SCREEN_ARGS=(
      "-DVTK_USE_X:BOOL=OFF"
      "-DVTK_USE_COCOA:BOOL=ON"
      "-DVTK_USE_CARBON:BOOL=OFF"
  )
fi

if [[ $PY3K -eq 1 || $PY3K == "True" ]]; then
  export PY_STR="${PY_VER}m"
else
  export PY_STR="${PY_VER}"
fi

cmake -LAH -G "Ninja" .. \
  -DCMAKE_OSX_DEPLOYMENT_TARGET="10.9" \
  -DCMAKE_OSX_SYSROOT="$HOME/MacOSX-SDKs/MacOSX10.9.sdk" \
  -DBUILD_DOCUMENTATION=0 \
  -DBUILD_EXAMPLES=0 \
  -DBUILD_SHARED_LIBS=1 \
  -DBUILD_TESTING=0 \
  -DCMAKE_BUILD_TYPE="Release" \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DINSTALL_BIN_DIR="$PREFIX"/bin \
  -DINSTALL_INC_DIR="$PREFIX"/include \
  -DINSTALL_LIB_DIR="$PREFIX"/lib \
  -DINSTALL_PKGCONFIG_DIR="$PREFIX"/lib/pkgconfig \
  -DPYTHON_EXECUTABLE="$PYTHON" \
  -DVTK_INSTALL_PYTHON_MODULE_DIR="$SP_DIR" \
  -DPYTHON_LIBRARY="$PREFIX/lib/libpython$PY_STR.$DYNAMIC_EXT" \
  -DVTK_PYTHON_SITE_PACKAGES_SUFFIX="$SP_DIR" \
  -DVTK_PYTHON_VERSION="${PY_VER}" \
  -DVTK_RENDERING_BACKEND="OpenGL2" \
  -DVTK_INSTALL_PYTHON_USING_CMAKE:BOOL=ON \
  -DVTK_LEGACY_SILENT:BOOL=ON \
  -DVTK_WRAP_JAVA=0 \
  -DVTK_WRAP_TCL=0 \
  -DVTK_WRAP_PYTHON=1 \
  -DCMAKE_CXX_STANDARD=11 \
  -DCMAKE_CXX_STANDARD_REQUIRED=ON \
  -DCMAKE_CXX_EXTENSIONS=OFF \
  ${SCREEN_ARGS[@]}

ninja install