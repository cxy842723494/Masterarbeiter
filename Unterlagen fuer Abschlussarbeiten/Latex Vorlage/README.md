# LSKT Thesis Template

This is a template for bachelor's and master's theses at Communication Technology Institute, TU Dortmund University.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### TeX Editor

In general, this template can be used with any suitable TeX editor. Configuration support is available for the following editors, simply choose your favourite:

* Eclipse TeXlipse (https://marketplace.eclipse.org/content/texlipse)
* TeXstudio (https://www.texstudio.org/)
* TeXnicCenter (http://www.texniccenter.org/)
* Texmaker (http://www.xm1math.net/texmaker/)

The configuration primarily covers the makeindex build tools for creating the templates glossaries.
When having decided for an editor, the configuration files for the alternate editors may be deleted for better clarity.

#### Eclipse TeXlipse

##### Builder Temp Files

When using Eclipse TeXlipse, the folder ../tmp/ is used to store the temp files.
These temporary files can be configures in the preferences.

```
Preferences->Texlipse->Builder Settings->Latex Temp Files
```

Since this is quite a list of temporary files, you may consider to add the whole list in your workspace preferences.
To to this, find the TeXlipse preferences file

```
.metadata\.plugins\org.eclipse.core.runtime\.settings\net.sourceforge.texlipse.prefs
```

and replace the corresponding line by

```
tempFileExts=.acn,.acr,.alg,.aux,.auxlock,.bbl,.bcf,.blg,.cb,.cb2,.glsdefs,.glo,.ilg,.ind,.ist,.loc,.lof,.log,.lol,.lot,.nav,.nlo,.nls,.out,.run.xml,.snm,.slg,.slo,.sls,.soc,.tdo,.toc,.vrb,.wrt
```

##### Forward and Backward Search

A tutorial is available in section 3 of the latex document.
The tutorial assumes the use of Sumatra PDF viewer (https://www.sumatrapdfreader.org/).
Other PDF viewers (Adobe Acrobat, Evince, Okular) can be configured accordingly.

In order to use forward search, synctex has to be enabled be adding -synctex=1 parameter to your build command.

##### Spell checking

A tutorial is availabe in section 3 of the latex document. Dictionaries for English and German are available at https://sourceforge.net/projects/texlipse/files/dictionaries/ .

### Builders

For building this template, lualatex and pdflatex are supported.

When you decide to use luatex, only the Accurat true type font files are required.

### Tikz externalize

To enable external building of tikz pictures and pgf plots, the --shell-escape parameter shall be added to your build command.