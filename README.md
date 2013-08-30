# Stephanie's Rice

I couldn't be bothered documenting this one. Sue me.

Thing is I wanted to share the code as it's a good start for:

- A Sinatra based web app.
- Hitting an API, in this case the Google Search API, returning JSON, and parsing the results.
- Storing results in Mongo, using Mongoid.
- If/else logic in Mustache templates.

Enjoy.

## Installation

You're still reading this? Okay...

Firstly, make sure you've [installed Ruby](http://www.ruby-lang.org/en/). Also, install the [Heroku Toolbelt](https://toolbelt.heroku.com/) as it includes [Foreman](https://github.com/ddollar/foreman) for running Procfile-based applications.

"The Google Custom Search API requires the use of an API key, which you can get from the [Google APIs console](http://code.google.com/apis/console/?api=customsearch)." There's two parts to it: the API key and a cx ID which is the Search engine unique ID.

Then in terminal, clone me:

```
$ git clone https://github.com/kripy/stephanies-rice stephanies-rice
$ cd stephanies-rice
```

Now, create an ```.env``` file in the root directory of the project. The file should look like this:

```
SR_KEY=<Google API key>
SR_CX=<Google Search Engine cx ID>
```

Fire it up:

```
$ foreman start
```

Open up a browser at ```http://localhost:5000/```: now you're cooking!

## MIT LICENSE

Copyright (c) 2013 Arturo Escartin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.