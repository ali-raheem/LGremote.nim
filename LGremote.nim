import std/httpclient, std/strutils, std/strtabs, os, system/io

var
    commands = newStringTable({"POWER": "1", "NUM_0": "2", "NUM_1": "3", "NUM_2": "4", "NUM_3": "5", "NUM_4": "6", $

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
  dataURL = "http://$#:$#/roap/api/data?target=$#"
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

proc getScreenshot(tv: Tv): Response =
  let res = tv.c.request(dataURL % [tv.ip, tv.port, "screen_image"], httpMethod = HttpGet)
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
if paramCount() == 5:
  var tv = Tv(ip: paramStr(1), port: paramStr(2), key: paramStr(3), c: newHttpClient())
  tv.c.headers = newHttpHeaders({ "Content-Type": "application/atom+xml"})
  discard auth(tv)
  let res = getScreenshot(tv)
