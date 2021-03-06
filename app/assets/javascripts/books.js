$(document).ready(function() {

  // My Books
  $(document.body).on('click', '#my-books-btn', function(e) {
    $("#my-books-btn").attr('disabled', 'disabled');
    clearDivs();
    var userId = $(this).data('id');
    var url = "http://localhost:3000/users/" + userId + "/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        var newBookButton = "<button type='button' class='btn btn-primary' data-user='" + data.user.id + "'id='new-book-btn'>Add a New Book</button>";
        $("#my-books-btn").removeAttr('disabled');
        // the following conditional determines whether current_user has any books
        if (data.books) {
          var myBooksHtml = HandlebarsTemplates['allBooksTemplate']({
            books: data.books,
            mine: data.mine
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

  // All Books (not including current_user's own)
  $(document.body).on('click', '#all-books-btn', function(e) {
    clearDivs();
    $("#all-books-btn").attr('disabled', 'disabled');
    var inputField = "<div id='input-area'><input name='search' id='search-field' type='text' size='50' placeholder='Enter keyword (title, author, ISBN) here to search'/></div><div id='search-btn-area'><button id='json-search-btn' class='btn btn-primary'>Search</button></div>"
    var url = "http://localhost:3000/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#all-books-btn").removeAttr('disabled');
        var allBooksHtml = HandlebarsTemplates['allBooksTemplate']({
          books: data.books,
        });

        $('#display-area').html(inputField);
        $('#display-area').append(allBooksHtml);
      },
      error: function() {
        console.log("Sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // Show book
  $(document.body).on('click', '.show-book-btn', function(e) {
    clearDivs;
    var userId = $(this).data('user');
    var bookId = $(this).data('book');
    var url = "http://localhost:3000/users/" + userId + "/books/" + bookId + ".json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        if (data.msg) {
          clearDivs();
          $('.alert').html(data.msg);
        } else {
          var book = JSON.parse(data.book);
          var trade = JSON.parse(data.trade);
          var other_trader_rating = JSON.parse(data.other_trader_rating)
          console.log(book)
          //extend(book);
          book.authorFullName = "Bob"//book.authorFullName();
          var showBookHtml = HandlebarsTemplates['showBookTemplate']({
            book: book,
            trade: trade,
            other_trader_rating: other_trader_rating
          });
          $('#display-area').html(showBookHtml);
        }
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // Render edit form
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
        var editBookForm = HandlebarsTemplates['bookForm']({
          book: JSON.parse(data.book),
        });
        var allGenres = findAllGenres(data);
        var bookGenres = JSON.parse(data.book).genres;
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


  // Update book
    $(document.body).on('click', '#update-book-btn', function(e) {
      e.preventDefault();
    $('#update-book-btn').attr('disabled', 'disabled');
    //var myData = $('#book-form').serialize(); --> does not work as planned
    var genres = []
    var title = ($('#book_title').val());
    var lastName = ($('#book_author_last_name').val());
    var firstName = ($('#book_author_first_name').val());
    var isbn = ($('#book_isbn').val());
    var description = ($('#book_description').val());
    var condition = $(document.querySelector('input[name=book_condition]:checked')).val();
    $('input[name="book[genre_ids][]"]:checked').each(function() {
      genres.push(this.value);
    });
    var userId = $(this).data('user');
    var bookId = $(this).data('book');
    var url = "http://localhost:3000" + "/users/" + userId + "/books/" + bookId + ".json";
    var myData = {
      book: {
        title: title,
        author_last_name: lastName,
        author_first_name: firstName,
        isbn: isbn,
        condition: condition,
        description: description,
        genre_ids: genres
      }
    };
    console.log($('#book-form').serialize())
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
      $("#update-book-btn").removeAttr('disabled');
        alert(data.msg);
      },
      error: function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

// Delete Book
  $(document.body).on('click', '#delete-book-btn', function(e) {
    $('#delete-book-btn').attr('disabled', 'disabled');
    var userId = $(this).data('user');
    var bookId = $(this).data('book');
    var url = "http://localhost:3000" + "/books/" + bookId + ".json";
    var myData = {
      book: {
        id: bookId
      }
    };
    $.ajax({
      dataType: "json",
      type: "DELETE",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $("#delete-book-btn").removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // Render New Book Form
  $(document.body).on('click', '#new-book-btn', function(e) {
    $("#new-book-btn").attr('disabled', 'disabled');
    var userId = $(this).data('user');
    var url = "http://localhost:3000/users/" + userId + "/books/" + "new.json"
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        clearDivs();
        $("#new-book-btn").removeAttr('disabled');
        if (data.msg) {
          $('.alert').html(data.msg);
        } else {
          newBookForm = HandlebarsTemplates['newBookForm']({
            data: data
          });
          var allGenres = findAllGenres(data);
          $('#display-area').html(newBookForm);
          $('#all-genres').html(allGenres);
        };
      },
      error: function() {
        console.log("Sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // Create a New Book (submit new book form)
  $(document.body).on('click', '#create-book-btn', function(e) {
    $('#create-book-btn').attr('disabled', 'disabled');
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
    var url = "http://localhost:3000" + "/users/" + userId + "/books.json";
    var myData = {
      book: {
        title: title,
        author_last_name: last_name,
        author_first_name: first_name,
        isbn: isbn,
        condition: condition,
        description: description,
        genre_ids: genres
      }
    };
    $('#create-book-btn').removeAttr('disabled');
    $.ajax({
      dataType: "json",
      type: "POST",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        alert(data.msg);
      },
      error: function() {
        clearDivs();
        console.log("Sumpin broke!");
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
        var allBooksHtml = HandlebarsTemplates['allBooksTemplate']({
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


  // Load More Books
  $(document.body).on('click', '.load-more-books-btn', function(e) {
    $(".load-more-books-btn").hide();
    var lastId = $('.show-book-btn').last().data('book');
    var url = "http://localhost:3000/books.json?lastid=" + lastId;
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        if (data.books.length == 0) {
          console.log("End of books array");
        } else {
          var allBooksHtml = HandlebarsTemplates['allBooksTemplate']({
          books: data.books
        });
        $('#display-area').append(allBooksHtml);
        }
      },
      error: function() {
        console.log("Sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
});
