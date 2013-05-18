<?php
$title = "Contact Us";
$action = "model_contactUs.php";
include("includes/form_header.php");
?>

<li id="li_1">
    <label class="description" for="element_1">Full Name </label>
    <div>
        <input id="element_1" name="name" class="element text medium" type="text" maxlength="255" value=""/>
    </div>
</li>
<li id="li_2">
    <label class="description" for="element_2">Email </label>
    <div>
        <input id="element_2" name="email" class="element text medium" type="text" maxlength="255" value=""/>
    </div>
</li>
<li id="li_3">
    <label class="description" for="element_3">Message </label>
    <div>
        <textarea id="element_3" name="message" class="element textarea medium"></textarea>
    </div>
</li>
<li class="buttons">
    <input type="hidden" name="form_id" value="626766"/>
    <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit"/>
</li>

<?php include("includes/form_footer.php");