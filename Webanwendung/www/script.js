window.onload = function() {
	document.getElementsByTagName('html')[0].setAttribute('lang', 'de'); 
	$('#loading-content .progress-bar').css('width', '100%');
};

$(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip(); // $('[data-toggle="tooltip"]').tooltip("show");
});

$(function() {
	var cart = new MutationObserver(
	    function (mutations) {
	    	css_class = "#header_cart_overview "

	    	items = parseInt($(css_class + "li").length) - 3;
	    	items = items.toString();

	    	$(css_class + "li.header").text("Du hast " + items + " Schmankerl im Warenkorb");
	    	$(css_class + ".dropdown-toggle span.label").text(items);
	    }
	);

	var config = {attributes: true, childList: true, characterData: true};
	cart.observe(document.querySelector('#header_cart_overview'), config);
});