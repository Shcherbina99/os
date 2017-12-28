#! /bin/bash
if [ -z "$1" ]; then
    echo 'Try use "-h" or "--help" after command.'
    exit
fi
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Using: $0 -f [OPTIONS]."
    echo 'The script gives list of unique ip, for which there were records of the level of ERROR or FATAL'
    echo '[OPTIONS] is following:'
    echo '-h/--help displays this help message'
    echo '-f/--file (required) Path to log file'
    exit
fi

while [ $# != 0 ]; do
    case "$1" in
        -f|--file)
            if ! [ -z "$2" ]; then  #
                file="$2"
            else
                echo "Not file"
                exit
            fi                      #
            shift 2
            ;;
        *)
            echo 'Try use "-h" or "--help" after command.'
            exit
            ;;
    esac
done

if ! [ -f "$file" ]; then
    echo 'File not found'
    exit
fi

ips=($(grep -P "^(ERROR|FATAL)" < "$file" | cut -f 3 -d "|"))
echo "${ips[@]}"

declare -A uniqueips=();
for i in "${ips[@]}";
do
  uniqueips["$i"]=1;
done

for i in "${!uniqueips[@]}";
do
  echo $i;
done
