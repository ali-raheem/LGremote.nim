import std/httpclient, std/strutils, std/strtabs, os

var
    commands = newStringTable({"POWER": "1", "NUM_0": "2", "NUM_1": "3", "NUM_2": "4", "NUM_3": "5", "NUM_4": "6", "NUM_5": "7", "NUM_6": "8", "NUM_7": "9", "NUM_8": "10", "NUM_9": "11", "UP": "12", "DOWN": "13", "LEFT": "14", "RIGHT": "15", "OK": "20", "HOME": "21", "MENU": "22", "BACK": "23", "VOLUME_UP": "24", "VOLUME_DOWN": "25", "MUTE": "26", "CHANNEL_UP": "27", "CHANNEL_DOWN": "28", "BLUE": "29", "GREEN": "30", "RED": "31", "YELLOW": "32", "PLAY": "33", "PAUSE": "34", "STOP": "35", "FF": "36", "REW": "37", "SKIP_FF": "38", "SKIP_REW": "39", "REC": "40", "REC_LIST": "41", "LIVE": "43", "EPG": "44", "INFO": "45", "ASPECT": "46", "EXT": "47", "PIP": "48", "SUBTITLE": "49", "PROGRAM_LIST": "50", "TEXT": "51", "MARK": "52", "3D": "400", "3D_LR": "401", "DASH": "402", "PREV": "403", "FAV": "404", "QUICK_MENU": "405", "TEXT_OPTION": "406", "AUDIO_DESC": "407", "NETCAST": "408", "ENERGY_SAVE": "409", "AV": "410", "SIMPLINK": "411", "EXIT": "412", "RESERVED": "413", "PIP_CHANNEL_UP": "414", "PIP_CHANNEL_DOWN": "415", "PIP_SWITCH": "416", "APPS": "417"}, modeStyleInsensitive)

type
  Tv = object
    ip: string
    port: string
    key: string
    paired: bool
    c: HttpClient

const
  authURL = "http://$#:$#/roap/api/auth"
  cmdURL = "http://$#:$#/roap/api/command"
  displayKey = """
<?xml version="1.0" encoding="utf-8"?>
 <auth>
  <type>AuthKeyReq</type>
 </auth>";"""
  authReq = """
<?xml version=\"1.0\" encoding=\"utf-8\"?>
 <auth>
  <type>AuthReq</type>
  <value>$#</value>
 </auth>
"""
  cmdReq = """
<?xml version="1.0" encoding="utf-8"?>
 <command>
  <name>HandleKeyInput</name>
  <value>$#</value>
 </command>
 """

proc showAuthKey(tv: Tv): Response =
  let res = tv.c.request(authURL % [tv.ip, tv.port], httpMethod = HttpPost, body = displayKey)
  return res

#[ proc authWithKey(tv: Tv, key: string): Response =
  tv.key = key
  let res = tv.c.request(authURL % [tv.ip, tv.port], httpMethod = HttpPost, body = authReq % tv.key)
  return res ]#

proc auth(tv: Tv): Response =
  let res = tv.c.request(authURL % [tv.ip, tv.port], httpMethod = HttpPost, body = authReq % tv.key)
  return res

proc sendCommand(tv: Tv, cmd: string): Response =
  let res = tv.c.request(cmdURL % [tv.ip, tv.port], httpMethod = HttpPost, body = cmdReq % commands[cmd])
  return res


if paramCount() == 2:
  var tv = Tv(ip: paramStr(1), port: paramStr(2), c: newHttpClient())
  tv.c.headers = newHttpHeaders({ "Content-Type": "application/atom+xml"})
  discard showAuthKey(tv)
if paramCount() == 3:
  if paramStr(3) in commands:
    var tv = Tv(ip: paramStr(1), port: paramStr(2), c: newHttpClient())
    tv.c.headers = newHttpHeaders({ "Content-Type": "application/atom+xml"})
    discard sendCommand(tv, paramStr(3))
  else:
    var tv = Tv(ip: paramStr(1), port: paramStr(2), key: paramStr(3), c: newHttpClient())
    tv.c.headers = newHttpHeaders({ "Content-Type": "application/atom+xml"})
    discard auth(tv)
if paramCount() == 4:
  var tv = Tv(ip: paramStr(1), port: paramStr(2), key: paramStr(3), c: newHttpClient())
  tv.c.headers = newHttpHeaders({ "Content-Type": "application/atom+xml"})
  discard auth(tv)
  discard sendCommand(tv, paramStr(4))