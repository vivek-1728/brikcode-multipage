(function(){
var pages=[["index.html","Home"],["why-brikcode.html","Why BRIKCODE"],["services.html","Services"],["about.html","About"],["careers.html","Careers"],["contact.html","Contact"]];
var cur=location.pathname.split("/").pop()||"index.html";
var li=pages.map(function(p){return '<li><a href="'+p[0]+'"'+(p[0]===cur?' aria-current="page"':'')+'>'+p[1]+'</a></li>'}).join("");
var h=document.getElementById("site-header");
if(h)h.innerHTML='<div class="wrap nav"><a href="index.html" aria-label="BRIKCODE home"><img src="assets/logo.png" alt="BRIKCODE logo, AI Ready Future"></a><button class="burger" aria-expanded="false" aria-controls="menu">Menu</button><ul id="menu">'+li+'<li><a class="btn" href="contact.html">Talk to Us</a></li></ul></div>';
function col(t,a){return '<div><h3>'+t+'</h3><ul>'+a.map(function(x){return '<li><a href="'+(x[1]||'#')+'">'+x[0]+'</a></li>'}).join("")+'</ul></div>'}
var f=document.getElementById("site-footer");
if(f)f.innerHTML='<div class="wrap"><div class="cols"><div><span class="lg"><img src="assets/logo.png" alt="BRIKCODE"></span><p style="margin-top:14px">AI products, software systems and technology built for what\'s next.</p></div>'
+col("Company",[["About","about.html"],["Why BRIKCODE","why-brikcode.html"],["Careers","careers.html"],["Contact","contact.html"]])
+col("Services",[["AI Products","services.html"],["SaaS Development","services.html"],["Custom Software","services.html"],["AI APIs","services.html"],["Automation","services.html"],["AI Infrastructure","services.html"]])
+col("Technology",[["Generative AI","services.html"],["Machine Learning","services.html"],["AI Agents","services.html"],["Data","services.html"],["Cloud","services.html"],["Security","services.html"]])
+col("Connect",[["LinkedIn [LinkedIn URL]"],["GitHub [GitHub URL]"],["Email","mailto:brikcode07@gmail.com"]])
+'</div><p class="bt">© 2026 BRIKCODE. All rights reserved.</p></div>';
var b=document.querySelector(".burger");
if(b)b.onclick=function(){var m=document.getElementById("menu");var o=m.classList.toggle("open");b.setAttribute("aria-expanded",o)};
var fm=document.getElementById("contact-form");
if(fm)fm.onsubmit=function(e){e.preventDefault();document.getElementById("formmsg").textContent="Thanks. Your message is ready to send once the form is connected to a backend or email service."};
})();
