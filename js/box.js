$(window).load(function(){
	// Factoid Frames set width on load
	$rbox = $('#rbox-wrapper'),
	$rhdrL = $('.rbox-header-left');
	$('.rbox-header-right').width($rbox.width() - $rhdrL.width()-20);
});

$(window).resize(function(){
	// Factoid Frames set width on resize
	$rbox = $('#rbox-wrapper'),
	$rhdrL = $('.rbox-header-left');
	$('.rbox-header-right').width($rbox.width() - $rhdrL.width()-20);
});