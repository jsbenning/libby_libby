$(document).ready(function(){ 

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
          data: data
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













































});