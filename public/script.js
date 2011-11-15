$(document).ready(function() {
  $("#chips img").draggable({
    revert: 'invalid',
	stack: '#chips',
  });
  $("#chip_pile").droppable();
  


});