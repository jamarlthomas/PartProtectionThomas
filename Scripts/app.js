$(document).ready(function(){
  var headerOffset = $(".header").height() - $(".nav-bar").height();
  $(window).scroll(function() {
    var scrollTop = $(window).scrollTop();
    var alpha1 = 0.5 + (scrollTop / headerOffset);
    var alpha2 = 0.8 + (scrollTop / headerOffset);
    if (scrollTop < headerOffset) {
      $(".nav-bar").css({"background": "linear-gradient(to right bottom,rgba(255,255,255, 1), rgba(255,255,255, " + alpha2 + "), rgba(255,255,255," + alpha1 + "))"});
    } else {
      $(".nav-bar").css({"background": "#fff"});
    }
  });
});

//Slide controls
function toggleSection(idOfControlToToggle) {
    if (idOfControlToToggle == null || idOfControlToToggle == "") { return; }
    
    try {
        var display = $("#" + idOfControlToToggle).css("display");
      
        if (display == "block") {//it's currently open...close it
            $("#" + idOfControlToToggle).slideUp();
        }
        else {
            $("#" + idOfControlToToggle).slideDown();
        }

    }
    catch (err) {
        window.alert(err);
    }

}

//Show/hide Customer Details
function switchCustomerDetails() {
        if ($('#CustomerDetails').css("display") == 'none') {
            $("#CustomerForm").hide();
            $("#CustomerDetails").fadeIn(675);
        }
        else {
            $("#CustomerDetails").hide();
            $("#CustomerForm").slideDown(675);
        }
}

//Show/hide Vehicle Details
function switchVehicleDetails() {
    if ($('#VehicleDetails').css("display") == 'none') {
        $("#VehicleForm").hide();
        $("#VehicleDetails").fadeIn(675);
    }
    else {
        $("#VehicleDetails").hide();
        $("#VehicleForm").slideDown(675);
    }
}

$('#id_button_1').click(function () {
    $(this).parents('tr').first().remove();
});

//Add row for parts on details page
function addRowParts() {
    var myRow = "<tr><td><input style='width:60% !important;' class='one' type='text' data-bind='value: mechanic'/></td><td>column 2</td><td class='qrate'><input class='one' type='text' data-bind='value: product_quantity'/>&#64 <input data-bind='value: item_price'></span>&nbsp;each</td><td>column 4</td><td>column 5</td><td><a href='#' class='update' data-bind='click: $root.UpdateDetails'>Add</a></td></tr>";
    $("#PartsTable tr:last").after(myRow);
}

//Add row for labor on details page
function addRowLabor() {
    var myRow = "<tr><td><input style='width:60% !important;' class='one' type='text' data-bind='value: mechanic'/></td><td>column 2</td><td class='qrate'><input class='one' type='text' data-bind='value: product_quantity'/>&#64 <input data-bind='value: item_price'></span>&nbsp;/ hour</td><td>column 4</td><td>column 5</td><td class='span'><a href='#' class='update' data-bind='click: $root.UpdateDetails'>Add</a><a href='#' class='delete' data-bind='click: $root.DeleteDetails'>Remove</a></td></tr>";
    $("#LaborTable tr:last").after(myRow);
}