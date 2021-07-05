// you must keep the following lines on when you use this
// original idea from the Geocities Watermark
// © Nicolas - http://www.javascript-page.com

// customize this!
var window_says  = "Useful code snippets for Java, JS or PB developers!"; 
var image_width = 20;
var image_height = 20;
var left_from_corner = 0;
var up_from_corner = 0;
var JH = 0;
var JW = 0;
var JX = 0;
var JY = 0;
var left = image_width + left_from_corner + 17;
var up = image_height + up_from_corner + 15;
var wm;

if(navigator.appName == "Netscape") {
var wm = document.jsbrand;
}

if (navigator.appVersion.indexOf("MSIE") != -1){
var wm = document.all.jsbrand;
}
//5.0 (X11; es-ES)
// Netscape

//alert("Navegador = "+ navigator.appName+" Version = " + navigator.appVersion + " "+navigator.appVersion.indexOf("MSIE"));

wm.onmouseover = msover();
wm.onmouseout = msout();

function watermark() {
 if(navigator.appName == "Netscape") {
   JH = window.innerHeight;
   JW = window.innerWidth;
   JX = window.pageXOffset;
   JY = window.pageYOffset;
   wm.visibility = "hide";
   wm.top = (JH+JY-up);
   wm.left = (JW+JX-left);
   wm.visibility= "show";
 }

 if (navigator.appVersion.indexOf("MSIE") != -1){
  if (navigator.appVersion.indexOf("Mac") == -1){
   wm.style.display = "none";
   JH = document.body.clientHeight;
   JW = document.body.clientWidth;
   JX = document.body.scrollLeft;
   JY = document.body.scrollTop;
   wm.style.top = (JH+JY-up);
   wm.style.left =(JW+JX-left);
   wm.style.display = "";
  }
 }
}

function msover(){
    window.status = window_says;
    return true;
}

function msout(){
    window.status = "";
    return true;
}

setInterval("watermark()",100);

