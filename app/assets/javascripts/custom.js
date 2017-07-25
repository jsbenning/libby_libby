$(document).ready(function(){


  $(".backup_picture_small").on("error", function(){
      $(this).attr('src', './images/no-image-s.png');
  });

  $(".backup_picture_large").on("error", function(){
      $(this).attr('src', './images/no-image-l.png');
  });




  $("#profile").on('click', function() {  
    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        html += '<p><strong>Your Real Name: ' + data['real_name'] + '</strong></p>'
        html += '<p><strong>Your Street Address: ' + data['street'] + '</strong></p>'
        html += '<p><strong>Your City: ' + data['city'] + '</strong></p>'
        html += '<p><strong>Your State: ' + data['state'] + '</strong></p>'
        html += '<p><strong>Your Zipcode: ' + data['zipcode'] + '</strong></p>'
        html += '<p><strong>Your Role: ' + data['role'] + '</strong></p>'
        html += '</div>';
        $("#myProfile").append(html);
      }
    });
  });


});



