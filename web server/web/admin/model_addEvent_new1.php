<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krish
 * Date: 13/05/13
 * Time: 06:35
 * To change this template use File | Settings | File Templates.
 */
//$requiredRole = 3;
//include("includes/session.php");
//require_once("includes/db_connection.php");
//require_once("includes/image_uploader.php");

// get the post params

$dates = explode(",",$_POST['dates']);
foreach ($dates as $value)
{
    echo "$value <br>";
}
