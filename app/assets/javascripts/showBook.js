$(document).ready(function(){ 

  $('#display-area').unbind('click').on('click', '.show-book-btn', function(e) {
    $("#display-area").html('');
    var userId = $(this).attr('data-value1');
    var bookId = $(this).attr('data-value2');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    // function Book(data) {

    // }

    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {

        function extend(obj) {
          obj.authorFullName = function() {
            return this.author_first_name + " " + this.author_last_name
          }
        }
        extend(data);
        alert("hoo");
        data.authorFullName = data.authorFullName();
        bookHtml = HandlebarsTemplates['showBookTemplate'] ({
          book: data
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



