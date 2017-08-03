$(document).ready(function(){ 

  $('#display-area').unbind('click').on('click', '.show-book-btn', function(e) {
    clearDivs;
    var userId = $(this).attr('data-value1');
    var bookId = $(this).attr('data-value2');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        function extend(obj) {
          obj.authorFullName = function() {
            return this.author_first_name + " " + this.author_last_name
          }
        }
        var book = data["book"];
        extend(book);
        book.authorFullName = book.authorFullName();
        bookHtml = HandlebarsTemplates['showBookTemplate'] ({
          book: book
        });
      $('#display-area').html(bookHtml);
      var bookUser = ($('#trade-request-btn').attr('data-user'));
      var bookId = ($('#trade-request-btn').attr('data-book'));
      },

      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
});
