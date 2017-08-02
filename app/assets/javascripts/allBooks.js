$(document).ready(function(){
  $("#all-books-btn").on('click', function(e) { 
    $("#all-books-btn").attr('disabled', 'disabled');
    $("#display-area").html('');
    
    var searchButton = "<form accept-charset='UTF-8' action='/books' method='get'><input name='search' type='text' id='search' size='50' placeholder='Enter keyword(title, author, ISBN) here to search'/><br><br><input type='submit' class='btn btn-primary' value='Search' /></form>"

    var url = "http://localhost:3000/books.json";

    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#all-books-btn").removeAttr('disabled');
        allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
          books: data
        });
        $('#display-area').html(allBooksHtml);
      },
      error: function() {
        console.log("Sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


});

  // $('#display-area').unbind('click').on('click', '.btn', function(e) { #an attempt to roll my own pagination scheme
  //   var lastBookId = $('.boxframe').last().attr('data-value2');
  //   var url = "http://localhost:3000/books.json";
  //
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