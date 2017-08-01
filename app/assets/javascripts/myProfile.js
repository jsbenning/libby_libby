$(document).ready(function(){

  $("#my-profile-btn").on('click', function(e) { 
    $("#my-profile-btn").attr('disabled', 'disabled');
    $("#display-area").html('');
  
    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        console.log(data.email);
        $("#my-profile-btn").removeAttr('disabled');
        myProfileHtml = HandlebarsTemplates['myProfileTemplate'] ({
          user: data
        });
        $('#display-area').html(myProfileHtml);
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