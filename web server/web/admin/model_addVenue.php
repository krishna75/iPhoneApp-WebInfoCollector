<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krish
 * Date: 13/05/13
 * Time: 06:35
 * To change this template use File | Settings | File Templates.
 */
$requiredRole = 2;
include("includes/session.php");
require_once("includes/db_connection.php");
require_once("includes/image_uploader.php");

$venueName = "Oxford Academy";
$logoPrefix = str_replace(" ","_",$venueName)."_logo_";
$logoDir = "../images/logo/";
if (isset($_POST['logoField'])) {
    $logo = $_POST['logoField'];


    $logoMessage = validateImage($logoPrefix, $logo,$logoDir,50000);
    $logoValidated = $logoMessage[0];

    if ($logoValidated) {
       $message = uploadImage($logoPrefix, $logo, $logoDir);
       echo $message;
    }else {
        $message = $logo.": ".$logoMessage[0] . " " . $logoMessage[1] . $logoMessage[2];
        echo $message;
    }
//
//    returnMessage($logo." ".$logoMessage[0] . " " . $logoMessage[1] . $logoMessage[2]);
}
//if (isset($_POST['logo']) && isset($_POST['photo'])) {
//    $logo = $_POST['logo'];
//    $photo = $_POST['photo'];
//    $logoMessage = validateImage($logo,$uploadBaseDir."logo/",50000);
//    $photoMessage = validateImage($photo,$uploadBaseDir."venuePhoto/",500000);
//    returnMessage($logoMessage[0] . " " . $logoMessage[1] . " " . $photoMessage[0] . " " . $photoMessage[1]);
//}


/*
 *  check valid photos
 *
 * update mysql
 *
 * update photos
 *
 *
 */
function returnMessage($message){
    header('location:portal.php?message='. $message);
}