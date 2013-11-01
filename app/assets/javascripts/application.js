// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require angular
//= require_tree .

function setHash(a) {
	location.hash = a;
	//$.browser.msie ? $.locationHash(a) : location.hash = a;
}

var mini_to_thumb_re = new RegExp("mini","g");
var thumb_to_mini_re = new RegExp("thumb","g");

function init_zoom_image() {
	$('img.image_of_entry').bind("click",function(){
		var old_src = $(this).attr("src");
		var new_src = "";
		console.log("old_src:"+old_src);
		if (old_src.indexOf("mini") > -1) {
			new_src = old_src.replace(mini_to_thumb_re,"thumb");
			$(this).removeClass("mini").addClass("thumb");
		} else if (old_src.indexOf("thumb") > -1) {
			new_src = old_src.replace(thumb_to_mini_re,"mini");
			$(this).removeClass("thumb").addClass("mini");
		}
		console.log("new_src:"+new_src)
		if (new_src.length > 0) {
			//$(this).fadeOut("slow",function(){
				$(this).attr("src",new_src);
			//}).fadeIn("slow");
		}
	});
};