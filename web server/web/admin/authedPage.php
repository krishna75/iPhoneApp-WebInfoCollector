<?php
session_start();
echo "Dear ".$_SESSION['first_name']." ".  $_SESSION['last_name']."
you are authorised. ";
