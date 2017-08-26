$(document).ready(function() {
  
  // Show Profile
  $(document.body).on('click', '#my-profile-btn', function(e) {
    $("#my-profile-btn").attr('disabled', 'disabled');
    clearDivs();
    var personId = $(this).data('id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#my-profile-btn").removeAttr('disabled');
        myProfileHtml = HandlebarsTemplates['myProfileTemplate']({
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

  // Edit profile form
  $(document.body).on('click', '#edit-profile-btn', function(e) {
    $("#edit-profile-btn").attr('disabled', 'disabled');
    clearDivs();
    var userId = $(this).data('user');
    var url = "http://localhost:3000/users/" + userId + "/edit.json";
    $.ajax({
      dataType: "json",
      url: url,
      contentType: "application/javascript; charset=utf-8",
      success: function(data) {
        //console.log(data.user.real_name);
        $("#edit-profile-btn").removeAttr('disabled');
        var profileForm = HandlebarsTemplates['profileForm']({
          user: data.user,
        });
        $('#display-area').html(profileForm);
        $("#user_role").val(data.user.role); 
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // Update profile
    $(document.body).on('click', '#update-profile-btn', function(e) {
      e.preventDefault();
    $('#update-profile-btn').attr('disabled', 'disabled');
    //var myData = $('#profile-form').serialize();
    //console.log(myData); 
    var real_name = ($('#user_real_name').val());
    var street = ($('#user_street').val());
    var city= ($('#book_author_first_name').val());
    var state = ($('#user_state').val());
    var zipcode = ($('#user_zipcode').val());
    var role = ($('#user_role').val());
    var userId = $(this).data('user');
    var url = "http://localhost:3000" + "/users/" + userId + ".json";
    var myData = {
      user: {
        real_name: real_name,
        street: street,
        city: city,
        state: state,
        zipcode: zipcode,
        role: role
      }
    };
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
      $("#update-profile-btn").removeAttr('disabled');
        //$('.notice').html(data.msg);
        alert(data.msg);
      },
      error: function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });