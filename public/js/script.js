$(document).ready(function() {
  $("#white_chips").click(function(){
    $(this).children(".slider").show();
    $(this).children(".range").show();  
  });
  $("#white_chips :range");  
  $("#chips img").draggable({
    revert: 'invalid',
	stack: '#chips',
  });
  $("#chip_pile").droppable();
  $(":range").rangeinput();
});