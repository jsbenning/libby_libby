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
          initiated: data.my_initiated_trades
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




var x = $(document.querySelector('input[name=user_review]:checked')).val();
var rating = parseInt(x);


  // Request a New Trade, create trade action
  //
  // $(document.body).on('click', '#request-trade-btn', function(e){
  //   $('#request-trade-btn').attr('disabled', 'disabled');
  //   clearDivs();
  //   var bookFirstTraderWantsId = $(this).data('book');
  //   var secondTraderId = $(this).data('user');
  //   var url = "http://localhost:3000/trades";
  //   var myData = 






  // <div class='boxframe-subj' id='trader1-rating'>Trader's Rating: {{other_trader_rating}} out of 3 (3 is best)
  // </div><br>
  //   <button type="button" class="btn btn-primary btn-xs" data-user={{book.user_id}} data-book={{book.id}} id="complete-trade-btn">Complete a Trade</button>
  



  // {{else if trade.status}}
  // <div class='boxframe-subj' id='trader1-rating'>Trader's Rating: {{other_trader_rating}} out of 3 (3 is best)
  // </div><br>
  //   <button type="button" class="btn btn-primary btn-xs" data-user={{book.user_id}} data-book={{book.id}} id="request-trade-btn">Request a Trade</button>
  




  // {{else}} 
  //   <button type="button" class="btn btn-primary btn-xs" data-user={{book.user_id}} data-book={{book.id}} id="edit-book-btn">Edit This Book</button>
  //   <button type="button" class="btn btn-primary btn-xs" data-user={{book.user_id}} data-book={{book.id}} id="delete-book-btn" onclick = "return confirm('are you sure?')">Delete This Book</button>
  // {{/if}}



  // id="request-trade-btn">

  // complete-trade-btn"















































});