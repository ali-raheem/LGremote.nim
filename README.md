# LGremote.nim

Control legacy LG TVs from circa 2012. More details [here](https://github.com/ali-raheem/LGRemote.rs) (link is an older Rust version).

## Usage

* `./LGremote TV_IP TV_PORT` - show auth key on TV
* `./LGremote TV_IP TV_PORT KEY` - show auth with TV (idk how long an auth lasts)
* `./LGremote TV_IP TV_PORT CMD` - send command to TV (only works if already auth'd)
* `./LGremote TV_IP TV_PORT KEY CMD` - Auth with TV then send command
* `./LGremote TV_IP TV_PORT KEY SCREENSHOT OUTFILE.JPG` - Save a screenshot to a file

### Example

* `./LGremote 192.168.1.101 8080 6942069 HOME` - Opens the `HOME` menu.

The command key `HOME`, `POWER` etc is case insenstive and ignores `_`.

* `./LGremote 192.168.1.101 8080 6942069 SCREENSHOT screenshot.jpg`
On the other hand `SCREENSHOT` must be in caps and you must provide and output file.

## Building

`nim c --opt:speed --verbosity:0 LGremote.nim`

## Commands

There are roughly two types of commands that these TVs can accept.
1. Post Commands
  a. HandleKeyInput - basically what you might press on a traditional controller - SUPPORTED
  b. Touch controls - what you would use a special controller for - NOT YET SUPPORTED
2. Get Commands - request info about the current state - SUPPORTED

### Key commands

| Command | Key | Notes |
| --------|-----|------ |
| POWER | 1 | Can power the TV off but not on. Consider trying Wake on lan (not all TVs support this). |
| NUM_0 | 2 |  |
| NUM_1 | 3 |  |
| NUM_2 | 4 |  |
| NUM_3 | 5 |  |
| NUM_4 | 6 |  |
| NUM_5 | 7 |  |
| NUM_6 | 8 |  |
| NUM_7 | 9 |  |
| NUM_8 | 10 |  |
| NUM_9 | 11 | |
| UP | 12 |  |
| DOWN | 13 |  |
| LEFT | 14 |  |
| RIGHT | 15 |  |
| OK | 20 |  |
| HOME | 21 |  |
| MENU | 22 |  |
| BACK | 23 |  |
| VOLUME_UP | 24 |  |
| VOLUME_DOWN | 25 |  |
| MUTE | 26 |  |
| CHANNEL_UP | 27 |  |
| CHANNEL_DOWN | 28 |  |
| BLUE | 29 |  |
| GREEN | 30 |  |
| RED | 31 |  |
| YELLOW | 32 |  |
| PLAY | 33 |  |
| PAUSE | 34 |  |
| STOP | 35 |  |
| FF | 36 |  |
| REW | 37 |  |
| SKIP_FF | 38 |  |
| SKIP_REW | 39 |  |
| REC | 40 |  |
| REC_LIST | 41 |  |
| LIVE | 43 |  |
| EPG | 44 |  |
| INFO | 45 |  |
| ASPECT | 46 |  |
| EXT | 47 |  |
| PIP | 48 |  |
| SUBTITLE | 49 |  |
| PROGRAM_LIST | 50 |  |
| TEXT | 51 |  |
| MARK | 52 |  |
| 3D | 400 |  |
| 3D_LR | 401 |  |
| DASH | 402 |  |
| PREV | 403 |  |
| FAV | 404 |  |
| QUICK_MENU | 405 |  |
| TEXT_OPTION | 406 |  |
| AUDIO_DESC | 407 |  |
| NETCAST | 408 |  |
| ENERGY_SAVE | 409 |  |
| AV | 410 |  |
| SIMPLINK | 411 |  |
| EXIT | 412 |  |
| RESERVED | 413 | Does nothing? |
| PIP_CHANNEL_UP | 414 |  |
| PIP_CHANNEL_DOWN | 415 |  |
| PIP_SWITCH | 416 |  |
| APPS | 417 |  |

### Request Commands

| Command | Target | Notes |
|---------|--------|-------|
| SCREENSHOT | screen_image | Returns JPEG data in body |
| CHANNEL | cur_channel | Returns XML data about current channel |
| CHANNELS | channel_list | Returns XML list of channels programmed into computer |
| VOLUME | volume_info | Returns XML data about min, max and current volume |
| CONTEXT | context_ui | Returns XML data about the context, what controls can work etc |
| 3D | is_3d | Returns XML data if currently in 3D mode |

### Not working

* HandleTouchMove - I'll need to log some traffic to workout format
* HandTouchClick - Ditto
* HandleTouchWheel - Ditto
* HandleChannelChange - Ditto
* AppExecute - Ditto!!!

# Resources/References
Unfortunately official documentation doesn't seem to be available any longer but several libraries and scripts are available. node-lgtv-api[4]  is by far the most complete and useful project.
1. https://github.com/ubaransel/lgcommander
2. https://github.com/grieve/python-lgtv - this is where the command codes are from largely.
3. http://dorchain.net/~joerg/code/lg.py
4. https://github.com/timmson/node-lgtv-api - most useful
5. https://developer.lgappstv.com/TV_HELP/index.jsp?topic=%2Flge.tvsdk.references.book%2Fhtml%2FUDAP%2FUDAP%2FAnnex - defunct

## License
MIT licensed as that is in keeping with previous projects.
