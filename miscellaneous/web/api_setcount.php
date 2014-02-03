<?php
	require_once("mta_sdk.php");
	require_once("mysql_init.php");
	$input = mta::getInput();
	$playerCount = $input[0];
	mysql_query("UPDATE `your_stat_table` SET `value` = '" . $playerCount . "' WHERE `key` = '1'");
	mta::doReturn(true);
?>