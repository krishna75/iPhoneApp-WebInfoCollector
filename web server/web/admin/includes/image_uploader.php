<?php

/* checks if the file is valid for upload  */
function  validateImage($filePrefix, $filename, $uploadDir, $size){
    $allowedExts = array("gif", "jpeg", "jpg", "png");

    $extension = end(explode(".", $_FILES[$filename]["name"]));

    //collect message
    $message = "<br/> Image Detail = {file: " . $_FILES[$filename]["name"] ;
    $message = $message." Type: " . $_FILES[$filename]["type"] ;
    $message = $message." Size: " . ($_FILES[$filename]["size"] / 1024)."}";

    //checks if valid type
    if (in_array($extension, $allowedExts)){
        if ($_FILES[$filename]["error"] > 0){
            $message_array[0] = false;
            $message_array[1]=($_FILES[$filename]["error"]);
            $message_array[2]=($message);
        } else {

            // checks if valid size
            if ( $_FILES[$filename]["size"]> $size){
                $message_array[0] = false;
                $message_array[1]=("File size too big... Found =".($_FILES[$filename]["size"] / 1000)."kb Expected= ".$size/1000.."kb");
                $message_array[2]=($message);
            }
            else {

                //chedck if file already exists
                if (file_exists($uploadDir .$filePrefix. $_FILES[$filename]["name"])){
                    $message_array[0] = false;
                    $message_array[1]=($_FILES[$filename]["name"] . " already exists. Select a new file or rename your file before uploading ");
                    $message_array[2]=($message);
                }
                else {
                    $message_array[0] = true;
                    $message_array[1]=("File type, size and duplication check , OK !!!");
                    $message_array[2]=($message);
                }
            }
        }
    }
    else {
        $message_array[0] = false;
        $message_array[1]=("Invalid file");
        $message_array[2]=($message);

    }
return $message_array;
}

/* upload validated file */
function  uploadImage($filePrefix, $filename, $uploadDir) {
    move_uploaded_file($_FILES[$filename]["tmp_name"],$uploadDir .$filePrefix. $_FILES[$filename]["name"]);
    return "Stored in: " . "$uploadDir" .$filePrefix. $_FILES[$filename]["name"];
}