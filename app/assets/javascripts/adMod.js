$(document).ready(function() {
  // View All Users
  $(document.body).on('click', '#view-users-btn', function(e) {
    $("#view-users-btn").attr('disabled', 'disabled');
    clearDivs();
    var url = "http://localhost:3000/users.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#view-users-btn").removeAttr('disabled');
        allUsersHtml = HandlebarsTemplates['allUsersTemplate']({
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
  $(document.body).on('click', '#see-user-btn', function(e) {
    $("#see-user-btn").attr('disabled', 'disabled');
    clearDivs();
    var personId = $(this).data('id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#see-user-btn").removeAttr('disabled');
        userProfileHtml = HandlebarsTemplates['userProfileTemplate']({
          data: data
        });
        $('#display-area').html(userProfileHtml);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
  // Make profile invisible
  $(document.body).on('click', '#invisible-btn', function(e) {
    $('#invisible-btn').attr('disabled', 'disabled');
    var userId = $(this).data('id');
    var url = "http://localhost:3000" + "/users/" + userId + ".json";
    var myData = {
      user: {
        id: userId,
        visible: false
      }
    };
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $('#invisible-btn').removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
  // Make profile visible
  $(document.body).on('click', '#visible-btn', function(e) {
    $('#visible-btn').attr('disabled', 'disabled');
    var userId = $(this).data('id');
    var url = "http://localhost:3000" + "/users/" + userId + ".json";
    var myData = {
      user: {
        id: userId,
        visible: true
      }
    };
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $('#visible-btn').removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
});