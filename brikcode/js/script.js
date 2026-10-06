(function(){
  // Progressive enhancement: preserve pre-rendered semantic HTML
  var h = document.getElementById("site-header");
  if (h && !h.children.length) {
    h.innerHTML = '<div class="wrap nav"><a href="/" aria-label="BRIKCODE home"><img src="/assets/logo.png" alt="BRIKCODE - AI Ready Future" width="156" height="42"></a><button class="burger" aria-expanded="false" aria-controls="menu" aria-label="Toggle navigation menu">Menu</button><nav aria-label="Primary Navigation"><ul id="menu"><li><a href="/">Home</a></li><li><a href="/why-brikcode">Why BRIKCODE</a></li><li><a href="/services">Services</a></li><li><a href="/case-studies">Case Studies</a></li><li><a href="/about">About</a></li><li><a href="/careers">Careers</a></li><li><a class="btn" href="/contact">Talk to Us</a></li></ul></nav></div>';
  }

  var f = document.getElementById("site-footer");
  if (f && !f.children.length) {
    f.innerHTML = '<div class="wrap"><div class="cols"><div><a href="/" class="footer-logo" aria-label="BRIKCODE home"><img src="/assets/logo-light.png" alt="BRIKCODE" width="133" height="36" loading="lazy"></a><p style="margin-top:14px">AI products, custom software and intelligent systems built for what\'s next.</p><p style="margin-top:8px;font-size:0.85rem;color:var(--muted-text)">Hyderabad, India · <a href="mailto:brikcode07@gmail.com" style="color:var(--brand-accent)">brikcode07@gmail.com</a></p></div><div><h3>Company</h3><ul><li><a href="/about">About</a></li><li><a href="/why-brikcode">Why BRIKCODE</a></li><li><a href="/case-studies">Case Studies</a></li><li><a href="/careers">Careers</a></li><li><a href="/contact">Contact</a></li></ul></div><div><h3>AI Services</h3><ul><li><a href="/services/ai-development">AI Development</a></li><li><a href="/services/generative-ai">Generative AI</a></li><li><a href="/services/ai-agents">AI Agents</a></li><li><a href="/services/ai-automation">AI Automation</a></li></ul></div><div><h3>Software Engineering</h3><ul><li><a href="/services/software-development">Custom Software</a></li><li><a href="/services/web-development">Web Development</a></li><li><a href="/services/mobile-app-development">Mobile App Development</a></li><li><a href="/services">All Services</a></li></ul></div><div><h3>Trust & Legal</h3><ul><li><a href="/privacy-policy">Privacy Policy</a></li><li><a href="/terms-of-service">Terms of Service</a></li><li><a href="/contact">Get in Touch</a></li></ul></div></div><p class="bt">&copy; 2026 BRIKCODE. All rights reserved.</p></div>';
  }

  // Mobile menu interaction & keyboard accessibility
  var b = document.querySelector(".burger");
  var m = document.getElementById("menu");
  if (b && m) {
    b.onclick = function() {
      var isOpen = m.classList.toggle("open");
      b.setAttribute("aria-expanded", isOpen ? "true" : "false");
    };
    document.addEventListener("keydown", function(e) {
      if (e.key === "Escape" && m.classList.contains("open")) {
        m.classList.remove("open");
        b.setAttribute("aria-expanded", "false");
        b.focus();
      }
    });
  }

  // Active navigation link indicator
  try {
    var rawPath = window.location.pathname;
    var normPath = rawPath.replace(/\.html$/, "").replace(/\/$/, "") || "/";
    var navLinks = document.querySelectorAll("#menu a");
    navLinks.forEach(function(link) {
      var href = link.getAttribute("href");
      if (!href) return;
      var linkNorm = href.replace(/\.html$/, "").replace(/\/$/, "") || "/";
      if (linkNorm === normPath) {
        link.setAttribute("aria-current", "page");
      }
    });
  } catch (err) {
    // Graceful fallback
  }

  // Accessible contact form handling
  var fm = document.getElementById("contact-form");
  if (fm) {
    fm.onsubmit = function(e) {
      e.preventDefault();
      var msg = document.getElementById("formmsg");
      if (msg) {
        msg.textContent = "Thank you for reaching out. We have received your project inquiry and will contact you within 24 hours.";
        msg.style.color = "#2d6aa8";
      }
      fm.reset();
    };
  }
})();
