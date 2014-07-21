#StaticMe

## Introduction

StaticMe is simple server for serving static content built on top of [thin](http://code.macournoyer.com/thin/).

## News

#### Version 0.3.0 has been released

This version introduces an automatic webpage reload functionality.

Staticme serves path `/staticme/autoreload.js` as a script src to provide the autoreload functionality.

Simply add a script tag to the bottom of any webpage:

<script type="text/javascript" src="/staticme/autoreload.js"></script>

Staticme will handle all fs evenes in the directory and broadcast 'em with "fs_event" through the websocket transport.

## Installation

```
gem install staticme
```

## Usage

### Options:

  * -f, --path:   path to be served in, current if omitted
  * -p, --port:   port to bind, 8080 by default
  * -h, --host:   host to start up, 0.0.0.0 by default
  * -i, --index:  index file name, index.html by default
  * --ws-port:    websocket port, 8090 by default. Available since 0.3.0

### Starting up

In terminal:

```
cd my_project_folder
staticme
>> Thin web server (v1.5.1 codename Straight Razor)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:8080, CTRL+C to stop
```

In browser open page http://127.0.0.1:8080
