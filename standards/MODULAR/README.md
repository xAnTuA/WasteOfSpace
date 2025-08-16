



### Rules

There must be object called "Program" with we will be using for info about running script.
And it must contain values of isListening, and info

```luau
local PROGRAM = { 
    isListening = true,
    info = {
        name            = "Module Name",
        description     = "What does module do?",
        author          = "Ur Nickname",
        softwareVersion = {
            major = 1,
            minor = 0,
            patch = 0
        },
        hardwareVersion = {
            major = 1,
            minor = 0,
            patch = 0
        },
        functions
    }
}

function PROGRAM:IdentifyTo(target)
    target:Send(PROGRAM.info);
end
```

1. Microcontrollers ment to be communicate more that one time, should listen all the time

```luau
while PROGRAM.isListening do
    Program:Receive(Microcontroller:Receive())
end
```
