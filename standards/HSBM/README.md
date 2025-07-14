# Handshake Standard Between Microcontrollers (HSBM)

An minimal, universal handshake between two microcontrollers 
providing 

>[!NOTE]
>will be referred as an "mcu" now on

## Rules of implementation

#### 1. The mcu that wants to enstablish connection need to send as an argument only "HSBM" as an string
```luau
othermcu:Send("HSBM")
```
#### 2. mcu after sending request shall wait for responce
>[!IMPORTANT]
>To keep mcu not frozen awaiting for an responce, create new task

```luau
-- we can store mcu's information in table
local othermcu = {[number]:{ standard: string }} -- the key is an mcu's reference

local function HSBM_x(sender, info)
    
end

local awaitForResponce = coroutine.create(HSBM_x)

-- after sending "HSBM"
local success,result = coroutine.resume(awaitForResponce,Micrrocontroller:Receive())
```

#### 3. Microcontroller if get the command "HSBM" needs to respond with info about protocol it is using for communication

```luau
local function HSBM(sender)
    sender:Send(HSBM_INFO)
end
```

- info must be an table and it structure <b>must</b> look like:

```luau
local HSBM_INFO = {
    protocol = {
        name:       string
        version:    { major: number, minor: number, patch: number }
        url:        string
    }
}
```


## Sample

[Example implementation](sample.luau) of HSBM
