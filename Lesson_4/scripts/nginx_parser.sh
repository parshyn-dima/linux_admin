#!/bin/bash
RESPONSE_CODE="2[0-9][0-9]|3[0-9][0-9]"
ERRORS_CODE="4[0-9][0-9]|5[0-9][0-9]"
ACCESS_LOG="/vagrant/logs/access-otus.log"
RUN_LOG="/var/log/log-pars-tmp.log"
declare -r TMP_ACCESS="$(mktemp)"

if [[ -e "$RUN_LOG" ]]; then
    from_date=$(sed -rn 's/Last run: (.*)/\1/p' "$RUN_LOG")
    access_line_processed=$(sed -rn 's/Access lines processed: ([0-9]+)/\1/p' "$RUN_LOG")
fi

if [[ ! $from_date ]]; then
    from_date="service first start"
fi

if [[ $access_line_processed ]]; then
    sed -e "1,${access_line_processed}d" "$ACCESS_LOG" > "$TMP_ACCESS"
else
    cp "$ACCESS_LOG" "$TMP_ACCESS"
fi

to_date=$(date +"%b %d %H:%M:%S")

echo "Report from $from_date to $to_date"
echo
#functions
filters(){
    grep -E $RESPONSE_CODE
}
filters_errors(){
    grep -E $ERRORS_CODE
}
request_ips(){
    awk '{print $1}'
}
wordcount(){
    sort | uniq -c
}
sort_desc(){
    sort -rn
}
return_kv(){
    awk '{print $1, $2}'
}
return_top_ten(){
    head -10
}
request_method(){
    awk '{print $6}' | cut -d'"' -f2
}
request_page(){
    awk '{print $7}'
}
request_code(){
    awk '{print $9}'
}
get_request_ips(){
    echo ""
    echo "Top 10 Request IP's:"
    echo "============================"

    cat $TMP_ACCESS | request_ips | wordcount | sort_desc | return_kv | return_top_ten
    echo ""
}
get_request_pages(){
    echo ""
    echo "Top 10 Request pages:"
    echo "============================"

    cat $TMP_ACCESS | request_page | wordcount | sort_desc | return_kv | return_top_ten
    echo ""
}
get_request_code(){
    echo ""
    echo "Top 10 Request code:"
    echo "============================"

    cat $TMP_ACCESS | request_code | filters | wordcount | sort_desc | return_kv | return_top_ten
    echo ""
}
get_request_errors_code(){
    echo ""
    echo "Top 10 Request errors code:"
    echo "============================"

    cat $TMP_ACCESS | request_code | filters_errors  | wordcount | sort_desc | return_kv | return_top_ten
    echo ""
}

get_request_ips
get_request_pages
get_request_code
get_request_errors_code

cat > "$RUN_LOG" <<EOF
Last run: $to_date
Access lines processed: $(wc -l $ACCESS_LOG | cut -d" " -f1)
EOF

rm -f "$TMP_ACCESS"