$(document).ready(function(){ 

  $('#display-area').unbind('click').on('click', '.show-book-btn', function(e) {
    $("#display-area").html('');
    var userId = $(this).attr('data-value1');
    var bookId = $(this).attr('data-value2');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";

    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        bookHtml = HandlebarsTemplates['showBookTemplate'] ({
          book: data.book
        });
      $('#display-area').html(bookHtml);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
});