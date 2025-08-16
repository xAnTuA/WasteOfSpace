# Handshake Standard Between Microcontrollers (HSBM) v1.0.0-beta

A minimal and universal handshake between two microcontrollers, 
ensuring successful and intentional communication.
In with every communication attempt has first argument as command.

>[!IMPORTANT]
>First argument is ALWAYS command. Using first argument as command in protocols can benefit most actions between microcontrollers especially asynch calls.

>[!NOTE]
>Microcontroller will be referred to as mcu from now on.

### Requesting protocol information 
Requesting can be done by sending command "REQ_PROTOCOL"

```luau
othermcu:Send("REQ_PROTOCOL")
```
>[!NOTE]
>Expect a response after request.

### Responding to the Handshake 
After receiving an "REQ_PROTOCOL" command , <strong>script shall return protocol name and version to asker</strong> 


```luau
target:Send("RES_PROTOCOL","PROTOCOL_NAME","1.0.0")
```
