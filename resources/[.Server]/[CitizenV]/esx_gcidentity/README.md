# esx_gcidentity
################


CREDITS TO :


GC Gannon for main script

Chubbs for editing it for ESX


################


FXserver ESX GCIdentity

Credit to GC Gannon for "GCIdentity"

Edited by Chubbs

[INSTALLATION]

1) CD in your resources/[esx] folder
2) Clone the repository


3) Add this in your server.cfg :

```
start esx_gcidentity
```
To open the identity card just use

```
TriggerEvent("gcl:showItentity", ...)
```

You can press E to see if you did it right ( A ID will appear on the screen ) 

then to take that out go to client.lua

remove this code

```
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlPressed(1,  38) then
      TriggerServerEvent('gc:openMeIdentity')
    end
  end
end)
```

![alt text](https://image.prntscr.com/image/CiKwlfZSQSWdhHcnw1x2EQ.png)
