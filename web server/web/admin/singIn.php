<?php if (!empty($_GET['message'])) {$message = $_GET['message'];}
//$message = "hello";

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sign In</title>
<link rel="stylesheet" type="text/css" href="css/view.css" media="all">
<script type="text/javascript" src="js/view.js"></script>
<script type="text/javascript" src="js/validatious-custom.js"></script>
</head>
<body id="main_body" >
	
	<img id="top" src="images/top.png" alt="">
	<div id="form_container">

	
		<h1><a>Sign In</a></h1>
		<form id="form_626766" class="appnitro validate"  method="post" action="signIn_model.php">
			<div class="form_description">
                <h2>Sign In</h2>

                <label id="message" class="description">  <?php echo $message; ?> </label>
                <p></p>
            </div>
                <ul >

                        <li id="li_1" >
            <label class="description" for="username">Username </label>
            <div>
                <input id="username" name="username" class="element text medium required" type="text" maxlength="255"  title="Please enter username!" value=""/>
            </div>
            </li>		<li id="li_2" >
            <label class="description" for="password">Password </label>
            <div>
                <input id="password" name="password" class="element text medium required password"  title="Please enter password!" type="text" maxlength="255" value=""/>
            </div><p class="guidelines" id="guide_2"><small>password is case sensitive. That means "Password" and "password" are different words. </small></p>
            </li>

                        <li class="buttons">
                    <input type="hidden" name="form_id" value="626766" />

                    <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit" />
            </li>
                </ul>

		</form>	
		<div id="footer">

		</div>
	</div>
	<img id="bottom" src="images/bottom.png" alt="">
	</body>
</html>