
<?php
$title = "Sign In";
$action = "model_signIn.php";
include("includes/form_header.php");
?>

<li id="li_1" >
    <label class="description" for="username">Username </label>
    <div>
        <input id="username" name="username" class="element text medium required" type="text" maxlength="255"  title="Please enter username!" value=""/>
    </div>
</li>
<li id="li_2" >
    <label class="description" for="password">Password </label>
    <div>
        <input id="password" name="password" class="element text medium required password"  title="Please enter password!" type="password" maxlength="255" value=""/>
    </div>
     <p class="guidelines" id="guide_2"><small>password is case sensitive. That means "Password" and "password" are different words. </small></p>
    </li>

<li class="buttons">
    <input type="hidden" name="form_id" value="626766" />
    <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit" />
</li>

<?php include("includes/form_footer.php");?>