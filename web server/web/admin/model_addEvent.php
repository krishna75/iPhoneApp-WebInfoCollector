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
$dd = $_POST['dd'];
$mm = $_POST['mm'];
$yyyy = $_POST['yyyy'];
$date = $yyyy . '/' . $mm . '/' . $dd;
$title = $_POST['title'];
$description = $_POST['description'];
$voucher = $_POST['voucher'];
$genres = $_POST['genres'];
$venue = $_POST['venue'];

//set dir and prefix for photo{}
$photoPrefix = str_replace(" ", "_", $title) . "_photo_";
$photoDir = "../images/eventPhoto/";

// check if the photo is valid
$photoMessage = validateImage($photoPrefix, $photo,$photoDir,200000);
$photoValidated = $photoMessage[0];

if ( $photoValidated) {

    // inserting data into mysql
    $photoUrl = $photoPrefix.$_FILES[$photo]['name'];

    $query = " INSERT INTO Events (
      date,   title,   description,voucher,    venue_id,    photo )  VALUES (
    STR_TO_DATE('$date', '%Y/%m/%d'), '$title', '$description','$voucher', '$venue',  '$photoUrl'); ";
    $eventResult = mysql_query($query) or die(mysql_error());

    //    get event id (select id from events where title = $title)
    $query = " SELECT id FROM Events  WHERE title = '$title'; ";
    $eventIdResult = mysql_query($query) or die(mysql_error());
    $eventId = "";
    while($row = mysql_fetch_assoc($eventIdResult)){
        echo "<option value='".$row['id']."' >".$row['genre']."</option>";
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
       returnMessage('portal', '<b>Success !!!</b> <br/>'.$logoUploadMessage."<br/> ".$photoUploadMessage);
    } else {
       returnMessage("addEvent", "<b>Error.. on adding data </b> <br/>". mysql_error($con));
   }
}else {
    //error message
    $photoErrorMessage = $photo.": ".$photoMessage[0] . " " . $photoMessage[1] . $photoMessage[2];
    returnMessage("addEvent", "<b>Error.. on image upload </b> <br/>".$logoErrorMessage."<br/>".$photoErrorMessage."<br/>". mysql_error($con));
}

function returnMessage($page,$message){
  $message = "<div style='background-color:yellow; padding:10px;'>".$message."</div>";
   echo $message;
//    header('location:'.$page.'.php?message='. $message);
}

mysql_close($con);