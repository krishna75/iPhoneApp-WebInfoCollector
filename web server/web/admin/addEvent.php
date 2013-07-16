<?php
$requiredRole = 3;
require_once("includes/session.php");
require_once("includes/db_connection.php");
$title = "Add Event";
$action = "model_addEvent.php";
require_once("includes/form_header.php") ;
?>

    <li id="li_9">
        <label class="description" for="element_9">Date * </label>
    <span>
        <input title="day is required" id="date_1" name="dd" class="required element text" size="2" maxlength="2" value="" type="text"> /
        <label for="element_9_1">DD</label>
    </span>
    <span>
        <input title="month is required" id="date_2" name="mm" class="required element text" size="2" maxlength="2" value="" type="text"> /
        <label for="element_9_2">MM</label>
    </span>
    <span>
        <input title="year is required" id="date_3" name="yyyy" class="required element text" size="4" maxlength="4" value="" type="text">
        <label for="element_9_3">YYYY</label>
    </span>

    <span id="calendar_9">
        <img id="cal_img_9" class="datepicker" src="images/calendar.gif" alt="Pick a date.">
    </span>
        <script type="text/javascript">
            Calendar.setup({
                inputField: "date_3",
                baseField: "date",
                displayArea: "calendar_9",
                button: "cal_img_9",
                ifFormat: "%B %e, %Y",
                onSelect: selectEuropeDate
            });
        </script>
        <p class="guidelines" id="guide_9">
            <small>Date of the event for example 15/04/2013</small>
        </p>
    </li>
    <li id="li_1">
        <label class="description" for="element_1">Event Title* </label>

        <div>
            <input id="title" name="title" class="required element text medium" type="text" maxlength="255" value=""/>
        </div>
        <p class="guidelines" id="guide_1">
            <small>Please provide the title of the event. e.g. Grand Party</small>
        </p>
    </li>
    <li id="li_8">
        <label class="description" for="element_8">Description* </label>

        <div>
            <textarea id="description" name="description" class="required element textarea medium"></textarea>
        </div>
        <p class="guidelines" id="guide_8">
            <small>Description of the event. Including the time, special guests, DJ, offers etc</small>
        </p>
    </li>
    <li id="li_7">
        <label class="description" for="element_7">Event Photo* </label>

        <div>
            <input type="hidden" name="photoField" value="photo"/>
            <input id="photo" name="photo" class="required element file" type="file"/>
        </div>
        <p class="guidelines" id="guide_7">
            <small>If you have a poster of the event please upload it here. The ideal size of the poster would be 200 x
                300 pixel
            </small>
        </p>
    </li>
    <li id="li_10">
        <label class="description" for="element_10">Genre* </label>

        <div>
            <select class="required element select medium" id="genre" name="genre">
                <option value="" selected="selected"></option>
                <?php
                $result = mysql_query("SELECT * FROM SubGenres;") or die(mysql_error());
                while ($row = mysql_fetch_assoc($result)) {
                    echo "<option value='" . $row['id'] . "' >" . $row['subgenre'] . "</option>";
                }
                ?>
            </select>
        </div>
        <p class="guidelines" id="guide_10">
            <small>It is the genre of the event. Please select one from the drop down list.</small>
        </p>
    </li>
    <li id="li_11">
        <label class="description" for="element_11">Voucher* </label>

        <div>
            <textarea id="voucher" name="voucher" class="required element textarea medium"></textarea>
        </div>
        <p class="guidelines" id="guide_8">
            <small>Voucher for promotion: e.g. 10% discount with this voucher</small>
        </p>
    </li>
    <!-- if it is a client it is disabled -->
    <li id="venueSelector">
        <label class="description" for="element_10">Venue </label>

        <div>
            <select class="required element select medium" id="venue" name="venue">
                <?php
                if ($_SESSION['role'] == "3") {
                    $result = mysql_query("SELECT v.id as id,v.name as name
                    FROM Venues as v left join ( Users_Venues as uv)
                    ON (v.id=uv.venue_id)
                    WHERE uv.user_id='15';") or die(mysql_error());

                    $venueId = mysql_result($result, 0, "id");
                    $venueName = mysql_result($result, 0, "name");

                    echo ' <option value="' . $venueId . '" selected="selected">' . $venueName . '</option>';
                } else {
                    echo '<option value="" selected="selected"></option>';
                    $result = mysql_query("SELECT id,name FROM Venues;") or die(mysql_error());
                    while ($row = mysql_fetch_assoc($result)) {
                        echo "<option value='" . $row['id'] . "' >" . $row['name'] . "</option>";
                    }
                }
                ?>
            </select>
        </div>
        <p class="guidelines" id="guide_10">
            <small> Venue associated with this event</small>
        </p>
    </li>

    <li class="buttons">
        <input type="hidden" name="form_id" value="620316"/>
        <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit"/>
    </li>
<?php include("includes/form_footer.php");?>