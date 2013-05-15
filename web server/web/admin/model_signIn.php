<?php
require_once("includes/db_connection.php");

// checking if username and password are set and correct and setting session
if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $authed = authorized($username, $password, $secret_key);

    if (! $authed) {
        returnError();
    } else {
       setSession($username);
       returnAuthorizedPage();
    }
} else {
    returnError();
}


//check if username and password both are valid
function authorized($username, $inputPassword, $key){
    $query = mysql_query("SELECT username, AES_DECRYPT(password,'$key') as password  FROM Users WHERE username='$username'");
    if (!$query){
        return false;
    }
    $numrows = mysql_num_rows($query);
    if ($numrows!=0){
        while ($row = mysql_fetch_assoc($query)){
            $dbusername = $row['username'];
            $dbpassword = $row['password'];
            if ($dbusername == $username && $dbpassword == $inputPassword) {
                return true;
            }
            else
                return false;
        }
    }
return false;
}

//check if username and password both are valid
function setSession($username){
    session_start();
    $query = mysql_query("SELECT * FROM Users WHERE username='$username'");

    $row = mysql_fetch_assoc($query);

    $_SESSION['username'] =  $row['username'];
    $_SESSION['first_name'] =  $row['first_name'];
    $_SESSION['last_name'] =  $row['last_name'];
    $_SESSION['role'] =  $row['role'];
    $_SESSION['start'] = time();
    $_SESSION['expire'] = $_SESSION['start'] + (30 * 60) ;;
}




// return error
function returnAuthorizedPage(){
    header('location:portal.php');
}

// return error
function returnError(){
    header('location:signIn.php?message=Invalid username or password ');
}
mysql_close($con);