$(document).ready(function(){
  $("#my-books-btn").on('click', function(e) { 
    $("#my-books-btn").attr('disabled', 'disabled');
    $("#display-area").html('');
    
    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + "/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        var addBookButton = "<button type='button' class='btn btn-primary' data-user={{data.user.id}} id='add-book-btn'>Add a Book</button>";
        $("#my-books-btn").removeAttr('disabled');
        if (data.book) {
          booksListHtml = HandlebarsTemplates['allBooksTemplate'] ({
            books: data
          });
          $('#display-area').html(booksListHtml);
          $('#display-area').append(addBookButton);
        } else {
          $('#msg-area').html(data.msg);
          $('#display-area').html(addBookButton);
        };
      }, 
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


});