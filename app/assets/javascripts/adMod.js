$(document).ready(function(){ 

  // View All Users
  $(document.body).on('click', '#mview-users-btn', function(e){
    $("#view-users-btn").attr('disabled', 'disabled');
    clearDivs();

    var personId = $(this).data('id');
    var url = "http://localhost:3000/users.json";
    
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#view-users-btn").removeAttr('disabled');
        allUsersHtml = HandlebarsTemplates['allUsersTemplate'] ({
          data: data
        });
        $('#display-area').html(allUsersHtml);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // View User Profile














});