$(document).ready(function(){ 


  // My Books
  $(document.body).on('click', '#my-books-btn', function(e){ 
    $("#my-books-btn").attr('disabled', 'disabled');
    clearDivs();
    
    
    var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + personId + "/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        books: data.books
        var newBookButton = "<button type='button' class='btn btn-primary' data-user=" + books.user_id + "id='new-book-btn'>Add a Book</button>";
        $("#my-books-btn").removeAttr('disabled');
        if (books[0].id > ) {
          booksListHtml = HandlebarsTemplates['allBooksTemplate'] ({
          });  
          $('#display-area').html(booksListHtml);
          $('#display-area').append(addBookButton);
        } else {
          $('.notice').html(data.msg);
          $('#display-area').html(newBookButton);
        };
      }, 
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  //All Books

  $(document.body).on('click', '#all-books-btn', function(e) {
    clearDivs();
    $("#all-books-btn").attr('disabled', 'disabled');
    
    var url = "http://localhost:3000/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#all-books-btn").removeAttr('disabled');
        allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
          books: data.books,
          user: data.user
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

  // $(document.body).on('click', '#json-search-btn', function(e) {
  //   $("#json-search-btn").attr('disabled', 'disabled');
    
  //   var searchTerm = $('#search-field').text;
  //   console.log(searchTerm);
    // var url = "http://localhost:3000/books.json?Search=" + searchTerm;
    // clearDivs();
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
  //});

  // Create a Book

  $(document.body).on('click', '#new-book-btn', function(e) {
    clearDivs();
    var userId = $(this).attr('data-user');
    console.log(userId);
    // $("#new-book-btn").attr('disabled', 'disabled');
    // var url = "http://localhost:3000/users/" + userId + "/books/" + "new.json"
    // $.ajax({
    // dataType: "json",
    //   url: url,
    //   success: function(data) {
    //     $("#new-book-btn").removeAttr('disabled');
    //     newBookHtml = HandlebarsTemplates['newBookForm'] ({
    //     data: data
    //   });
    //   $('#display-area').html(newBookForm);
    // },
    // error: function() {
    //     console.log("Sumpin broke");
    //   }
    // });
    // e.stopImmediatePropagation();
    // return false;
  });


  // Load More Books

  // $(document.body).on('click', 'load-more-books-btn', function() {
  //   alert("Wow!");
  // })

});