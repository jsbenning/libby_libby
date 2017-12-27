$(document).ready(function() {

  // My trades
  $(document.body).on('click', '#my-trades-btn', function(e) {
    $("#my-trades-btn").attr('disabled', 'disabled');
    clearDivs();
    var url = "http://localhost:3000/trades.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $("#my-trades-btn").removeAttr('disabled');
        var init = parser(data.my_initiated_trades);//testing dataformatter
        var must = parser(data.my_must_respond_trades);
        var compInit = parser(data.my_completed_initiated_trades);
        var compResp = parser(data.my_completed_responded_trades);
        dateFormatter(init);
        dateFormatter(must);
        dateFormatter(compInit);
        dateFormatter(compResp);
        myTradesHtml = HandlebarsTemplates['myTradesTemplate']({
          init: init,
          must: must,
          compInit: compInit,
          compResp: compResp
        });
        $('#display-area').html(myTradesHtml);
      },
      error: function() {
        console.log("Sumpin' broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // View other trader's books to possibly complete a trade
  $(document.body).on('click', '.see-books-btn', function(e) {
    $(".see-books-btn").attr('disabled', 'disabled');
    clearDivs();
    var userId = $(this).data('user');
    var url = "http://localhost:3000/users/" + userId + "/books.json";
    $.ajax({
      dataType: "json",
      url: url,
      success: function(data) {
        $(".see-books-btn").removeAttr('disabled');
        // the following conditional determines whether current_user has any books
        if (data.books[0].id) {
          var usersBooksHtml = HandlebarsTemplates['allBooksTemplate']({
            books: data.books
          });
          $('#display-area').html(usersBooksHtml);
          $('.notice').html(data.msg);
        } else {
          $('.notice').html(data.msg);
        };
      },
      error: function() {
        alert("Sumpin' broke");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // Request a trade, create action in trades controller
  $(document.body).on('click', '#request-trade-btn', function(e) {
    $('#request-trade-btn').attr('disabled', 'disabled');
    clearDivs();
    var title = $(this).data('title');
    var bookFirstTraderWantsId = $(this).data('book');
    var firstTraderId = $(this).data('trader1');
    var secondTraderId = $(this).data('trader2');
    var url = "http://localhost:3000/trades";
    var myData = {
      trade: {
        book_first_trader_wants_id: bookFirstTraderWantsId,
        first_trader_id: firstTraderId,
        second_trader_id: secondTraderId
      }
    };
    $.ajax({
      dataType: "json",
      type: "POST",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $("#request-trade-btn").removeAttr('disabled');
        alert(data.msg);
      },
      error: function() {
        alert("Sumpin' broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // Complete a trade, current_user chooses second book as second trader, update action
  $(document.body).on('click', '.complete-trade-btn', function(e) {
    $('.complete-trade-btn').attr('disabled', 'disabled');
    clearDivs();
    var bookSecondTraderWantsId = $(this).data('book');
    var tradeId = $(this).data('trade');
    var url = "http://localhost:3000/trades/" + tradeId + ".json";
    var myData = {
      trade: {
        book_second_trader_wants_id: bookSecondTraderWantsId
      }
    };
    console.log(tradeId);
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $(".complete-trade-btn").removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin'' broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // Rate trader 1, if current_user is trader 2
  $(document.body).on('click', '.rate-trader1-btn', function(e) {
    $('.rate-trader1-btn').attr('disabled', 'disabled');


    var tradeId = $(this).data('trade');
    if (document.querySelector('input[name="user_review"]:checked')) {
      var x = document.querySelector('input[name="user_review"]:checked').value;
      rating = parseInt(x);
    } else {
      rating = 3
    }
    var url = "http://localhost:3000/trades/" + tradeId + ".json";
    var myData = {
      trade: {
        first_trader_rating: rating
      }
    };
    clearDivs();
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $('.rate-trader1-btn').removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin' broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });


  // Rate trader 2, if current_trader is trader 1
  $(document.body).on('click', '.rate-trader2-btn', function(e) {
    var rating;
    $('.rate-trader2-btn').attr('disabled', 'disabled');
    var tradeId = $(this).data('trade');
    if (document.querySelector('input[name="user_review"]:checked')) {
      var x = document.querySelector('input[name="user_review"]:checked').value;
      rating = parseInt(x);
    } else {
      rating = 3
    }
    var url = "http://localhost:3000/trades/" + tradeId + ".json";
    var myData = {
      trade: {
        second_trader_rating: rating
      }
    };
    clearDivs();
    $.ajax({
      dataType: "json",
      type: "PATCH",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $('.rate-trader2-btn').removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin' broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });

  // Cancel a trade
  $(document.body).on('click', '.cancel-trade-btn', function(e) {
    $('.cancel-trade-btn').attr('disabled', 'disabled');
    clearDivs();
    var tradeId = $(this).data('trade');
    var url = "http://localhost:3000/trades/" + tradeId + ".json";
    var myData = {
      trade: {
        id: tradeId
      }
    };
    $.ajax({
      dataType: "json",
      type: "DELETE",
      url: url,
      data: myData,
      success: function(data) {
        clearDivs();
        $('.cancel-trade-btn').removeAttr('disabled');
        $('.notice').html(data.msg);
      },
      error: function() {
        console.log("Sumpin' broke!");
      }
    });
    e.stopImmediatePropagation();
    return false;
  });
});
