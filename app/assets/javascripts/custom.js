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
        html += "<button type='button' class='btn btn-primary btn-xs load-more-books-btn'>Load More Books</button>"

      $("#display-area").append(html);  
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // $('#display-area').on('click', 'btn.load-more-books-btn', function() {
  //   alert("Wow!");
  // })

  // $('#display-area').unbind('click').on('click', '.btn', function(e) {
  //   var lastBookId = $('.boxframe').last().attr('data-value2');
  //   var url = "http://localhost:3000/books.json";
  //   alert('Yikes');
  //   $.ajax({
  //     dataType: "json",
  //     data: { id: lastBookId },
  //     url: url,
  //     success: function(data) {
  //        $("#all-books-btn").removeAttr('disabled');
  //       for (var i=1; i < data.length; i++) {
  //         html += "<div class='boxframe'>";
  //         html += "<img src='http://covers.openlibrary.org/b/isbn/" + data[i].isbn + "M.jpg?default=false' alt='bookcover' onerror=\"this.src='/assets/no-image-s.png'\" style='width:43px;height:60px;'>"
  //         html += "<h3>" + data[i].title + "</h3>";
  //         html += "<p>Author: " + data[i].author_first_name + " " + data[i].author_last_name + "</p><br>";
  //         html += "<button type='button' class='btn btn-primary btn-xs show-book-btn' data-value1='" + data[i]["user"]["id"] + "' data-value2='" + data[i].id +"'>Click for More</button>"
  //         html += "</div>"
  //       }
  //       html += "<div id='more-button'><button type='button' class='btn btn-primary btn-xs load-more-books-btn'>Load More Books</button></div>"

  //     $("#display-area").append(html);  
  //     },
  //     error: function() {
  //       console.log("sumpin broke");
  //     }
  //   });
  //   e.stopImmediatePropagation();
  //   return false;
  // });


  // books#show
  $('#display-area').unbind('click').on('click', '.show-book-btn', function(e) {
    $("#display-area").html('');
    var userId = $(this).attr('data-value1');
    var bookId = $(this).attr('data-value2');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    var html = "<div class='boxframe'>"
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        var book = data.book;
        html += "<img src='http://covers.openlibrary.org/b/isbn/" + book.isbn + "M.jpg?default=false' alt='bookcover' onerror=\"this.src='/assets/no-image-l.png'\" style='width:178px;height:255px;'>";
        html += "<h3 class='boxframe-title'>Title: " +  book.title + "</h3>";  
        html += "<p class='boxframe-subj'>Author: </p>";
        html += "<p class='boxframe-desc'>" +  book.author_first_name + " " +  book.author_last_name + "</p>";
        //html += "<p class='boxframe-subj'>Genre(s):</p>";
        html += "<p class='boxframe-subj'> ISBN: </p>";
        html += "<p class='boxframe-desc'> " +  book.isbn + "</p>";
        html += "<p class='boxframe-subj'>Condition:</p>";
        html += "<p class='boxframe-desc'> " +  book.condition + "</p>";
        html += "<p class='boxframe-subj'>Description:</p>";
        html += "<p class='boxframe-desc'>" +  book.description + "</p>";
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





