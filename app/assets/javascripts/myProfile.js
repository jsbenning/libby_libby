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
  ('#display-area').unbind('click').on('click', '#edit-profile', function(e) { #This is FUBAR
    $("#edit-profile").on('click', function(e) { 
      $("#edit-profile").attr('disabled', 'disabled');
      $("#display-area").html('');
      console.log("Boo!");
    
      var personId = this.getAttribute('data-id');
      var url = "http://localhost:3000/users/" + personId + "/edit.json";
      
      $.ajax({
        dataType: "json",
        url: url,
        success: function(data) {
          $("#my-profile-btn").removeAttr('disabled');
          editMyProfileHtml = HandlebarsTemplates['editMyProfileTemplate'] ({
            user: data
          });
          $('#display-area').html(editMyProfileHtml);
        },
        error: function() {
          console.log("sumpin broke");
        }
      });
      e.stopImmediatePropagation();
      return false;
    });
  });

});