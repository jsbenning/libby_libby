$(document).ready(function(){
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
        booksListHtml = HandlebarsTemplates['test'] ({
          books: data
        });
        $('#display-area').html(booksListHtml);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
    });
});