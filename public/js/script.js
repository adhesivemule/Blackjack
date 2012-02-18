$(document).ready(function() {
  $("#white_chips").click(function(){
    $(this).children(".slider").show();
    $(this).children(".range").show();  
  });  
  $("#chips img").draggable({
    revert: 'invalid',
	stack: '#chips',
  });
  $("#chip_pile").droppable( {
    drop: function(event, ui) {
      var chip = $(ui.draggable);
      console.log("chips" + chip.data("qty"));
    }
  });
   
  $(".slider").slider({
    animate: true,
    range: "min",
    value: 0,
    min: 0,
    max: $(".num_chips").text(),
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
      console.log("image.data" + img.data("qty"));
    }  
  });
});
