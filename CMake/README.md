This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# References

1. **See my full demo project here!:** https://github.com/ElectricRCAircraftGuy/eRCaGuy_Linux_Windows_CMake_Sockets_MSYS2
1. https://cmake.org/
1. Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html
1. My "CMake" section in my answer here: https://stackoverflow.com/a/79203485/4561887


# CMake tutorial

1. https://cmake.org/cmake/help/latest/guide/tutorial/index.html

```bash
# Download the tutorial source code
wget https://cmake.org/cmake/help/latest/_downloads/cf6c5812425488ce7da62bd39aa783bc/cmake-4.0.0-rc4-tutorial-source.zip

# Unzip the source code
unzip cmake-4.0.0-rc4-tutorial-source.zip
```

Commands and things:
```bash
cmake --install . --config Release --prefix ~/cmake
    # Install the project to the specified prefix. The default is /usr/local.
    # This installs to ~/cmake/bin/whatever, ~/cmake/include/whatever.h, and ~/cmake/lib/whatever.a.
    # See: https://cmake.org/cmake/help/latest/guide/tutorial/Installing%20and%20Testing.html 

# Standard CMake procedures
mkdir -p build
cd build
cmake ..                                # Configure the project
cmake --build . --parallel "$(nproc)"   # Build the project
ctest                                   # Test the project

cmake .. -DMY_OPTION=ON
    # <=======
    # Create the C or C++ define `-DMY_OPTION` when configuring the project, so that it will build as such when you call `cmake --build .`.
    # This is equivalent to adding `#define MY_OPTION` to the source code.

cmake .. -DMY_OPTION=OFF
    # Similar to the above, but turn OFF this option so that `#define MY_OPTION` is NOT added to the source code.

cmake -LA .
    # <=======
    # Show all of the CMake variables and their values. This includes the ones set by the user, the ones set by CMake, and the ones set by the compiler.

cmake -LAH .
    # <=======
    # Show all of the CMake variables and their values, **including their help menus!**
    # Ex: this `option()` command in a CMakeLists.txt file:
    # ```cmake
    # # should we use our own math functions
    # option(USE_MYMATH "Use tutorial provided math implementation" ON)
    # ```
    # ...will show up in the output as:
    # ```
    # // Use tutorial provided math implementation
    # USE_MYMATH:BOOL=ON
    # ```
    # See also `ccmake .`.

# When running `cmake`, it generates a build system using the default generator for your platform. Ex: Linux defaults to `-G "Unix Makefiles"`, while Windows defaults to `-G "Ninja"`. You can optionally specify the generator like this, otherwise: 
cmake -G "Unix Makefiles" ..
    # Force CMake to to generate Makefiles for a Make-based build system.
cmake -G "Ninja" ..
    # Force CMake to to generate Ninja build files for a Ninja-based build system.

cmake --help | less -RFX
    # Show help for CMake, the cross-platform build system generator.

cmake -S . -B build
    # <====== BEST! ========
    # Specify the source (`-S .`) and build output (`-B build`) directories. 
    # This is equivalent to running `cmake ..` from the `build` directory.
    # See: https://google.github.io/googletest/quickstart-cmake.html


ctest --test-dir build
    # Run the tests in the `build` directory. This is equivalent to running 
    # `ctest` from the `build` directory as though you had done 
    # `cd build && ctest && cd ..` instead.
    # Added in CMake 3.20. 
    # See: https://cmake.org/cmake/help/latest/manual/ctest.1.html#cmdoption-ctest-test-dir

ctest --test-dir build --output-on-failure
    # <====== BEST! ========
    # Run the tests in the `build` directory and show the stdout and stderr 
    # output of any failed tests, if any fail.

ctest
    # Test the project

ctest --help | less -RFX
    # Show help for ctest, the CMake test runner.

ctest --output-on-failure               # Show stdout/stderr output of failed tests
    # <=======

ctest -N  # List all tests

ctest -R <test_name>  # Run only tests matching <test_name>
    # Ex: `ctest -R Sqrt25`.

ctest -VV
    # <=======
    # Double Verbose output: ie: show/print all output from all tests, even if they pass.
    # This also shows the command used to run the tests.

ctest -C Debug -VV
    # Run the tests in Debug mode, and show all output from all tests, even if they pass.

ctest -C Release -VV
    # Run the tests in Release mode, and show all output from all tests, even if they pass.

ctest -VV -D Experimental
    # "Build the project, run any tests, and submit the results to Kitware's public [CDash] dashboard: https://my.cdash.org/index.php?project=CMakeTutorial."
    # See: 
    # 1. https://my.cdash.org/index.php?project=CMakeTutorial
    # 1. https://cmake.org/cmake/help/latest/guide/tutorial/Adding%20Support%20for%20a%20Testing%20Dashboard.html
    # 1. https://cmake.org/cmake/help/latest/module/CTest.html#module:CTest - "Configure a project for testing with CTest/CDash"


cpack
    # <=======
    # Build a `my_executable-Major.Minor-Linux.tar.gz`-type binary distribution to be installed on other systems. It contains a "bin", "include", and "lib" dir with the following, for example, as shown by `tree`:
    # ```bash
    # Tutorial-1.0-Linux
    # ├── bin
    # │   └── Tutorial
    # ├── include
    # │   ├── MathFunctions.h
    # │   └── TutorialConfig.h
    # └── lib
    #     ├── libMathFunctions.a
    #     └── libSqrtLibrary.a
    # ```
    # See: 
    # 1. https://cmake.org/cmake/help/latest/guide/tutorial/Packaging%20an%20Installer.html
    # 1. https://cmake.org/cmake/help/latest/module/CPack.html#module:CPack

cpack -G ZIP
    # <=======
    # Same as above, but build a `my_executable-Major.Minor-Linux.zip`-type ZIP file instead of a .tgz tarball for the system installer package.
    # See: https://cmake.org/cmake/help/latest/guide/tutorial/Packaging%20an%20Installer.html

cpack --config CPackSourceConfig.cmake
    # <=======
    # Package up all of the source code and CMake files ("CMakeLists.txt" + *.cmake files) into a `my_executable-Major.Minor-Source.tar.gz`-type file. 
    # See: https://cmake.org/cmake/help/latest/guide/tutorial/Packaging%20an%20Installer.html

cpack --help
    # Show help for cpack, the CMake package/installer generator.


ccmake .
    # Run the CMake TUI (Text User Interface) ncurses-based tool to configure the project.
    # See: https://cmake.org/cmake/help/latest/manual/ccmake.1.html
    # Use arrow keys (up/down) to navigate, Enter to change a value, and then `c` to configure the project, and `g` to generate the project and exit. 
    # - USEFUL to explore a project and see what options are available.
    #   See also `cmake -LAH .`.

cmake-gui .
    # Run the CMake GUI to configure the project.
    # See: https://cmake.org/cmake/help/latest/manual/cmake-gui.1.html

```
