EXE = foamRunCMake

CXX = g++
CC = $(CXX)

INCLUDE_DIRS = \
  -I$(WM_PROJECT_DIR)/src/finiteVolume/lnInclude \
  -IlnInclude \
  -I. \
  -I$(WM_PROJECT_DIR)/src/OpenFOAM/lnInclude \
  -I$(WM_PROJECT_DIR)/src/OSspecific/POSIX/lnInclude

CXXFLAGS = \
  -std=c++14 \
  -m64 \
  -DLIB_NAME=libNULL.so \
  -Dlinux64 \
  -DWM_ARCH_OPTION=64 \
  -DWM_DP \
  -DWM_LABEL_SIZE=32 \
  -Wall \
  -Wextra \
  -Wold-style-cast \
  -Wnon-virtual-dtor \
  -Wno-unused-parameter \
  -Wno-invalid-offsetof \
  -Wno-attributes \
  -O3 \
  -DNoRepository \
  -ftemplate-depth-100 \
  $(INCLUDE_DIRS) \
  -fPIC

LDFLAGS = \
  -fPIC \
  -fuse-ld=bfd \
  -Xlinker --add-needed \
  -Xlinker --no-as-needed \
  -L$(WM_PROJECT_DIR)/platforms/linux64GccDPInt32Opt/lib \
  -lfiniteVolume \
  -lOpenFOAM \
  -ldl \
  -lm

OBJECTS = $(EXE).o setDeltaT.o

$(EXE): $(OBJECTS)

.PHONY: clean
clean:
	$(RM) $(EXE) $(OBJECTS)
