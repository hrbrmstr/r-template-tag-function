---
{
  "title": "🧪 🕸️ Actual Minimal WebR App Shell With Pyodide",
  "og" : {
    "site_name": "WebR Exeriments",
    "url": "https://rud.is/w/webr-pyodide-minimal-plus-markdown",
    "description": "Select a data file (CSV) and let WebR (& Arquero) 'analyze' it for you!",
    "image": {
      "url": "https://rud.is/w/webr-pyodide-minimal-plus-markdown/preview.png",
      "alt": "example"
    }
  },
  "twitter": {
    "site": "@hrbrmstr",
    "domain": "rud.is"
  },
	"extra_header_bits": [
		"<link rel='apple-touch-icon' sizes='180x180' href='./favicon/apple-touch-icon.png'>",
		"<link rel='icon' type='image/png' sizes='32x32' href='./favicon/favicon-32x32.png'>",
		"<link rel='icon' type='image/png' sizes='16x16' href='./favicon/favicon-16x16.png'>",
		"<link rel='manifest' href='./favicon/site.webmanifest'>",
		"<link href='./style.css' rel='stylesheet'>",
		"<script type='module' src='./main.js'></script>"
	],
	"extra_body_bits": [
		"<!-- extra body bits -->"
	]
}
---
# 🧪 Actual Minimal WebR App Shell With Pyodide</h1>

<div class="widget" id="status-message">Please wait…initializing WebR & Pyodide…</div>

<div>
<button id="r-button" disabled>Get some random numbers from R</button>
<pre class="text-output" id="r-output">&nbsp;</pre>
</div>

<div>
<button id="py-button" disabled>Get some random numbers from Python</button>
<pre class="text-output" id="py-output">&nbsp;</pre>
</div>

<div>
<button id="rpy-button" disabled>Get some random numbers from R that uses an array supplied by Python</button>
<pre class="text-output" id="rpy-output">&nbsp;</pre>
</div>

I added also a <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates">Tag Function</a> so you can do:

```js
await R`sample(100, 5)`
```

<p>and it'll "<code>evalR</code>" and "<code>toJs</code>" the code between the template string.</p>

<p>Copy that to the clipboard, open DevTools and try it!</p>

<p><a href="https://github.com/hrbrmstr/slightly-more-than-minimal/tree/batman">Get it on GitHub</a>.</p>
