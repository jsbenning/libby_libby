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
        var book = data.book;
        extend(book);
        book.authorFullName = book.authorFullName();
        var showBookHtml = HandlebarsTemplates['showBookTemplate'] ({
          data: data
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
    
    var searchTerm = $('#search-field').text;
    console.log(searchTerm);
    // var url = "http://localhost:3000/books.json?Search=" + searchTerm;
    // clearDivs();
    // $.ajax({
    //   dataType: "json",
    //   url: url,
    //   success: function(data) {
    //     $("#json-search-btn").removeAttr('disabled');
    //     var allBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
    //       books: data.books
    //     });

    //     $('#display-area').html(allBooksHtml);
    //   },
    //   error: function() {
    //     console.log("Sumpin broke");
    //   }
    // });
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
        success: function(data) { 
          //$("#edit-book-btn").removeAttr('disabled');
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



//     )))))))))))))

// function assignRadio(data) {
//   var bookCondition = JSON.parse(data.book).condition
//   var newCond = document.getElementById('book_condition_like_new');
//   var goodCond = document.getElementById('book_condition_good');
//   var fairCond = document.getElementById('book_condition_fair');
//   if (bookCondition == "Like New") {
//     newCond.checked = true;
//   } else if (bookCondition == "Good") {
//     goodCond.checked = true;
//   } else {
//     fairCond.checked = true;
//   }
// } 

// ))))))))))


    // Update Book

  $(document.body).on('click', '#test', function(e) {
    //var book_title = ($('#genre').val());
    
    e.preventDefault();
    console.log($('#book_title').val());
    
    // var book_title = ($('#book_title').val());
    // "book_author_last_name"
    // "book_author_first_name"
    // "book_ISBN"
    // "book_description"
    // $('#test').attr('disabled', 'disabled'); 
    // var bookId = this.data-book
    // var userId = this.data-user
    // var url = "http://localhost:3000/" + "/users/" + userId + "/books/" + bookId + "/update.json";
    // $.ajax({
    //   dataType: "json",
    //   type: "PATCH",
    //   url: url,
    //   data: { 
    //    { title: "Steve Jobs" }
    //   },
    //   success: function(data) {
    //     console.log("Yes");
    //   },
    //   error : function() {
    //     console.log("Crap");
    //   }
    // });
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