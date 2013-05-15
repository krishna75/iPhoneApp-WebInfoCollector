<?php

/* connects to remote the server */
$host = "cloudnineapp.db.10753504.hostedresource.com";
$username = "cloudnineapp";
$password = "App@Cloud9";
$db = "cloudnineapp";

//conects to local server
//$host = "localhost";
//$username = "root";
//$password = "";
//$db = "cloudnineapp";

$con = mysql_connect($host,$username,$password);
if (!$con){
  die('Could not connect to the mysql server: ' . mysql_error());
}

// connects to the database
$db = mysql_select_db($db, $con);
if (!$db){
  die('Could not connect to the database: ' . mysql_error());
 }
 $secret_key ="lankupul";
?>