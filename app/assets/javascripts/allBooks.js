/////// Golden key
//   $(document.body).on('click', 'button', function() {
//     alert ('button ' + this.id + ' clicked');
// });






$(document).ready(function(){

  $(document.body).on('click', '#all-books-btn', function(e) {
  //$("#all-books-btn").on('click', function(e) { 
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
});

  $(document.body).on('click', '#json-search-btn', function(e) {
  //$('#display-area').off('click').on('click', '#json-search-btn', function(e) { 

    //$("#json-search-btn").attr('disabled', 'disabled');
    
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