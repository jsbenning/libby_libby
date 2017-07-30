$(document).ready(function(){

// Profile Functions
    // Show

  $("#my-profile-btn").on('click', function(e) { 
    $("#my-profile-btn").attr('disabled', 'disabled');
    $("#display-area").html('');
  
    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    var html = "<div class='boxframe'><h2>Your Profile: </h2>"
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#my-profile-btn").removeAttr('disabled');
    
        html += '<p><strong>Your Real Name: ' + data['real_name'] + '</strong></p>'
        html += '<p><strong>Your Street Address: ' + data['street'] + '</strong></p>'
        html += '<p><strong>Your City: ' + data['city'] + '</strong></p>'
        html += '<p><strong>Your State: ' + data['state'] + '</strong></p>'
        html += '<p><strong>Your Zipcode: ' + data['zipcode'] + '</strong></p>'
        html += '<p><strong>Your Role: ' + data['role'] + '</strong></p>'
        html += '</div>';
        $("#display-area").append(html);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
  
    // Edit

});