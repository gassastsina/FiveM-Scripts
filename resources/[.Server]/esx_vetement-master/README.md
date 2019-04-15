# fxserver-esx_glasses
FXServer ESX Glasses

[REQUIREMENTS]

- esx_skin => https://github.com/ESX-Org/esx_skin
- esx_datastore => https://github.com/ESX-Org/esx_datastore

[INSTALLATION]

1) CD in your resources/[esx] folder
2) Clone the repository
3) Import esx_glasses.sql in your database
4) Add this in your server.cfg :

```
start baseevents
start esx_glasses
```
