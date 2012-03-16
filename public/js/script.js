$(document).ready(function() {
  console.log("document ready");
  $(".chip_container").click(function(){
  console.log("click");
    $(".slider").hide();
    $(this).children(".slider").show();
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
   
  $(".slider").slider({
    animate: true,
    range: "min",
    value: 0,
    min: 0,
    max: 10,  
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
      console.log("image.");
    }      
  });
});
