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

function parser(arr) {
  var newArr = []
  for (var i=0; i< arr.length; i++) {
    newArr.push(JSON.parse(arr[i]));
  }
return newArr;
}

function dateFormatter(arr) {
  for (var i=0; i < arr.length; i++) {
    var date = arr[i].created_at;
    var slice = date.slice(0, 10).split("-");
    var scramble = slice[1] + " " + slice[2] + ", " + slice[0];
    arr[i].created_at = scramble;
    var date = arr[i].updated_at;
    var slice = date.slice(0, 10).split("-");
    var scramble = slice[1] + " " + slice[2] + ", " + slice[0];
    arr[i].updated_at = scramble;
  }
}

function assignRadio(data) {
  var bookCondition = JSON.parse(data.book).condition
  var newCond = document.getElementById('book_condition_like_new');
  var goodCond = document.getElementById('book_condition_good');
  var fairCond = document.getElementById('book_condition_fair');
  if (bookCondition == "Like New") {
    newCond.checked = true;
  } else if (bookCondition == "Good") {
    goodCond.checked = true;
  } else {
    fairCond.checked = true;
  }
}

function assignBookGenres(data) {
  var bookGenres = JSON.parse(data.book).genres;
  var inputs = document.getElementsByTagName("input");
  var bookIds = [];
  for (i = 0; i < bookGenres.length; i++) {
    bookIds.push(bookGenres[i].id);
  }
  for (var i = 0; i < inputs.length; i++) {
    if (inputs[i].type == "checkbox") {
      for (var x = 0; x < bookIds.length; x++) {
        if (bookIds[x] == inputs[i].value) {
          inputs[i].checked = true;
        }
      }
    }
  }
}

function findAllGenres(data) {
  var check = ""
  var allGenres = JSON.parse(data.genres);
  for (i = 0; i < allGenres.length; i++) {
    check += "<input type='checkbox' value='" + allGenres[i].id + "' name='book[genre_ids][]' id='book_genre_ids_" + allGenres[i].id + "' /><label for='book_genre_ids_" + allGenres[i].id + "' >" + allGenres[i].name + "</label>";
  }
  return check;
};