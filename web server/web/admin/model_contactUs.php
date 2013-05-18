<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krish
 * Date: 18/05/13
 * Time: 04:51
 */

$name = $_REQUEST['name'];
$email=$_REQUEST['email'];
$message=$_REQUEST['message'];

$toEmail= "ks21285@gmail.com";
$emailSubject= "CLOUD NINE - Visitor from the website";
$fromEmail=$email;
$emailMessage= "<center><h3>CLOUD NINE - Website Visitor's Message </h3></center>
<hr>
<table>
<tr bgcolor='#CCCCCC'><td><b> Visitor's Details</b></td><td></td></tr>
<tr><td>Name: </td><td><b>$name </b></td></tr>
<tr><td>Email:<td><b>$email</td></b></td></tr>
<tr bgcolor='#CCCCCC'><td><b> Message </b></td><td></td></tr>
<tr><td><td><b>$message</td></b></td> </tr>
</table>
";
mail($toEmail,$emailSubject,$emailMessage,"From:$fromEmail\r\nReply-to: $fromEmail\r\nContent-type: text/html; charset=us-ascii");
header ("location:response.php");