// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery
// require jquery_ujs
// require turbolinks
//= require_tree .
var gameList = function(){
  $.get("/snl/rest/v1/board.json", function(response){
    $.each(response.response.board, function(index, board){
      boardLink = "<li>"
      boardLink = boardLink + "<a href='#' onclick='loadBoard("+board.id+")' id='"+board.id+"' class='board-link'>"+board.layout+"</a>";
      boardLink = boardLink + "</li>"
      $("ul.board-list").append(boardLink)
    });
  });
  $("section#landing").show();
}

var loadBoard = function(id){
  $("section.hiddenSection").hide();
  $("ul.player-list").html("");
  $("div.join-link").html("<a href='#' onclick='showJoinBoardForm("+id+")' class='join-link'>Join Board as Player</a>");
  $("div.delete-board-link").html("<a href='#' onclick='deleteBoard("+id+")' class='delete-board-link'>Delete Board</a>");
  $.get("/snl/rest/v1/board/"+id+".json", function(response){
    formatLayout(response.response.board.layout);
    $("div.board-layout").html(response.response.board.layout);
    $.each(response.response.board.players, function(index, player){
      playerLink = "<li>" + player.name + " | " + player.position
      if(response.response.board.turn === index+1){
        playerLink = playerLink + " | <a href='#' onclick='playTurn("+id+", "+player.id+")' class='play-link' id='"+player.id+"'>Play Turn</a>"
      }
      playerLink = playerLink + " | <a href='#' onclick='quitPlayer("+id+", "+player.id+")'>Quit Board</a>"
      playerLink = playerLink + "</li>"
      $("ul.player-list").append(playerLink)
    });
    $("section#board-details").show();
  });
}

var playTurn = function(boardid, playerid){
  $("section.hiddenSection").hide();
  $.get("/snl/rest/v1/move/"+boardid+".json?player_id="+playerid, function(response){
    loadBoard(boardid);
  });
}

var quitPlayer = function(boardid, playerid){
  $("section.hiddenSection").hide();
  $.ajax({
    url: "/snl/rest/v1/player/"+playerid+".json",
    type: 'DELETE',
    success: function(response) {
        loadBoard(boardid);
    }
  });
}

var showJoinBoardForm = function(boardid){
  $("section.hiddenSection").hide();
  form = "<label for='User Name:'>User Name: <input type='text' id='username'></input></label>";
  form = form + "<button onclick='joinBoard("+boardid+");'>Join Board</button>";
  $("div.join-player-form").html(form);
  $("section#join-player-form").show();
}

var joinBoard = function(boardid){
  $("section.hiddenSection").hide();
  content = new Object();
  content.board = boardid;
  content.player = new Object();
  content.player.name = $("input#username").val();
  $.ajax({
    type: "POST",
    url: '/snl/rest/v1/player.json',
    data: JSON.stringify(content),
    success: function(response){
      loadBoard(boardid);
    },
    dataType: "json"
  });
}

var createNewBoard = function(){
  $("section.hiddenSection").hide();
  $.get("/snl/rest/v1/board/new.json", function(response){
    loadBoard(response.response.board.id);
  });
}

var deleteBoard = function(id){
  $("section.hiddenSection").hide();
  $.ajax({
    url: "/snl/rest/v1/board/"+id+".json",
    type: 'DELETE',
    success: function(response) {
        window.location.href = '/snl/app/home';
    }
  });
}

var formatLayout = function(layout){
  layoutString = layout.split("] [").join("]#_^_#[");
  cells = layoutString.split("#_^_#")
  $.each(cells, function(index,cell){
    console.log(cell);
  })
}