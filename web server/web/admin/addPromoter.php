<?php
$requiredRole = 1;
include("includes/session.php");
$title = "Add Promoter";
$action = "model_addUser.php";
include("includes/form_header.php");
?>
    <div class='admin-link'><a href='portal.php'> << back to portal </a></div>
    <br/> <br/>

    <li id="li_1">
        <label class="description" for="element_1">Name * </label>
		<span>
			<input id="firstName" name="firstName" class="required element text" maxlength="255" size="8" value=""/>
			<label>First</label>
		</span>
		<span>
			<input id="lastName" name="lastName" class="required element text" maxlength="255" size="14" value=""/>
			<label>Last</label>
		</span>
    </li>
    <li id="li_2">
        <label class="description" for="element_2">Email * </label>
        <div>
            <input id="email" name="email" class="required email element text medium" type="text" maxlength="255" value=""/>
        </div>
    </li>

    <li id="li_3">
        <label class="description" for="element_3">Phone *</label>
		<span>
			<input id="phone" name="phone" class="required element text" size="15" maxlength="20" value="" type="text">
		</span>
    </li>
    <li id="li_4">
        <label class="description" for="address">Address* </label>
        <div>
            <textarea id="address" name="address" class="required element textarea small"></textarea>
        </div>
    </li>
    <li class="section_break">
        <h3>Log in details</h3>
        <p></p>
    </li>
    <li id="li_6">
        <label class="description" for="username">New username * </label>
        <div>
            <input id="username" name="username" class="required element text medium" type="text" maxlength="255" value=""/>
        </div>
    </li>
    <li id="li_7">
        <label class="description" for="element_7">New password * </label>
        <div>
            <input id="password" name="password" class="required password element text medium" type="password" maxlength="255" value=""/>
        </div>
    </li>
    <li id="li_8">
        <label class="description" for="element_8">Confirm password * </label>
        <div>
            <input  id="password_confirmation" name="element_8" class="confirmation-of_password element text medium" type="password" maxlength="255"
                   value="" title="passwords are not matching !!!"/>
        </div>
    </li>

    <li class="buttons">
        <input type="hidden" name="form_id" value="626766"/>
        <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit"/>
    </li>
    <!-- specifies that this person is a promoter -->
    <li>
        <input type="hidden" name="role" value="2"/>
    </li>

<?php include("includes/form_footer.php");