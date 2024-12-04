# External Ceres repo
This is the repo that builds ceres and its dependents for for use in wpical. It uses vcpkg to build all the dependencies and Gradle to package it for use in allwpilib.

# Getting Started
The build requirements are the same as [allwpilib](https://github.com/wpilibsuite/allwpilib/?tab=readme-ov-file#requirements).

1. Clone the repo with `git clone --recursive https://github.com/wpilibsuite/thirdparty-ceres.git`. This will also initialize the vcpkg submodule.
2. Build the libraries with `gradlew buildVcpkg` and publish the artifacts locally with `gradlew publish`.

## Important notes
### Overlay ports
There are two overlay ports for blas and lapack. By default on x86-64 Windows, vcpkg will use lapack-reference and its cblas feature, which is an issue because it requires shared libraries for the gfortran dependency, which we can't use for a static build. (The DLL list is libblas.dll, libgcc_s_seh-1.dll, libgfortran-5.dll, liblapack.dll, libquadmath-0.dll, libwinpthread-1.dll)

To solve this, overlay ports were used to override the blas port to use openblas and the lapack port to use clapack, avoiding the gfortran dependency and allowing a completely static build. This is the same setup as ARM Windows (which is where this setup was copied from.)

### Triplets
The vcpkg triplets used for Windows end in `-static-md`. This enables static library building, but dynamic linkage to the CRT, which [matches the way WPILib builds](https://github.com/wpilibsuite/native-utils/blob/main/src/main/java/edu/wpi/first/nativeutils/WPINativeUtilsExtension.java#L45).