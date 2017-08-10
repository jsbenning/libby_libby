//wanted to revisit Handlebars, so I avoided the (mush easier) serialize method for my forms

$(document).ready(function(){ 


  // My Books
  $(document.body).on('click', '#my-books-btn', function(e){ 
    $("#my-books-btn").attr('disabled', 'disabled');
    clearDivs();  
    var userId = this.getAttribute('data-id');
    var url = "http://localhost:3000/users/" + userId + "/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        var newBookButton = "<button type='button' class='btn btn-primary' data-user=" + data.user.id + "id='new-book-btn'>Add a New Book</button>";
        $("#my-books-btn").removeAttr('disabled');
        if (data.books[0].id) {
          var myBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
            books :data.books
          });  
          $('#display-area').html(myBooksHtml);
          $('.notice').html(data.msg);
          $('#display-area').append(newBookButton);
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
        var allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
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
    var userId = $(this).data('user');
    var bookId = $(this).data('book');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        var book = JSON.parse(data.book);
        var trade = JSON.parse(data.trade);
        var other_trader_rating = JSON.parse(data.other_trader_rating)
        extend(book);
        book.authorFullName = book.authorFullName();
        var showBookHtml = HandlebarsTemplates['showBookTemplate'] ({
          book: book,
          trade: trade,
          other_trader_rating: other_trader_rating
        });
      $('#display-area').html(showBookHtml);
      $('.notice').html(data.msg);
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
    
    var searchTerm = $('#search-field').val();

    var url = "http://localhost:3000/books.json?search=" + searchTerm;
    clearDivs();
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#json-search-btn").removeAttr('disabled');
        var allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
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

  // Edit Book

    $(document.body).on('click', '#edit-book-btn', function(e) {
      clearDivs();
      var userId = $(this).data('user');
      var bookId = $(this).data('book');     
      var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + "/edit.json";
      $.ajax({
        dataType: "json",
        url: url,
        contentType: "application/javascript; charset=utf-8",
        success: function(data) { 
          $("#edit-book-btn").removeAttr('disabled');
          var editBookForm = HandlebarsTemplates['editBookForm'] ({
            book: JSON.parse(data.book),
            genres: JSON.parse(data.genres)
          });
          var allGenres = findAllGenres(data);

          $('#display-area').html(editBookForm);
          assignRadio(data);

          $('#all-genres').html(allGenres);
          assignBookGenres(data);
          $('.notice').html(data.msg); 
        },
        error: function() {
            console.log("Sumpin broke!");
          }
        });
      e.stopImmediatePropagation();
      return false;
    });




    // Update Book

  $(document.body).on('click', '#update-json', function(e) { 
    $('#update-json').attr('disabled', 'disabled');


    var genres = []    
    var title = ($('#book_title').val());
    var last_name = ($('#book_author_last_name').val());
    var first_name = ($('#book_author_first_name').val());
    var isbn = ($('#book_isbn').val());
    var description = ($('#book_description').val());
    var condition = $(document.querySelector('input[name=book_condition]:checked')).val();
    $('input[name="book[genre_ids][]"]:checked').each(function() {
      genres.push(this.value);
    });
    var userId = $(this).data('user'); 
    var bookId = $(this).data('book');
    var url = "http://localhost:3000" + "/users/" + userId + "/books/" + bookId + ".json";
    var myData = { book: { title: title, author_last_name: last_name, author_first_name: first_name, isbn: isbn, condition: condition, description: description, genre_ids: genres } };
    
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      //contentType: "application/javascript; charset=utf-8",
      data:  myData,
      success: function(data) {
        clearDivs();
        $('.notice').html(data.msg);
      },
      error : function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
      return false;
  });



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