# created files
MY_DIR=`pwd`/ok
if [ ! -d "$MY_DIR/$1" ]; then mkdir -p $MY_DIR/$1; fi

RESULT_FILE=$MY_DIR/$1/result_strings.xml
WORK_FILE=$MY_DIR/tmp_strings.xml
COMPARE_FILE=$MY_DIR/compare_strings.xml
ARRAY_FILE=$MY_DIR/$1/array_strings.xml
PULARS_FILE=$MY_DIR/$1/plurals_strings.xml
STRING_SINGLE_FILE=$MY_DIR/strings_single.xml

if [ -e "$RESULT_FILE" ]; then rm $RESULT_FILE; fi
if [ -e "$WORK_FILE" ]; then rm $WORK_FILE; fi
if [ -e "$COMPARE_FILE" ]; then rm $COMPARE_FILE; fi
if [ -e "$ARRAY_FILE" ]; then rm $ARRAY_FILE; fi
if [ -e "$PULARS_FILE" ]; then rm $PULARS_FILE; fi
if [ -e "$STRING_SINGLE_FILE" ]; then rm $STRING_SINGLE_FILE; fi
touch $RESULT_FILE $WORK_FILE $COMPARE_FILE $ARRAY_FILE $PULARS_FILE $STRING_SINGLE_FILE

for xml in `find $1 -type f`
do
  echo $xml
echo $xml >> $RESULT_FILE
#TMP_ROUTE=$TOP/$VENDOR_ROOT_DIR/$str/$APP_RES_GENERAL_PATH
#echo $TMP_ROUTE
newxml=$MY_DIR/$xml
if [ -d "$newxml" ]; then rm -rf $newxml; fi
#mkdir -p $(dirname $newxml)
awk '/<string name/,/<\/string>/' $xml > $WORK_FILE
awk 'BEGIN{RS="<string name"}NF{$1=$1;print RS$0}' $WORK_FILE | awk 'BEGIN{FS="<string name="}{print $2}' | awk 'BEGIN{FS="</string>"}{print $1}' > $STRING_SINGLE_FILE
#awk 'BEGIN{RS="<string name"}NF{$1=$1;print RS$0}' $WORK_FILE > $STRING_SINGLE_FILE
awk '/<plurals name/,/<\/plurals>/' $xml >> $PULARS_FILE
awk '/<string-array/,/<\/string-array>/' $xml >> $ARRAY_FILE
cat $STRING_SINGLE_FILE >> $RESULT_FILE
sed -i "/translatable=\"false\"/d" $RESULT_FILE
done

#for lang in values-ar values-bg
#  do 
#	NEW_ROUTE=$MY_DIR/$lang/$str/res/values
#	if [ -d "$NEW_ROUTE" ]; then rm -rf $NEW_ROUTE/$str; fi
#	mkdir -p $NEW_ROUTE
#	awk '/<string name/,/<\/string>/' $TMP_ROUTE/values/strings.xml > $WORK_FILE
#  awk 'BEGIN{RS="<string name"}NF{$1=$1;print RS$0}' $WORK_FILE | awk 'BEGIN{FS="<string name="}{print $2}' | awk 'BEGIN{FS="</string>"}{print $1}' > $STRING_SINGLE_FILE
#	sed -n "/<string name=/p" $TMP_ROUTE/$lang/strings.xml | awk 'BEGIN{FS="<string name="}{print $2}'| awk 'BEGIN{FS=">"}{print $1}' | awk '{print $1}' > $COMPARE_FILE
#	        for item in `cat $COMPARE_FILE`
#	        do sed -i "/$item/d" $STRING_SINGLE_FILE
#	        done
#	touch $MY_DIR/$lang/strings.xml
#	echo $MY_DIR/$lang/$str >> $MY_DIR/$lang/strings.xml
#	cat $STRING_SINGLE_FILE >> $MY_DIR/$lang/strings.xml
#	sed -i "/translatable=\"false\"/d" $MY_DIR/$lang/strings.xml
#	done
#done
