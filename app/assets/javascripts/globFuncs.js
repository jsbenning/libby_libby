var clearDivs = function() {
  $("#display-area").html("");
  $(".notice").html("");
  $(".alert").html("");
}

function extend(obj) {
  obj.authorFullName = function() {
    return this.author_first_name + " " + this.author_last_name
  }
}