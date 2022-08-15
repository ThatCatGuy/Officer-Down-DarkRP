# Officer-Down-DarkRP

https://steamcommunity.com/sharedfiles/filedetails/?id=2540887476

This script alerts all other officers when one is killed somewhere on the map and it shows a hud icon to the location they died at so you know where to go to. It removes itself after 30 seconds.

Update: I have now included a ping option when a CP can type **/backup** or **!backu**p and it will alert other cps of their current location on the hud.  I have also added some convar options for stuff.

Client Convars:

**officerdown_show 1** - **1 (True)** by default setting to 0 will disable the hud display and sounds from this addon.
**officerdown_removedelay 45** - **45 seconds** this is how long the icon stays on the hud once it appears. 

Server Convars:

**officerdown_assistdelay 120** - **120 Seconds** by default this is how long the delay is before this commands **/backup** or **!backup** can be used again.
**officerdown_wanttime 300** - **300 Seconds** by default this is how long the player will be wanted for once they kill an officer.
