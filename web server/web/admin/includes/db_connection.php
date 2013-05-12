<?php

//connects to the server
$con = mysql_connect("localhost","root","");
if (!$con){
  die('Could not connect to the mysql server: ' . mysql_error());
}

// connects to the database
$db = mysql_select_db("cloudnineapp", $con);
if (!$db){
  die('Could not connect to the database: ' . mysql_error());
 }
 $secret_key ="lankupul";
?>