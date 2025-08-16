# Handshake Standard Between Microcontrollers (HSBM) v1.0.0-alpha

A minimal and universal handshake between two microcontrollers, 
ensuring successful and intentional communication.

>[!NOTE]
>Microcontroller will be referred to as mcu from now on.

### Requesting protocol information 
To get protocol info of othermcu, send only the string "HSBM_REQ"
```luau
othermcu:Send("HSBM_REQ")
```
>[!NOTE]
>Expect a response after request.

### Responding to the Handshake 
After receiving an "HSBM_REQ" message, <strong>we must send back two arguments: "HSBM" string and protocol metadata table</strong>

```luau
sender:Send("HSBM_RES",PROTOCOL_INFO)
```
### Protocol metadata format

>[!IMPORTANT]
>Responce must be a table, with exact field names and structure shown below.

```luau
local PROTOCOL_INFO = {
    protocol = {
        name: string = "ProtocolName",
        version = { -- standard version in SemVer
            major: number = 1,
            minor: number = 0,
            patch: number = 0
        }
    }
}
```
