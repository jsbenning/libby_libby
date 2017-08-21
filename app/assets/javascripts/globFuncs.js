// Functions that are called from various other js files, 'globally' yu might say...

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
    var cdate = arr[i].created_at;
    var cslice = cdate.slice(0, 10).split("-");
    var cscramble = assignMonth(cslice[1]) + " " + cslice[2] + ", " + cslice[0];
    arr[i].created_at = cscramble;

    var udate = arr[i].updated_at;
    var uslice = udate.slice(0, 10).split("-");
    var uscramble = assignMonth(uslice[1]) + " " + uslice[2] + ", " + uslice[0];
    arr[i].updated_at = uscramble;
  }
}

function assignMonth(str) {
  month = "";
  switch(str) {
    case "01":
      month = "January";
      break;
    case "02":
      month = "February";
      break;
    case "03":
      month = "March";
      break;
    case "04":
      month = "April";
      break;
    case "05":
      month = "May";
      break;
    case "06":
      month = "June";
      break;
    case "07":
      month = "July";
      break;
    case "08":
      month = "August";
      break;
    case "09":
      month = "September";
      break;
    case "10":
      month = "October";
      break;
    case "11":
      month = "November";
      break;
    case "12":
      month = "December";
      break;
  }
  return month;
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