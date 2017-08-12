$(document).ready(function(){ 

  // My trades

  $(document.body).on('click', '#my-trades-btn', function(e){
    $("#my-trades-btn").attr('disabled', 'disabled');
    clearDivs();

    //var personId = this.getAttribute('data-id');
    var url = "http://localhost:3000/trades.json";
    
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#my-trades-btn").removeAttr('disabled');
        myTradesHtml = HandlebarsTemplates['myTradesTemplate'] ({
          mustRespond: data.my_must_respond_trades,
          initiated: data.my_initiated_trades,
          completed: data.my_completed_trades
        });
        $('#display-area').html(myTradesHtml);
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // View other trader's books to complete a trade

  $(document.body).on('click', '#see-books-btn', function(e){
    $("#see-books-btn").attr('disabled', 'disabled');
    clearDivs();
    var userId = $(this).data('user');
    var url = "http://localhost:3000/users/" + userId + "/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#my-books-btn").removeAttr('disabled');
        // the following conditional determines whether current_user has any books
        if (data.books[0].id) {
          var usersBooksHtml = HandlebarsTemplates['allBooksTemplate'] ({
            books :data.books
          });  
          $('#display-area').html(usersBooksHtml);
          $('.notice').html(data.msg);
        } else {
          $('.notice').html(data.msg);
        };
      }, 
      error: function() {
        console.log("sumpin broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });




// var x = $(document.querySelector('input[name=user_review]:checked')).val();
// var rating = parseInt(x);
// <button type="button" class="btn btn-primary btn-xs" {data-trader1={{trade.first_trader_id}} data-trader2={{book.user_id}} 
// data-trade={{trade.id}} data-book={{book.id}} id="request-trade-btn">Request a Trade</button>

  // Request a New Trade, create trade action

  $(document.body).on('click', '#request-trade-btn', function(e){
    $('#request-trade-btn').attr('disabled', 'disabled');
    clearDivs();
    var bookFirstTraderWantsId = $(this).data('book');
    var firstTraderId = $(this).data('trader1'); 
    var secondTraderId = $(this).data('trader2');
    var url = "http://localhost:3000/trades";
    //console.log(bookId);
    var myData = { trade: { book_first_trader_wants_id: bookFirstTraderWantsId, first_trader_id: firstTraderId, second_trader_id: secondTraderId }};
      $.ajax({
        dataType: "json",
        type: "POST",
        url: url,
        data:  myData,
        success: function(data) {
          clearDivs();
          $("#request-trade-btn").removeAttr('disabled');
          $('.notice').html(data.msg);
        },
        error : function() {
          console.log("Sumpin broke!");
        }
      });
      e.stopImmediatePropagation();
        return false;
    });





















});