// Celestial filter panel
$('#filter-panel-wrapper').delegate('.categories a', 'click', function(){
	var itemSelected = $(this).attr('data-filter');
	alert("You selected: "+ itemSelected);
});

$('.categories a').click(function(){
	alert("You clicked a filter option!");
});