
<!--#echo json="package.json" key="name" underline="=" -->
aspell-util-pmb
===============
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
My aspell helper scripts.
<!--/#echo -->


aspell-guess-lang
-----------------

Given a list of languages, guess which of them the file is written in.
Use `-` (a single dash) to read from stdin.

Output columns:
1. number of valid words
1. total number of words
1. percentage of valid words
1. language

The output is reverse-sorted by all columns,
so a language that knows more of the words used ranks higher,
but in case of a tie, the one with more total words wins.
(No idea whether that's even language dependent at the moment.)


```bash
$ ./aspell-guess-lang.sh de,en - <<<'
    These requirements apply to the modified work as a whole.'
10      10      100.000%        en
2       10       20.000%        de
$ ./aspell-guess-lang.sh de,en - <<<'
    Diese Anforderungen gelten für das bearbeitete Werk als Ganzes.'
9       9       100.000%        de
0       9         0.000%        en
```


<!--#toc stop="scan" -->



Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
