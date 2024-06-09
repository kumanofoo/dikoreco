# dikoreco
[![reelase](https://img.shields.io/github/v/release/kumanofoo/dikoreco)](https://github.com/kumanofoo/dikoreco)

This downloads [radiko](http://radiko.jp/) sound and save as m4a with tags.

## Original script
- [rec_radiko.sh](https://gist.github.com/saiten/875864)
- [とあるサイトの録音手段 (シェルスクリプト)](http://blog.half-moon.org/archives/963)
- [簡易Radiko録音スクリプト](https://gist.github.com/matchy2/3956266)

## Usage
```
$ dikoreco
usage : dikoreco OUTFILEPREFIX RECTIMEMIN CHANNEL

CHANNEL:
  TBS       TBS Radio
  QRR       Bunka Hoso
  LFR       Nippon Hoso
  RN1       Radio NIKKEI 1
  RN2       Radio NIKKEI 2
  INT       InterFM897
  FMT       TOKYO FM
  FMJ       J-WAVE
  JORF      Radio Nippon
  BAYFM78   bayfm78
  NACK5     NACK5
  YFM       FM Yokohama
```

Record TBS Radio channel for 120 minutes and save as m4a file with a prefix, 'megane'.
```Shell
$ dikoreco megane 120 TBS
$ ls
megane_2019-10-18.m4a
```

Show m4a tags.
```Shell
$ m4atag -s megane_2019-10-18.m4a
megane_2019-10-18.m4a
artwork : JPEG
personality : ['Ogiyahagi']
program : ['Ogiyahagi no megane biiki']
year : ['2019']
genre : ['radio']
title : ['20191018']
encoder : ['Lavf57.56.101']
```

Edit tags in m4atag.json.
```JSON
{
    "audrey": {
        "personality": "Audrey",
        "program": "Audrey no all night nippon",
        "genre": "radio",
        "artwork": "audrey.png"
    },
    "megane": {
        "personality": "Ogiyahagi",
        "program": "Ogiyahagi no megane biiki",
        "genre": "radio",
        "artwork": "megane.jpg"
    }
}
```


## Requirements
### dikoreco (bash)
- ffmpeg(3.2.14)
- curl(7.52.1)
- xmllint(libxml2-utils 2.9.4)

### m4atag (Python3)
- mutagen(1.36)

## Installation
Copy dikoreco and m4atag to a same directory.
```Shell
mkdir $(HOME)/dikoreco
cp dikoreco m4atag $(HOME)/dikoreco
```

### Options
Put m4atag.json into the directory of output m4a and
edit personality, program and genre.
```Shell
cp m4atag.json.example $(HOME)/radio/m4atag.json
```

Specify a directory to save m4a if you want.
By default, dikoreco outputs m4a to the current directory.
```Shell
OUTFILEBASEPATH=${HOME}/radio
```

Specify a directory of a path to log if you want.
By default, dikoreco outputs logs to ${HOME}/.dikoreco.log.
```Shell
LOGFILE=${HOME}/.dikoreco.log
```

## Development
### Test
Install Bats(Bash Automated Testing System) to test. And run script.

```Shell
./test/run
```

### Docker
#### Build image
```Shell
$ docker build -t dikoreco .
```
#### Run the container
```Shell
$ docker-compose up -d
```

#### Run test in the container
```Shell
$ docker exec -it dikoreco_container bash -c "test/run"
```

#### Stop the container
```Shell
$ docker-compose down
```
