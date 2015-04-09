<?php
$httphost = ($_SERVER['HTTP_HOST']);
mysql_connect('localhost','vagrant','vagrant') or die ('mysql error');
mysql_select_db('magento');
mysql_query('update core_config_data set value="http://'.$httphost.'/" where path="web/unsecure/base_url"') or die ("error query");
mysql_query('update core_config_data set value="http://'.$httphost.'/" where path="web/secure/base_url"');


echo "host set to ";
echo "http://".$httphost."/";

system("rm -Rf var/cache/mage*");
