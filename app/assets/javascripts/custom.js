$(document).ready(function(){

// Image functions
  $(".backup_picture_small").on("error", function(){
      $(this).attr('src', './images/no-image-s.png');
  });

  $(".backup_picture_large").on("error", function(){
      $(this).attr('src', './images/no-image-l.png');
  });


// #Profile Functions

  $("#my-profile-btn").on('click', function(e) { 
    $("#my-profile-btn").attr('disabled', 'disabled');
    // if ($("#display-area")) {
    //   $("#display-area").innerHTML = "";
    // }
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


  //Book#index_all functions

  //'Load More' button

  //   $('#display-area').unbind('click').on('click', '', function(e) {
  //     e.preventDefault();
  //   var last_id = $('.boxframe').last().attr('data-value2');
  //   alert(last_id);
  // });

  //   $.ajax({
  //     type: 'GET',
  //     url: "http://localhost:3000/books.json",
  //     data: {
  //       id: last_id
  //     },
  //     dataType: "script",
  //     success: function () {
  //       $('.button.load-more').show();
  //     };    
  //   });
  // });

  // Generate all books (books#index_all)

  $("#all-books-btn").on('click', function(e) { 
    $("#all-books-btn").attr('disabled', 'disabled');
    $("#display-area").html('');


    var searchButton = "<form accept-charset='UTF-8' action='/books' method='get'><input name='search' type='text' id='search' size='50' placeholder='Enter keyword(title, author, ISBN) here to search'/><br><br><input type='submit' class='btn btn-primary' value='Search' /></form>"

    var url = "http://localhost:3000/books.json";
    var html = searchButton;
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#all-books-btn").removeAttr('disabled');
        for (var i=1; i < data.length; i++) {
          html += "<div class='boxframe'>";
          html += "<img src='http://covers.openlibrary.org/b/isbn/" + data[i].isbn + "M.jpg?default=false' alt='bookcover' onerror=\"this.src='/assets/no-image-s.png'\" style='width:43px;height:60px;'>"
          html += "<h3>" + data[i].title + "</h3>";
          html += "<p>Author: " + data[i].author_first_name + " " + data[i].author_last_name + "</p><br>";
          html += "<button type='button' class='btn btn-primary btn-xs show-book-btn' data-value1='" + data[i]["user"]["id"] + "' data-value2='" + data[i].id +"'>Click for More</button>"
          html += "</div>"
        }
        html += "<a href='a' class='load-more-link'>Load More</a>"
      $("#display-area").append(html);  
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // books#show
  $('#display-area').unbind('click').on('click', 'button', function(e) {
    $("#display-area").html('');
    var userId = $(this).attr('data-value1');
    var bookId = $(this).attr('data-value2');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    var html = "<div class='boxframe'>"
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        html += "<img src='http://covers.openlibrary.org/b/isbn/" + data.isbn + "M.jpg?default=false' alt='bookcover' onerror=\"this.src='/assets/no-image-l.png'\" style='width:178px;height:255px;'>";
        html += "<h3 class='boxframe-title'>Title: " +  data.title + "</h3>";  
        html += "<p class='boxframe-subj'>Author: </p>";
        html += "<p class='boxframe-desc'>" +  data.author_last_name + ", " +  data.author_first_name + "</p>";
        //html += "<p class='boxframe-subj'>Genre(s):</p>";
        html += "<p class='boxframe-subj'> ISBN: </p>";
        html += "<p class='boxframe-desc'> " +  data.isbn + "</p>";
        html += "<p class='boxframe-subj'>Condition:</p>";
        html += "<p class='boxframe-desc'> " +  data.condition + "</p>";
        html += "<p class='boxframe-subj'>Description:</p>";
        html += "<p class='boxframe-desc'>" +  data.description + "</p>";
        html += "<hr>";
      $("#display-area").append(html);  
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
})


     // <% data.genres.each do |genre| %>
     //   <p class='boxframe-desc'><%= genre.name %></p>
     // <% end %>
    

    // <h3 class="boxframe-title">Title: <%= data.title %></h3>
    // <p class="boxframe-subj">Author: </p>
    // <p class="boxframe-desc"><%= data.author_last_name %>, <%= data.author_first_name %></p>

    // <p class="boxframe-subj">Genre(s):</p>
    // <% data.genres.each do |genre| %>
    //   <p class="boxframe-desc"><%= genre.name %></p>
    // <% end %>

    // <p class="boxframe-subj"> ISBN: </p>
    // <p class="boxframe-desc"> <%= data.isbn %></p>
    // <p class="boxframe-subj">Condition:</p>
    // <p class="boxframe-desc"> <%= data.condition %></p>
    // <p class="boxframe-subj">Description:</p>
    // <p class="boxframe-desc"><%= data.description%></p>
    // <hr>

    // <% if data.user == current_user %>
    
    //   <%= link_to 'Edit Book', edit_user_book_path(@user, data), class: "btn btn-primary" %><br /><br />
      
    //   <%= button_to 'Delete Book', user_book_path(@user, data), :method => :delete, class: "btn btn-primary" %>

    // <% else %>

    //   <p>Book Owner Email: <%= data.user.email %></p>

    //   <p>Owner's Current Rating: <%= data.user.rating %> </p>

    // <% end %>  



