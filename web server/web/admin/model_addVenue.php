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



// get the post params
$logo = $_POST['logoField'];
$photo = $_POST['photoField'];
$venueName = $_POST['venueName'];
$address = $_POST['address'];
$phone= $_POST['phone'];
$email = $_POST['email'];
$web = $_POST['web'];
$description = $_POST['description'];

//set dir and prefix
$logoPrefix = str_replace(" ","_",$venueName)."_logo_";
$logoDir = "../images/logo/";
$photoPrefix = str_replace(" ","_",$venueName)."_photo_";
$photoDir = "../images/venuePhoto/";

$response_success = 0;
$response_message="";

// check if the photos are valid
$logoMessage = validateImage($logoPrefix, $logo,$logoDir,20000);
$photoMessage = validateImage($photoPrefix, $photo,$photoDir,200000);
$logoValidated = $logoMessage[0];
$photoValidated = $photoMessage[0];

if ( !$logoValidated && !$photoValidated) {
    $logoErrorMessage = $logo.": ".$logoMessage[0] . " " . $logoMessage[1] . $logoMessage[2];
    $photoErrorMessage = $photo.": ".$photoMessage[0] . " " . $photoMessage[1] . $photoMessage[2];
    $response_success = 0;
    $response_message =  "<b>Error.. on image upload </b> <br/>".$logoErrorMessage."<br/>".$photoErrorMessage."<br/>". mysql_error($con);
} else {

    // inserting data into mysql
    $logoUrl =$logoPrefix.preg_replace('!\s+!', '_',$_FILES[$logo]['name']);
    $photoUrl = $photoPrefix.preg_replace('!\s+!', '_',$_FILES[$photo]['name']);

    $query = " INSERT INTO Venues (
      logo,     name,         address,    phone,    email,    web,    photo,        description )  VALUES (
    '$logoUrl', '$venueName', '$address', '$phone', '$email', '$web', '$photoUrl', '$description') ";
    $result = mysql_query($query);
   if ($result){
        //uploading
       $logoUploadMessage = uploadImage($logoPrefix, $logo, $logoDir);
       $photoUploadMessage = uploadImage($photoPrefix, $photo, $photoDir);
       $response_success = 1;
       $response_message = '<b>Success !!!</b> <br/>'.$logoUploadMessage."<br/> ".$photoUploadMessage;
    } else {
       $response_success = 0;
       $response_message= "<b>Error.. on adding data </b> <br/>". mysql_error($con);
   }
}

header('location:admin_response.php?success='.$response_success.',&message='. $response_message);
mysql_close($con);