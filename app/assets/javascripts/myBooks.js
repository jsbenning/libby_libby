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
        $("#my-books-btn").removeAttr('disabled');
        if (data) {
          booksListHtml = HandlebarsTemplates['allBooksTemplate'] ({
            books: data
          });
          $('#display-area').html(booksListHtml);
        } else {
          $('#display-area').html('');
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