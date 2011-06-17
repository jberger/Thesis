===================
AAREADME.TXT 9602.21
===================

If you are reading this file, then it probably means that you want to use
UICTHESI to write your thesis using LaTeX version 2e. To use these files
you must have LaTeX installed including the AMS-LaTeX fonts. Assuming
that is the case then you need only copy all of the files in this directory
to the directory of your choice. I suggest placing them in a directory
called UICTHESI and then updating your LaTeX paths to search this
directory as well. You should refer to your LaTeX implementation's
documentation for more detail on what you may or may not have to do
to use UICTHESI.

This update of UICTHESI was not performed by the UIC Computer Center
and I cannot offer any support other than this readme file and the
updated thesis manual. If you want to do your thesis using LaTeX version
2e then this will get the job done. I'm using it to do my thesis. While it
is still possible to use the old UICTHESI on UICVM, doing it on a PC, Mac or
on the Unix machines ICARUS or TIGGER will offer more flexibility imho.

To use UICTHESI make sure that you have the following files

fontsym.tex
forma.bst
formb.bst
formc.bst
uictest.bib
uictest.tex
uicth11.clo
uicthesi.cls
uictman.bib
uictman.tex

Once you have the files where you want them, give the following
commands (or their equivalents on your system of choice).

To get the UICTHESI Manual

latex uictman.tex
bibtex uictman.bib
latex uictman.tex

Now you have uictman.dvi which you may print according commands
specific to your platform. This may involve converting the dvi file to
postscript using dvips.

To get the short test file

latex uictest.tex
bibtex uictest.tex
latex uictest.tex

Again use whatever commands are specific to your platform to
print the resulting dvi file.

Finally, I'm no TeXpert so I hope that these instructions will be
enough to get you started. My motivation for doing this was the
realization that word processors such as Word and WordPerfect
simply are not up to the task of producing large documents
featuring a lot of formulae and graphics.

Good luck on that thesis!

Tom

Thomas McKibben
mckibben@icarus.uic.edu or tmckibbn@midway.uchicago.edu
http://defiant.rh.uchicago.edu/tom.html