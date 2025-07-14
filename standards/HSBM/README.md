# Standardising Microcontrollers Handshakes

    An minimal, universal handshake between two microcontrollers (will be referred as an "mcu" now on)
    providing enstablished communication

## Rules

    - Two sided must have at least one implemented standard
    - If one side doesnt know the standard, and cant get it. The interaction cannot proced without setting known standerd
    - The firsts interaction between two mcu's must confirm the standard they will use for further communication / usage

## Sample

    [Example implementation](sample.luau) of HSBM
