for pid in `ps -fA  | grep -e elasticsearch | grep -v grep |  tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
   kill -9 $pid &> /dev/null
   wait $pid 2>/dev/null
	rm -rf $ELASTICSEARCH_LOG_FILE

done
