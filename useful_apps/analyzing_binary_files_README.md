This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Tools for analyzing binary files

See also the "Binary and ELF file analyzer:" section in my Git & Linux document: [git & Linux cmds, help, tips & tricks - Gabriel.txt](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/git%20%26%20Linux%20cmds%2C%20help%2C%20tips%20%26%20tricks%20-%20Gabriel.txt).

Research:

1. [Google search for "elf file memory analyzer"](https://www.google.com/search?q=elf+file+memory+analyzer&oq=elf+file+memory+analyzer&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCTI0Mzg5ajBqNKgCALACAA&sourceid=chrome&ie=UTF-8)

1. [BEST I'VE USED SO FAR, BY FAR!] https://github.com/jedrzejboczar/elf-size-analyze
    ```bash
    # Install 
    pip3 install elf-size-analyze

    # Example usage for Microchip PIC32 mcu to analyze RAM (`-R`) usage
    
    elf-size-analyze -t xc32- -HaR path/to/Autopilot.X.production.elf

    # Store the output into a file
    elf-size-analyze -t xc32- -HaR path/to/Autopilot.X.production.elf > elf-size-analyze_output.txt
    ```

1. https://github.com/google/bloaty - Google's Bloaty McBloatface.
    ```bash
    # Install
    
    git clone https://github.com/google/bloaty.git
    cd bloaty
    time git submodule update --init --recursive

    sudo apt update
    sudo apt install cmake build-essential ninja-build
    
    time cmake -B build -G Ninja -S .
    time cmake --build build
    time sudo cmake --build build --target install
    
    # Check that it's installed!
    bloaty --help
    bloaty --version

    # Example usages
    # See: https://fuchsia.googlesource.com/third_party/bloaty/+/refs/tags/v1.1/README.md
    
    bloaty path/to/Autopilot.X.production.elf
    bloaty path/to/Autopilot.X.production.elf -d compileunits
    bloaty path/to/Autopilot.X.production.elf -d segments,sections
    bloaty path/to/Autopilot.X.production.elf -d sections
    ```

1. [Google search for "elf file size analyzer"](https://www.google.com/search?q=elf+file+size+analyzer&oq=elf+file+size+analyzer&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBBzMwMGowajmoAgCwAgA&sourceid=chrome&ie=UTF-8)

1. `nm`:
    
    ```bash
    # Example:
    nm --print-size --size-sort --radix=d tst.o
    
    # Or: 
    nm --print-size --size-sort --radix=d path/to/Autopilot.X.production.elf
    ```

    See: https://stackoverflow.com/a/11720779/4561887

