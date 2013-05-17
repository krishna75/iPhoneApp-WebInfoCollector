<?php
$requiredRole = 2;
include("includes/session.php");
$title = "Add Client";
$action = "model_addUser.php";
include("includes/form_header.php");
require_once("includes/db_connection.php");
?>
    <li id="li_1">
        <label class="description" for="element_1">Name * </label>
		<span>
			<input id="element_1_1" name="firstName" class="element text" maxlength="255" size="8" value=""/>
			<label>First</label>
		</span>
		<span>
			<input id="element_1_2" name="lastName" class="element text" maxlength="255" size="14" value=""/>
			<label>Last</label>
		</span>
    </li>
    <li id="li_2">
        <label class="description" for="element_2">Email * </label>
        <div>
            <input id="element_2" name="email" class="element text medium" type="text" maxlength="255" value=""/>
        </div>
    </li>

    <li id="li_3">
        <label class="description" for="element_3">Phone </label>
		<span>
			<input id="element_3_1" name="phone" class="element text" size="15" maxlength="20" value="" type="text">
		</span>
    </li>
    <li id="li_4">
        <label class="description" for="element_4">Address </label>
        <div>
            <textarea id="element_4" name="address" class="element textarea small"></textarea>
        </div>
    </li>
    <li class="section_break">
        <h3>Log in details</h3>
        <p></p>
    </li>
    <li id="li_6">
        <label class="description" for="element_6">New username * </label>
        <div>
            <input id="element_6" name="username" class="element text medium" type="text" maxlength="255" value=""/>
        </div>
    </li>
    <li id="li_7">
        <label class="description" for="element_7">New password * </label>
        <div>
            <input id="element_7" name="password" class="element text medium" type="password" maxlength="255" value=""/>
        </div>
    </li>
    <li id="li_8">
        <label class="description" for="element_8">Confirm password * </label>
        <div>
            <input id="element_8" name="element_8" class="element text medium" type="password" maxlength="255"
                   value=""/>
        </div>
    </li>



    <!-- specifies the venue for this client -->
    <li id="li_9" >
        <label class="description" for="element_10">Select Client's Venue* </label>
        <div>
            <select class="element select medium" id="element_10" name="venue">
                <option value="" selected="selected"></option>
                <?php
                $result = mysql_query("SELECT id,name FROM Venues;") or die(mysql_error());
                while($row = mysql_fetch_assoc($result)){
                    echo "<option value='".$row['id']."' >".$row['name']."</option>";
                }
                ?>
            </select>
    </li>

    <li class="buttons">
        <input type="hidden" name="form_id" value="626766"/>
        <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit"/>
    </li>

<?php include("includes/form_footer.php");