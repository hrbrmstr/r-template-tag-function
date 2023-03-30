---
{
  "title": "🧪 🕸️ An `R` Template 'Tag' Function",
   "description": "More straightforward way to call R code with some deliberate limitations.",
  "og" : {
    "site_name": "WebR Exeriments",
    "url": "https://rud.is/w/r-template-tag-function",
    "description": "More straightforward way to call R code with some deliberate limitations.",
    "image": {
      "url": "https://rud.is/w/r-template-tag-function/preview.png",
      "height": "836",
      "width": "1014",
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
# 🧪 An `R` Template "Tag" Function

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

## Another WebR Experiment? _Really_?

Yep!

There's some good stuff under the covers here.

First, you'll notice the page loaded pretty fast. That's b/c I moved the Markdown→HTML rendering offline via a hacky JS script I wrote. Rendering Markdown on the fly is cool and all, but it's not needed.

And, yes, you've seen Pyodide & WebR working together from me before (like, yesterday), but today we have some plumbing to look at since I also added a [Tag Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates) so you can do:

```js
await R`sample(100, 5)`
``` 

and it'll "`evalR`" and "`toJs`" the code between the template string (plus some other stuff we'll see below).

First, copy that to the clipboard, open DevTools and try it!

## Buttoning Thing Up

The code behind "Button #1" is:

```js
const rButton = document.getElementById("r-button")
rButton.disabled = false
rButton.onclick = async () => {
  const output = document.getElementById("r-output")
  output.innerText = JSON.stringify(await R`sample(100, 5)`) // what is this magic?
};
```

Thanks to that template function, the second to last line is very compact. The template/tag function applies some basic heuristics to determine whether it can return a "simple" type. If it can, it'll do all the work for you. I'll eventually get it to handle more complex return types (i.e. the horrible mess that is the WebR `toJs()` return value for a `data.frame`).

This `R` template function is not meant to take the place of `evalR…()`. Trying to shove too much functionality into a shortcut operation like this is fraught with peril. Plus, there are limitations.

To provide for a more complex situation, like when we want to pass in [`REvalOptions`](https://docs.r-wasm.org/webr/latest/api/js/interfaces/WebRChan.EvalROptions.html) to `evalR…()` we had to dedicate the use of `${}` to just letting you (optionally) pass in an `REvalOptions` structure, so no interpolation for you!

Let's take a look at "Button #3" to see what that looks like:

```js
const rpyButton = document.getElementById("rpy-button")
rpyButton.disabled = false
rpyButton.onclick = async () => {
  const output = document.getElementById("rpy-output")
  await webPy.runPython(`pyRange = list(range(1, 101))`)
  const opts = {
    env: { pyRange: webPy.globals.get(`pyRange`).toJs() }
  }
  output.innerText = JSON.stringify(await R`sample(pyRange, 5)${opts}`)
};
```

We are having Pyodide give us a range from `1:100`, and we want WebR to `sample()` from it. We need to get those values into WebR, and one good way is to hijack the `env` slot of `REvalOptions` and supply it as a named parameter. So, we set up our `REvalOptions` data structure:

```js
const opts = {
  env: {
    pyRange: webPy.globals.get(`pyRange`).toJs()
  }
}
```

then pass that into `R` via:

```js
await R`sample(pyRange, 5)${opts}`
```

That `${opts}` is then used by `evalR()` to provide the environment context for the function call.

We could also have done:

```js
sample = await R`sample`
simplifyRJs(await sample(await webPy.globals.get(`pyRange`).toJs(), 5))
```

Since the `R` template/tag function is also smart enough to recognize when it got an R `function` as a return value and just pass that back.

If you need fancier use of template strings for evaluating R code, then stick with the `evalR…()` family of functions. But remember you can pass the value of the final `toJs()` call through `simplifyRJs()` to get back easier to manage values (that function will become smarter over time).

### FIN

[Get it on GitHub](https://github.com/hrbrmstr/webr-pyodide-minimal-plus-markdown)
