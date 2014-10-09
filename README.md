# Installation

Add the following to whichever tool configuration file you prefer:

```xml
<section id="hutch" name="Hutch Toolbox">
  <tool file="tinsel/tools/tinsel.xml"/>
</section>
```

Copy `display_applications/shiny_applications.txt.example` to Galaxy's `tool-data/shared` directory as `shiny_applications.txt` (and edit if necessary).

Copy (or symlink) `display_applications/magpie.xml` to Galaxy's `display_applications` directory.

Add the following to `datatypes_conf.xml`:

```xml
<datatype extension="rmd" type="galaxy.datatypes.data:Text" mimetype="text/x-r-markdown" subclass="True" display_in_upload="True"/>
<datatype extension="ribbon" type="galaxy.datatypes.data:Text" mimetype="text/x-r-source" subclass="True" display_in_upload="True"/>
<datatype extension="magpie" type="galaxy.datatypes.data:Text" mimetype="application/json" subclass="True" display_in_upload="False">
  <display file="magpie.xml"/>
</datatype>
```

Set `sanitize_all_html = False` in `universe_wsgi.ini` if you want to be able to view the HTML outputs as intended.

Then restart Galaxy!
