#!/usr/bin/env bash
header=""
comment=""
size[1]="##############################################################################"
size[2]="#####################################"
size[3]="###"
size[4]="#"
mode=1

while [[ "$#" -gt 0 ]]; do
  case $1 in
    # what to look for) what to set to="$2"; shifts past ;;
    #Gives the script help screen
    -h|--h|-header|--header) header="$2"; shift ;;
    -c|--c|-comment|--comment) comment="$2"; shift ;;
    h1) mode=1;;
    h2) mode=2;;
    h3) mode=3;;
    h4) mode=4;;
    -d|--d|-debug|--debug) debug=true;;
    *) echo -e "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

header=" $( echo "$header" | sed 's/^[ \t]*//;s/[ \t]*$//' ) "
if [[ ! -z $comment ]]; then comment=" $( echo "$comment" | sed 's/^[ \t]*//;s/[ \t]*$//' ) "; fi

line[1]="${size[$mode]}"
line[4]="${size[$mode]}"

targetLen=${#line[1]}
headerLen=${#header}
commentLen=${#comment}

if [[ $debug == true ]]; then echo "Target $targetLen, Header $headerLen, Comment $commentLen"; fi

fillSides () {
  if [[ $1 == header ]]; then local checkLen=$headerLen; else checkLen=$commentLen; fi
  local fillTotalLen=$((targetLen-checkLen-2))
  local fillLeftLen=$((fillTotalLen/2))
  local fillRightLen=$((fillTotalLen/2))

  if [[ fillTotalLen -lt 0 ]]; then if [[ $1 == header ]]; then echo "Header won't fit!" && exit 1; else echo "Comment won't fit!" && exit 1; fi; fi
  fillRightLen=$((fillRightLen+$((fillTotalLen-$((fillLeftLen+fillRightLen))))))

  if [[ $debug == true ]]; then echo "Fill Total $fillTotalLen, Left $fillTotalLen, Right $fillRightLen"; fi
  local index=0
  while [[ $index -le $fillLeftLen ]]; do
    ((index = index + 1))
    local fillLeft+="#"
  done

  local index=0
  while [[ $index -le $fillRightLen ]]; do
    ((index = index + 1))
    local fillRight+="#"
  done

  if [[ $1 == header ]]; then line[2]="${fillLeft}${header}${fillRight}";
  else line[3]="${fillLeft}${comment}${fillRight}"; fi
}
if [[ $mode == 1 ]] || [[ $mode == 2 ]]; then
  fillSides header
  if [[ ! $comment == "" ]]; then fillSides comment; fi

  echo "${line[1]}"
  echo "${line[2]}"
  if [[ ! $comment == "" ]]; then echo "${line[3]}"; fi
  echo "${line[4]}"
elif [[ $mode == 3 ]]; then
  echo "${size[3]}$header${size[3]}"
elif [[ $mode == 4 ]]; then
  echo "${size[4]}$header"
fi
