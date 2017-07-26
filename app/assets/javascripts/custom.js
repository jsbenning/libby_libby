$(document).ready(function(){

// Image functions
  $(".backup_picture_small").on("error", function(){
      $(this).attr('src', './images/no-image-s.png');
  });

  $(".backup_picture_large").on("error", function(){
      $(this).attr('src', './images/no-image-l.png');
  });


// #Profile Functions

  $("#profile").on('click', function(e) { 
    $("#profile").attr('disabled', 'disabled'); 
    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + ".json";
    var html = "<div class='boxframe'><h2>Your Profile: </h2>"
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#profile").removeAttr('disabled');
        html += '<p><strong>Your Real Name: ' + data['real_name'] + '</strong></p>'
        html += '<p><strong>Your Street Address: ' + data['street'] + '</strong></p>'
        html += '<p><strong>Your City: ' + data['city'] + '</strong></p>'
        html += '<p><strong>Your State: ' + data['state'] + '</strong></p>'
        html += '<p><strong>Your Zipcode: ' + data['zipcode'] + '</strong></p>'
        html += '<p><strong>Your Role: ' + data['role'] + '</strong></p>'
        html += '</div>';
        $("#myProfile").append(html);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  //Book#index_all functions



  $("#allbooks").on('click', function(e) { 
    $("#allbooks").attr('disabled', 'disabled'); 

    var searchButton = "<form accept-charset='UTF-8' action='/books' method='get'><input name='search' type='text' id='search' size='50' placeholder='Enter keyword(title, author, ISBN) here to search'/><br><br><input type='submit' class='btn btn-primary' value='Search' /></form>"

    var url = "http://localhost:3000/books.json";
    var html = searchButton;
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#allbooks").removeAttr('disabled');
        for (var i=1; i < data.length; i++) {
          html += "<div class='boxframe'>";
          html += "<img src='http://covers.openlibrary.org/b/isbn/" + data[i].isbn + "M.jpg?default=false' alt='bookcover' onerror=\"this.src='/assets/no-image-s.png'\" style='width:43px;height:60px;'>"
          html += "<h3>" + data[i].title + "</h3>";
          html += "<p>Author: " + data[i].author_first_name + " " + data[i].author_last_name + "</p><br>";
          html += "<button type='button' onclick='showABook();return false' class='btn btn-primary btn-xs bookButton' data-value1='" + data[i]["user"]["id"] + "' data-value-2='" + data[i].id +"'>Click for More</button>"
          html += "</div>"
        };
      $("#allBooks").append(html);  
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });



  // $(".bookButton").on('click', function() {
  //   //var userId = $(this).attr('data-value1');
  //   alert("Wow");
  // })





});




