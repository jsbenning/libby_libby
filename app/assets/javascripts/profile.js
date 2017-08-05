$(document).ready(function(){ 


  // Show Profile
  $(document.body).on('click', '#my-profile-btn', function(e){
    $("#my-profile-btn").attr('disabled', 'disabled');
    clearDivs();

    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#my-profile-btn").removeAttr('disabled');
        myProfileHtml = HandlebarsTemplates['myProfileTemplate'] ({
          data: data
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
});