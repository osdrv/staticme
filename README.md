#StaticMe

## Introduction

StaticMe is simple server for serving static content built on top of [thin](http://code.macournoyer.com/thin/).

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
