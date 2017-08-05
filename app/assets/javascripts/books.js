$(document).ready(function(){ 


  // My Books
  $(document.body).ready('click', '#my-books-btn', function(e){ 
    $("#my-books-btn").attr('disabled', 'disabled');
    $("#display-area").html('');
    clearDivs();
    
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
          $('.notice').html(data.msg);
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


  // All Books

  $(document.body).on('click', '#all-books-btn', function(e) {
    $("#all-books-btn").attr('disabled', 'disabled');
    clearDivs();
    var url = "http://localhost:3000/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#all-books-btn").removeAttr('disabled');
        allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
          books: data.books
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

  // Show Book

  $(document.body).on('click', '.show-book-btn', function(e) {
    clearDivs;
    var userId = $(this).attr('data-value1');
    var bookId = $(this).attr('data-value2');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        var book = data.book;
        extend(book);
        book.authorFullName = book.authorFullName();
        showBookHtml = HandlebarsTemplates['showBookTemplate'] ({
          data: data
        });
      $('#display-area').html(showBookHtml);
      $('.notice').html(data.msg);
      // var bookUser = ($('#trade-request-btn').attr('data-user'));
      // var bookId = ($('#trade-request-btn').attr('data-book'));
      },

      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // Search Function

  $(document.body).on('click', '#json-search-btn', function(e) {
    $("#json-search-btn").attr('disabled', 'disabled');
    
    var searchTerm = $('#search-field').text;
    console.log(searchTerm);
    // var url = "http://localhost:3000/books.json?Search=" + searchTerm;
    // clearDivs;
    // $.ajax({
    //   dataType: "json",
    //   url: url,
    //   success: function(data) {
    //     $("#json-search-btn").removeAttr('disabled');
    //     allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
    //       books: data.books
    //     });

    //     $('#display-area').html(allBooksHtml);
    //   },
    //   error: function() {
    //     console.log("Sumpin broke");
    //   }
    // });
    // e.stopImmediatePropagation();
    // return false;
  });
















































});