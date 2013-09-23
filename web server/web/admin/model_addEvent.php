<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krish
 * Date: 13/05/13
 * Time: 06:35
 * To change this template use File | Settings | File Templates.
 */
$requiredRole = 3;
include("includes/session.php");
require_once("includes/db_connection.php");
require_once("includes/image_uploader.php");

// get the post params
$photo = $_POST['photoField'];
$title = $_POST['title'];
$description = $_POST['description'];
$voucher = $_POST['voucher'];
$voucher_photo = $_POST['voucherPhotoField'];
$genres = $_POST['genres'];
$venue = $_POST['venue'];
$dates = explode(",",$_POST['dates']);

$log = "event photo = ".$photo." voucher photo = ".$voucher_photo;

$response_success = 0;
$response_message="";

foreach ($dates as $date){

    /* EVENT PHOTO */
    //set dir and prefix for event photo
    $photoPrefix = str_replace(" ", "_", $title) . "_photo_"; //todo create suitable code to avoid multiple copies of the same image
    $photoDir = "../images/eventPhoto/";
    // check if the event photo is valid
    $photoMessage = validateImage($photoPrefix, $photo,$photoDir,200000);
    $photoValidated = $photoMessage[0];

    /* VOUCHER PHOTO */
    //set dir and prefix for event photo
    $voucherPhotoPrefix = str_replace(" ", "_", $title) . "_voucher_";
    $voucherPhotoDir = "../images/voucherPhoto/";
    // check if the event photo is valid
    $voucherPhotoMessage = validateImage($voucherPhotoPrefix, $voucher_photo,$voucherPhotoDir,200000);
    $voucherPhotoValidated = $photoMessage[0];


    $duplicateEvent = false;

    //checks duplicate event
    $query = " SELECT * FROM Events WHERE date='$date' AND venue_id='$venue'; ";
    $result = mysql_query($query) or die(mysql_error());
    if(mysql_fetch_array($result) == true){
        $duplicateEvent = true;
    } else {
        $duplicateEvent = false;
    }

    if ($duplicateEvent){
        $response_success = 0;
        $response_message = "Duplicate Event ...This event already exists ";

    } else if ( !$photoValidated) {
        //error message
        $photoErrorMessage = $photo.": ".$photoMessage[0] . " " . $photoMessage[1] . $photoMessage[2];
        $response_success = 0;
        $response_message = "<b>Error.. on loading event photo </b> <br/>".$photoErrorMessage."<br/>". mysql_error($con);
    }else if (! $voucherPhotoValidated){
        //error message
        $photoErrorMessage = $voucher_photo.": ".$voucherPhotoMessage[0] . " " . $voucherPhotoMessage[1] . $voucherPhotoMessage[2];
        $response_success = 0;
        $response_message = "<b>Error.. on loading voucher photo </b> <br/>".$photoErrorMessage."<br/>". mysql_error($con);
    } else {

        // inserting data into mysql
        $photoUrl =  $filename = $photoPrefix. preg_replace('!\s+!', '_', $_FILES[$photo]['name']);
        $voucherPhotoUrl = $voucherPhotoPrefix.preg_replace('!\s+!', '_',$_FILES[$voucher_photo]['name']);

        $query = " INSERT INTO Events (
          date,   title,   description,voucher,voucher_photo,    venue_id,    photo ,   added)  VALUES (
        STR_TO_DATE('$date', '%Y/%m/%d'), '$title', '$description','$voucher','$voucherPhotoUrl', '$venue',  '$photoUrl', CONVERT_TZ( UTC_TIMESTAMP(), 'UTC', 'Europe/London' )); ";
        $eventResult = mysql_query($query) or die(mysql_error());

        //    get event id (select id from events where title = $title)
        $query = " SELECT id FROM Events  WHERE title = '$title'; ";
        $eventIdResult = mysql_query($query) or die(mysql_error());
        $eventId = "";
        while($row = mysql_fetch_assoc($eventIdResult)){
            $eventId = $row['id'];
        }

        // set genres
        foreach ($genres as $genre){
            $query = " INSERT INTO Genres_Events (
              event_id,   genre_id )  VALUES (
            '$eventId', '$genre' ); ";
            $genreResult = mysql_query($query);
        }

        if ($genreResult && $eventResult){
            //uploading
            $photoUploadMessage = uploadImage($photoPrefix, $photo, $photoDir);
            $voucherPhotoUploadMessage = uploadImage($voucherPhotoPrefix, $voucher_photo, $voucherPhotoDir);
            $response_success = 1;
            $response_message .= $logoUploadMessage."<br/> ".$photoUploadMessage."</br>".$voucherPhotoUploadMessage;
        } else {
            $response_success = 0;
            $response_message .= "<b>Error.. on adding data </b> <br/>". mysql_error($con);
        }
    }
}


//$response_message .= "<br/>log: <br/>".$log;
header('location:admin_response.php?success='.$response_success.',&message='. $response_message);
mysql_close($con);