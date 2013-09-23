<?php

/* checks if the file is valid for upload  */
function  validateImage($filePrefix, $file, $uploadDir, $size){
    $filename =  preg_replace('!\s+!', '_', $_FILES[$file]["name"]);
    $allowedExts = array("gif", "jpeg", "jpg", "png");

    $extension = end(explode(".", $filename));

    //collect message
    $message = "<br/> Image Detail = {file: " . $filename ;
    $message = $message." Type: " . $_FILES[$file]["type"] ;
    $message = $message." Size: " . ($_FILES[$file]["size"] / 1024)."}";

    //checks if valid type
    if (in_array($extension, $allowedExts)){
        if ($_FILES[$file]["error"] > 0){
            $message_array[0] = false;
            $message_array[1]=($_FILES[$file]["error"]);
            $message_array[2]=($message);
        } else {

            // checks if valid size
            if ( $_FILES[$file]["size"]> $size){
                $message_array[0] = false;
                $message_array[1]=("File size too big... Found =".($_FILES[$file]["size"] / 1000)."kb Expected= ".$size/1000.."kb");
                $message_array[2]=($message);
            }else {
                $message_array[0] = true;
                $message_array[1]=("File type, size and duplication check , OK !!!");
                $message_array[2]=($message);
            }
        }
    } else {
        $message_array[0] = false;
        $message_array[1]=("Invalid file");
        $message_array[2]=($message);
    }
return $message_array;
}

/* upload validated file */
function  uploadImage($filePrefix, $file, $uploadDir) {
    $filename =  preg_replace('!\s+!', '_', $_FILES[$file]["name"]);
    move_uploaded_file($_FILES[$file]["tmp_name"],$uploadDir .$filePrefix. $filename);
    return "Stored in: " . "$uploadDir" .$filePrefix. $filename;
}