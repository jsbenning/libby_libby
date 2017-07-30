 $(document).ready(function(){

 //////Logo functions

  $("#banner-img").on('click', function(e) { 
  //$("#banner-img").attr('disabled', 'disabled');
  $("#display-area").html('');

    e.stopImmediatePropagation();
    return false;
  }); 

});