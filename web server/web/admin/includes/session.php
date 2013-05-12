<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krish
 * Date: 12/05/13
 * Time: 08:03
 * To change this template use File | Settings | File Templates.
 */

session_start();
if ( empty ($_SESSION)){
    header('location:signIn.php');
}

if ($_SESSION['role'] > $requiredRole){
    header('location:portal.php');
}