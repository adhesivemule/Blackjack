$(document).ready(function() {
  var bet_confirmed = false;
  $(".chip_container").click(function(){
    $(".slider").hide();
    $(this).children(".slider").show();
    var max = $(this).find("img").data("max");
    $(this).find(".slider").slider("option", "max", max);
  });  
  $("#chips img").draggable({
    revert: 'invalid',
	stack: '#chips',
  });
  $("#chip_pile").droppable( {
    drop: function(event, ui) {
      bet_confirmed = true;
      var chip = $(ui.draggable);
      console.log("chips" + chip.data("qty") + chip.data("color"));
      $.ajax({
        url: "/bet/"+ chip.data("color") + "/" + chip.data ("qty")
      });
    }
  });
  $("#hit_button").click(function(event){
    event.preventDefault();
    $.ajax("/hit").success(function(data){
      $("#playerhand").append(data);
      $.ajax("/hit_check").success(function(data){
        console.log("Data" + data)
        $(".messages").html(data);
      });
    });
  });
  $("#stay_button").click(function(event){
    event.preventDefault();
    $.ajax("/stay").success(function(data){
      $("#dealerhand").empty();
      $("#dealerhand").append(data);
    });
  });
  $("#bet_button").click(function(event){
    event.preventDefault(); 
    console.log 
    if (!bet_confirmed){console.log ("bet_not_confirmed");return false;}
    $.getJSON("/deal", function(data) {
      $("#Hit_Stay").show();      
      $("#Bet_Button").hide();
      
      $.each(data["player_hand"], function(key, value){
        console.log("Value"+value);
        $("#playerhand").append("<li><img src='/images/Cards/"+value+"'/></li>");
      });
      $.each(data["dealer_hand"], function(key, value){
        console.log("Value"+value);
        $("#dealerhand").append("<li><img src='/images/Cards/"+value+"'/></li>");
      });
    });
  });    
  $(".slider").slider({
    animate: true,
    range: "min",
    value: 0,
    min: 0,
    step: 1,  
    slide: function(event, slider){
      var parent = $(event.target).parent();
      parent.find(".slider-result").html(slider.value);
      var new_qty = parent.find("img").data("max") - slider.value;
      parent.find(".num_chips").text(new_qty);
    },
    change: function(event, slider){
      var img = $(event.target).parent().find("img");
      img.data("qty", slider.value);
    }      
  });
});
