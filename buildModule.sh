#!/usr/bin/bash

# Version 1.0.0
# @dobryinik


MODULE_NAME_V="0.8.0"
MODULE_NAME="modulename" 

DOMAIN="sitename.local"



SYS_CONF="system/config/"$MODULE_NAME

ADMIN_CONTRL="admin/controller/extension/module"
ADMIN_MODEL="admin/model/extension/module"
ADMIN_TEMPL="admin/view/template/extension/module"
ADMIN_LEN="admin/language/en-gb/extension/module"
ADMIN_LRU="admin/language/ru-ru/extension/module"

CATALOG_CONTRL="catalog/controller/extension/module"
CATALOG_MODEL="catalog/model/extension/module"
CATALOG_VIEW="catalog/view/theme/default/template/extension/module"
CATALOG_LEN="catalog/language/en-gb/extension/module"
CATALOG_LRU="catalog/language/ru-ru/extension/module"


DATE=$(date '+%Y%m%d_%H%M%S')

DIRFILES="module"
DIRFILES_OLD="module_OLD"

UPLOAD=$DIRFILES/"upload"

LOG="logfile-$MODULE_NAME.log"

SUFF_PHP=".php"
SUFF_TWIG=".twig"

if [ '-testparam' == "$1" ]
  then

    exit 0
fi

if [ '-r' == "$1" ]
  then
  REM='n'
  echo -n "[WARNING]: Now you delete all files in module $MODULE_NAME! Are you sure? [y/n]"
  read REM
  if [[ $REM == "y" &&  -n "$REM" ]]
    then
    echo 'All files delete!'

    rm -v $DOMAIN/admin/controller/extension/module/$MODULE_NAME.php 
    rm -v $DOMAIN/admin/language/ru-ru/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/admin/language/en-gb/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/admin/model/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/admin/view/template/extension/module/$MODULE_NAME.twig
    rm -v $DOMAIN/catalog/view/theme/default/template/extension/module/$MODULE_NAME.twig
    rm -v $DOMAIN/catalog/view/theme/pionshop/template/extension/module/$MODULE_NAME.twig
    rm -v $DOMAIN/catalog/controller/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/catalog/language/ru-ru/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/catalog/language/en-gb/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/catalog/model/extension/module/$MODULE_NAME.php
    rm -v $DOMAIN/system/config/$MODULE_NAME/$MODULE_NAME.php

    else 
    echo 'Ok! You dont delete files!'
    exit 0
  fi
    exit 0
fi



if [ '-v' == "$1" ]
  then
    version=$(cat $MODULE_NAME.xml | grep -oP '(?<=<version>).*(?=</version>)')
    echo './'$MODULE_NAME'.xml?version='$version
    echo $0'?version='$MODULE_NAME_V
    exit 0
fi

if [[ -z ${1+x} && '-v' != "$1"  ]]; then 
MODULE_NAME_V='undefine-'$DATE; else 
MODULE_NAME_V=$1; fi
echo "[+] Set version is "$MODULE_NAME_V 

echo "[+] Change version to $MODULE_NAME_V in $MODULE_NAME.xml "
sed  "s/\(<version>\).*\(<\/version\)/\1$MODULE_NAME_V\2/" $MODULE_NAME.xml > install.xml
cp $MODULE_NAME.xml $MODULE_NAME.xml.bak
#mv install2.xml install.xml

cd ./$DOMAIN
cp ../install.xml ./


if [ ! -f ./$LOG ]; then  
  touch ./$LOG
fi
echo "[+] Start. Logfile is create" >> $LOG
 
echo "[+] Set module name is "$MODULE_NAME >> $LOG
 
echo "[+] Move '$DIRFILES' in new localion" >> $LOG
if [ -d "$DIRFILES" ]; then
  if [ ! -d "$DIRFILES_OLD" ]; then
    mkdir -v $DIRFILES_OLD >> $LOG
  fi
  if [ ! -d "$DIRFILES_OLD/$DATE" ]; then
    mkdir -v "$DIRFILES_OLD/$DATE(before-$MODULE_NAME-$MODULE_NAME_V)" >> $LOG
  fi

  mv -v $DIRFILES/* "$DIRFILES_OLD/$DATE(before-$MODULE_NAME-$MODULE_NAME_V)" >> $LOG

  if [ ! -d "$DIRFILES" ]; then
    mkdir -v $DIRFILES >> $LOG
  fi
fi
 
echo "[+] Create upload dirs" >> $LOG
mkdir -v -p $UPLOAD/{$ADMIN_CONTRL,$ADMIN_MODEL,$ADMIN_TEMPL,$ADMIN_LEN,$ADMIN_LRU,$CATALOG_MODEL,$SYS_CONF,\
$CATALOG_VIEW,$CATALOG_CONTRL,$CATALOG_LEN,$CATALOG_LRU}  >> $LOG

echo "[+] Move install.xml file" >> $LOG
mv install.xml $DIRFILES >> $LOG

echo "[+] Change version to $MODULE_NAME_V in $SYS_CONF/$MODULE_NAME$SUFF_PHP "
sed  "s/\(version'] = '\).*\(';\)/\1$MODULE_NAME_V\2/" $SYS_CONF/$MODULE_NAME$SUFF_PHP > $SYS_CONF/2$MODULE_NAME$SUFF_PHP
mv $SYS_CONF/2$MODULE_NAME$SUFF_PHP $SYS_CONF/$MODULE_NAME$SUFF_PHP

echo "[+] Copy system files" >> $LOG
cp -v $SYS_CONF/$MODULE_NAME$SUFF_PHP $UPLOAD/$SYS_CONF/ >> $LOG

echo "[+] Copy admin files" >> $LOG
cp -v $ADMIN_MODEL/$MODULE_NAME$SUFF_PHP $UPLOAD/$ADMIN_MODEL/ >> $LOG
cp -v $ADMIN_CONTRL/$MODULE_NAME$SUFF_PHP $UPLOAD/$ADMIN_CONTRL/ >> $LOG
cp -v $ADMIN_TEMPL/$MODULE_NAME$SUFF_TWIG $UPLOAD/$ADMIN_TEMPL/ >> $LOG
cp -v $ADMIN_LEN/$MODULE_NAME$SUFF_PHP $UPLOAD/$ADMIN_LEN/ >> $LOG
cp -v $ADMIN_LRU/$MODULE_NAME$SUFF_PHP $UPLOAD/$ADMIN_LRU/ >> $LOG


echo "[+] Copy module files"  >> $LOG
#cp -v -R $CATALOG_MODULE/$MODULE_NAME/* $UPLOAD/$CATALOG_MODULE/$MODULE_NAME >> $LOG

cp -v -R $CATALOG_VIEW/$MODULE_NAME$SUFF_TWIG $UPLOAD/$CATALOG_VIEW/  >> $LOG
cp -v -R $CATALOG_CONTRL/$MODULE_NAME$SUFF_PHP $UPLOAD/$CATALOG_CONTRL/ >> $LOG
cp -v -R $CATALOG_LEN/$MODULE_NAME$SUFF_PHP $UPLOAD/$CATALOG_LEN/ >> $LOG
cp -v -R $CATALOG_LRU/$MODULE_NAME$SUFF_PHP $UPLOAD/$CATALOG_LRU/ >> $LOG
cp -v -R $CATALOG_MODEL/$MODULE_NAME$SUFF_PHP $UPLOAD/$CATALOG_MODEL >> $LOG

#echo "[+] Copy others files"  >> $LOG
#cp -v -R $CATALOG_CONTRL"/common/menusm.php" $UPLOAD/$CATALOG_CONTRL"/common/menusm.php" >> $LOG
#cp -v "$CATALOG_MODULE/$MODULE_NAME/template/extension/module/blog_footer.twig" "$UPLOAD/$CATALOG_MODULE/default/template/extension/module/blog_footer.twig"  >> $LOG
#cp -v "$CATALOG_MODULE/$MODULE_NAME/template/common/menusm.twig" "$UPLOAD/$CATALOG_MODULE/default/template/common/menusm.twig"  >> $LOG

echo "[+] Zip files" >> $LOG
#$(pwd) >> $LOG
cd $DIRFILES 
zip -r $MODULE_NAME-$MODULE_NAME_V.ocmod.zip  "upload/" "install.xml"
echo "[+] Finish. Module is complite. " >> ../$LOG

mv ../$LOG ./ 
cd ../ 
rm ../install.xml
cd ../

sed  "s/\(MODULE_NAME_V=\"\).*\(\"\)/\1$MODULE_NAME_V\2/" makemodule.sh > makemodule2.sh
cp buildModule.sh buildModule.sh.bak
mv buildModule2.sh buildModule.sh

echo "[+] Change right files"
chmod 755 makemodule.sh
chmod 755 $MODULE_NAME.xml

echo "[+] Finish. Exit script!!!"

exit 0

