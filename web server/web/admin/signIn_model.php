<?php
require_once("db_connection.php");

// checking if username and password are set and correct and setting session
if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $authed = authorized($username, $password);

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
function authorized($username, $password){
    $query = mysql_query("SELECT * FROM users WHERE username='$username'");
    $numrows = mysql_num_rows($query);
    if ($numrows!=0){
        while ($row = mysql_fetch_assoc($query)){
            $dbusername = $row['username'];
            $dbpassword = $row['password'];
            if ($dbusername == $username && $dbpassword == $password) {
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
    $query = mysql_query("SELECT * FROM users WHERE username='$username'");

    $row = mysql_fetch_assoc($query);

    $_SESSION['username'] =  $row['username'];
    $_SESSION['password'] =  $row['password'];
    $_SESSION['first_name'] =  $row['first_name'];
    $_SESSION['last_name'] =  $row['last_name'];
    $_SESSION['role'] =  $row['role'];
}




// return error
function returnAuthorizedPage(){
    return header('location:authedPage.php');
}

// return error
function returnError(){
    return header('location:singIn.php?message=Invalid username or password');
}
mysql_close($con);