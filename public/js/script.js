$(document).ready(function() {
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
      $(".playerhand").append(data);
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
