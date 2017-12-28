#! /bin/bash
if [ -z "$1" ]; then
    echo "Argument is not stated"
    echo "For more information try "$0" (--help or -h)"
    exit
else
    while [ $# != 0 ]; do
        case "$1" in
            -f|--file)
                if ! [ -z "$2" ]; then
                    file="$2"
                else
                    echo "File is not stated"
                    exit
                fi
                shift 2
                ;;
            -h|--help)
                echo
                echo  "Use: "$0" [OPTION]"
                echo
                echo "This program is normalaizing confifiguration file"
                echo "All units are translated to one dimension: "
                echo "      hours(h), days(d), minutes(min) to seconds(s)"
                echo "      millimeteres(mm), kilometeres(km), santimeters(sm) and decimeteres(dm) to meteres(m)"
                echo "      gramms(g), milligramms(mg) and tones(t) to kilogramms(kg)"
                echo
				echo '[OPTIONS] is following:'
				echo '-h/--help displays this help message'
				echo '-f/--file (required) Path to file'
				echo
                echo [FILE]
                echo "It is a configuration file"
                echo "It should like excpression below"
                echo "time=4s"
                echo "distance=8m"
                echo "longtime=15h"
                echo "weight=42g"
                echo
                exit
                ;;
            *)
                echo 'Try use "-h" or "--help" after command.'
                exit
                ;;
        esac
    done
fi

IFS=$'\n'
for str in `cat $file`
do
    leftPart=$(echo "$str" | cut -d= -f1)
    rightPart=$(echo "$str" | cut -d= -f2 | grep -Po ' *(\d+) *[a-zA-Z]+')
    Num=$(echo $rightPart | grep -Po '\d+')
    size=$(echo $rightPart | grep -Po [a-zA-Z]+)
    result=$""
    case "$size" in
        m) 
            result=$(echo "$Num")
            ;;
        mm) 
            result=$(echo "scale=4;$Num/1000" | bc)
            ;;
        sm) 
            result=$(echo "scale=3;$Num/100" | bc)
            ;;
        dm) 
            result=$(echo "scale=2;$Num/10" | bc)
            ;;
        km) 
            result=$(echo "$Num*1000" | bc)
            ;;
        kg) 
            result=$(echo "$Num")
            ;;
        g) 
            result=$(echo "scale=4;$Num/1000" | bc)
            ;;
        mg)
            result=$(echo "scale=7;$Num/1000000" | bc)
            ;;
        t) 
            result=$(echo "$Num*1000" | bc)
            ;;
        s) 
            result=$(echo "$Num")
            ;;
        min) 
            result=$(echo "$Num*60" | bc)
            ;;
        h) 
            result=$(echo "$Num*3600" | bc)
            ;;
        d)
            result=$(echo "$Num*86400" | bc)
            ;;
        *)
         echo "Unable to process line $str"
	 continue
         ;;
    esac
    if [[ "$result" =~ ^(\.) ]]; then 
        result=0$result;
    fi
    echo "$leftPart=$result"
done
