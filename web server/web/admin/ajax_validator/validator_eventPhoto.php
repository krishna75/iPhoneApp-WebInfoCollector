<?php
include "../includes/image_uploader.php";
$photo = $_POST['photoField'];
$title = $_POST['title'];


//set dir and prefix for photo{}
$photoPrefix = str_replace(" ", "_", $title) . "_photo_";
$photoDir = "../images/eventPhoto/";

// check if the photo is valid
$photoMessage = validateImage($photoPrefix, $photo,$photoDir,200000);
$photoValidated = $photoMessage[0];