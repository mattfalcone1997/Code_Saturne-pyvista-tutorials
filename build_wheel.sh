#!/bin/bash
# This script installs a python wheel with Open MP enabled

#Options
VTK_VERSION=9.3.0
PYBIN=/usr/bin/python3  # select your version of choice
NTHREADS=2
#===============================================================
# Helper functions

test_return () {
      if [ $? -ne 0 ]; then
            echo -e "Error: $1"
            exit $?
      fi
}


#===============================================================
# Use ninja to build if available
if command -v ninja &> /dev/null ; then
      CMD=ninja
      GENERATOR="Ninja"
else
      CMD="make"
      GENERATOR="Unix Makefiles"
fi

echo -e "Using cmake generator ${CMD}"
VTK_DIR=VTK-${VTK_VERSION}

#===========================================================
# Determine if VTK needs to be untared
UNTAR=OFF
if  ! [ -d ${VTK_DIR} ]; then
      UNTAR=ON
fi
TARBALL=${VTK_DIR}.tar.gz

# Determine if vtk needs to be downloaded
DOWNLOAD=OFF
if ! [ -f ${TARBALL} ]; then
      DOWNLOAD=ON
fi

#============================================================
# download tar file
if [ $DOWNLOAD = "ON" ]; then
      wget https://www.vtk.org/files/release/${VTK_VERSION::-2}/${TARBALL}
      test_return "Error downloading $TARBALL"
else
      echo -e "$TARBALL already downloaded"
fi

# untar file
if [ $UNTAR = "ON" ]; then
      tar -xvf $TARBALL
      test_return "Error extracting $TARBALL"
else
      echo -e "${VTK_DIR} already extracted from tarball $TARBALL"
fi

#============================================================
# create build directory
cd $VTK_DIR
mkdir -p build
cd build


# Run cmake
cmake -G${GENERATOR} \
      -DCMAKE_BUILD_TYPE=Release \
      -DVTK_BUILD_TESTING=OFF \
      -DVTK_BUILD_DOCUMENTATION=OFF \
      -DVTK_BUILD_EXAMPLES=OFF \
      -DVTK_DATA_EXCLUDE_FROM_ALL:BOOL=ON \
      -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=OpenMP \
      -DVTK_MODULE_ENABLE_VTK_PythonInterpreter:STRING=NO \
      -DVTK_MODULE_ENABLE_VTK_WebCore:STRING=YES \
      -DVTK_MODULE_ENABLE_VTK_WebGLExporter:STRING=YES \
      -DVTK_MODULE_ENABLE_VTK_WebPython:STRING=YES \
      -DVTK_WHEEL_BUILD=ON \
      -DVTK_PYTHON_VERSION=3 \
      -DVTK_WRAP_PYTHON=ON \
      -DVTK_OPENGL_HAS_EGL=False \
      -DPython3_EXECUTABLE=$PYBIN ../

test_return "Error during configuration"

# build VTK
$CMD -j ${NTHREADS}
test_return "Error during VTK build"


# install python package wheel
$PYBIN -m pip install wheel
test_return "Error installing wheel package"

# Create wheel file for VTK
$PYBIN setup.py bdist_wheel
test_return "Error building VTK wheel"

#Install VTK wheel
$PYBIN -m pip install dist/vtk-*.whl
test_return "Error installing VTK wheel"
