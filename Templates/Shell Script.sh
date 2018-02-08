#!/bin/bash

# Parameter
## User setting
readonly PARAMETER="hogehoge"
readonly ARRAY=( "foo"
                 "bar"
                 "baz" )
declare -Ar HASH=( ["key1"]="value1"
                   ["key2"]="value2" )
readonly HOGE_FILE="/path/to/file.txt"
readonly HOGE_DIR="/path/to/dir"
readonly HOGE_FILENAME="file.txt"
readonly HOGE_DIRNAME="dir"

## Administrator setting
readonly WORK_DIR=$(dirname $(readlink -f $0))


# Usage Function
function usage() {
cat <<_EOT_
Usage:
  $0 -u username -p password [-f filename] arg1 ...
Description:
  hogehogehoge
Options:
  -u    uuuuuuuuuu
  -p    pppppppppp
  -f    ffffffffff
  -h    display help
_EOT_
exit 1
}

function validate_input_data() {
  local _input_data=$1
  local _message=$2

  if [ -z "$_input_data" ]; then
    echo $_message 1>&2
    return 1
  fi
  return 0
}

function validate_file() {
  local _filename=$1
  local _message=$2

  if [ ! -f "$_filename" ]; then
    echo $_message 1>&2
    exit 1
  fi
  return 0
}

# Main
## check options and arguments

if [ $# = 0 ]; then
  usage
  exit 1
fi

if [ "$OPTIND" = 1 ]; then
  while getopts u:p:f:h OPT
  do
    case $OPT in
      u)
        readonly USERNAME=$OPTARG
        echo "[debug]USERNAME is $USERNAME"            # for debug
        ;;
      p)
        readonly PASSWORD=$OPTARG
        echo "[debug]PASSWORD is $PASSWORD"            # for debug
        ;;
      f)
        readonly FILENAME=$(basename $OPTARG)
        echo "[debug]FILENAME is $FILENAME"            # for debug
        validate_file $FILENAME "No such file: '${FILENAME}'"
        ;;
      h)
        echo "[debug]h option. display help"           # for debug
        usage
        ;;
      \?)
        echo "Try to enter the h option" 1>&2
        ;;
    esac
  done
else
  echo "No installed getopts-command" 1>&2
  exit 1
fi

echo "[debug]before shift"                       # for debug
shift $((OPTIND - 1))
echo "[debug]display other arguments [$*]"       # for debug
echo "[debug]after shift"                        # for debug

if [[ -z $USERNAME || -z $PASSWORD ]]; then
  echo "No specify argument(s) of -u option or -p option" 1>&2
  exit 1
fi

## main
echo "show array"                         # for debug
for i in ${ARRAY[@]}
do
  echo "$i"
done

echo "show array"                         # for debug
for (( i=0; $i < ${#ARRAY[@]}; ++i ))
do
  echo ${ARRAY[$i]}
done

echo "show hash"                          # for debug
for key in ${!HASH[@]}
do
  echo "${key} -> [${HASH[$key]}]"
done

