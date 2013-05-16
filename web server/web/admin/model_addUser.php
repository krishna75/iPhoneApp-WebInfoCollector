<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krish
 * Date: 12/05/13
 * Time: 09:21
 * To change this template use File | Settings | File Templates.
 */
$requiredRole = 2;
include("includes/session.php");
require_once("includes/db_connection.php");

//post params
$firstName = $_POST['firstName'];
$lastName = $_POST['lastName'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];
$username = $_POST['username'];
$password = $_POST['password'];
$role = $_POST['role'];

//INSERT
$query = " INSERT INTO Users (
first_name, last_name, email, phone, address, username, password, role )  VALUES (
'$firstName', '$lastName', '$email', '$phone', '$address', '$username', AES_ENCRYPT('$password', '$secret_key'),'$role') ";
$result = mysql_query($query);

if ($result){
    header('location:portal.php?message=success');
}else {
    header('location:portal.php?message=error');
}

mysql_close($con);