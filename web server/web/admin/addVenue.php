<?php
$requiredRole = 2;
require_once("includes/session.php");
$title = "Add Venue";
$action = "model_addVenue.php";
require_once("includes/form_header.php") ;
?>
			
		<li id="li_4" >
            <label class="description" for="element_4">Company logo * </label>
            <div>
                <input type="hidden" name="logoField" value="logo" />
                <input id="logo" name="logo" class="element file" type="file"/>
            </div>
            <p class="guidelines" id="guide_4"><small>Select a logo for the venue. Size of the company logo should be around 70 x 70 pixel</small></p>
		</li>
        <li id="li_1" >
            <label class="description" for="element_1">Venue Name * </label>
            <div>
                <input id="element_1" name="venueName" class="element text medium" type="text" maxlength="255" value="oxford venue"/>
            </div>
            <p class="guidelines" id="guide_1"><small>Please provide the name of the venue e.g. O2 Academy</small></p>
		</li>
        <li id="li_2" >
            <label class="description" for="element_2">Address * </label>
            <div>
                <textarea id="element_2" name="address" class="element textarea small"></textarea>
            </div><p class="guidelines" id="guide_2"><small>Address of the venue</small></p>
		</li>
        <li id="li_3" >
            <label class="description" for="element_3">Phone *</label>
            <div>
                <input id="element_3" name="phone" class="element text medium" type="text" maxlength="20" value=""/>
            </div><p class="guidelines" id="guide_3"><small>Phone number of the venue.</small></p>
		</li>
        <li id="li_5" >
		<label class="description" for="element_5">Email * </label>
            <div>
                <input id="element_5" name="email" class="element text medium" type="text" maxlength="255" value=""/>
            </div>
		</li>
        <li id="li_6" >
            <label class="description" for="element_6">Web Site </label>
            <div>
                <input id="element_6" name="web" class="element text medium" type="text" maxlength="255" value="http://www."/>
            </div>
		</li>
        <li id="li_7" >
            <label class="description" for="element_7">Venue Photo </label>
            <div>
                <input type="hidden" name="photoField" value="photo" />
                <input id="element_7" name="photo" class="element file" type="file"/>
            </div> <p class="guidelines" id="guide_7"><small>A photo that represent the venue e.g. front photo of the venue, or internal photo of the venue.</small></p>
		</li>
        <li id="li_8" >
            <label class="description" for="element_8">Description *</label>
            <div>
                <textarea id="element_8" name="description" class="element textarea medium"></textarea>
            </div><p class="guidelines" id="guide_8"><small>Description of the venue includes what are the specialities  and prides of this venue</small></p>
		</li>
		<li class="buttons">
			    <input type="hidden" name="form_id" value="620316" />
				<input id="saveForm" class="button_text" type="submit" name="submit" value="Submit" />
		</li>
<?php include("includes/form_footer.php");?>