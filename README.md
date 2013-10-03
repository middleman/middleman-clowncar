# middleman-clowncar

middleman-clowncar is an extension for the [Middleman](http://middlemanapp.com) static site generator that makes it easy to generate [ClownCar](https://github.com/estelle/clowncar)-style responsive images.

# Install

In an existing Middleman project:
Add `middleman-clowncar` to your `Gemfile`
```
gem "middleman-clowncar"
```

Then open your `config.rb` and add:
```
activate :clowncar
```

# API

The extension adds two helper methods.

## `generate_clowncar`

`generate_clowncar` can be used in your `config.rb` file to create a new `.svg` file in the sitemap which references the various image sizes you have available. You can then reference this `.svg` using a normal `image_tag`. Loading this SVG will be one request, then another will happen to load the correct size according to the `@media` query.

Here is an example:

```
generate_clowncar "logo"
```

This will look for a folder in `images/logo` and inspect the files within. It will create an SVG which loads the smallest possible image given the current image size. It will generate a file named: `images/logo-responsive.svg`

## `clowncar_tag`

`clowncar_tag` is used in your templates to inline an SVG clowncar directly into a page. This approach will make sure only 1 request is ever made, for the correctly sized image only.

Here are some examples:

```
<%= clowncar_tag "logo" %>
```

This will look for a folder in `images/logo` and inspect the files within. It will create an SVG which loads the smallest possible image given the current image size. It will then, base-64 encode that SVG into an `object` tag.

```
<%= clowncar_tag "logo" %>
```

## Remote Assets

Sometimes you don't actually have the resized files locally, but an external service will be handling this for you. In this case, you can pass your sizes and URLs using the `:sizes` parameter. Doing this will override any files you may have in a folder on disk.

```
generate_clowncar "logo", :sizes => { 768 => "//remote.com/size-768", 1024 => "//remote.com/size-2024"}

# or

<%= clowncar_tag "logo", :sizes => { 768 => "//remote.com/size-768", 1024 => "//remote.com/size-2024"} %>
```

## OldIE

Old IE (6-7) doesn't support SVG, if you want to use a fallback image for these browsers, add the `:fallback` parameter to either API method and point it at the fallback image you wish to use, relative to the `logo` folder. This only works for the embedded method. So, if you had `images/logo/fallback.png` you'd use the following method:

```
<%= clowncar_tag "logo", :fallback => "fallback.png" %>
```


# Community

The official community forum is available at:

  http://forum.middlemanapp.com/

# Bug Reports

GitHub Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues and submit new problems:

https://github.com/middleman/middleman-clowncar/issues

The best way to get quick responses to your issues and swift fixes to your bugs is to submit detailed bug reports, include test cases and respond to developer questions in a timely manner. Even better, if you know Ruby, you can submit Pull Requests containing Cucumber Features which describe how your feature should work or exploit the bug you are submitting.

# Donate

[Click here to support Middleman](https://spacebox.io/s/4dXbHBorC3)
