# Handshake Standard Between Microcontrollers (HSBM)

A minimal and universal handshake between two microcontrollers, 
ensuring successful and intentional communication.

>[!NOTE]
>Microcontroller will be referred to as mcu from now on.

### Initiating the Handshake
To get protocol info of othermcu, send only the string "HSBM"
```luau
othermcu:Send("HSBM")
```
>[!NOTE]
>Expect a response after sending "HSBM".

### Responding to the Handshake 
After receiving an "HSBM" message, <strong>we must send back two arguments: "HSBM" string and protocol metadata table</strong>

```luau
local function HSBM(sender)
    sender:Send("HSBM",PROTOCOL_INFO)
end
```
### Protocol metadata format

>[!IMPORTANT]
>Responce must be a table, with exact field names and structure shown below.

```luau
local PROTOCOL_INFO = {
    protocol = {
        name = "ProtocolName", -- string
        version = {
            major = 1,         -- number
            minor = 0,         -- number
            patch = 0          -- number
        },
        url = "https://example.com" -- string (specification or documentation)
    }
}
```
