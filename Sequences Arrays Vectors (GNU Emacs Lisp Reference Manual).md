<!DOCTYPE html>
<html><!-- Created by GNU Texinfo 7.0.3, https://www.gnu.org/software/texinfo/ --><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>Sequences Arrays Vectors (GNU Emacs Lisp Reference Manual)</title>

<meta name="description" content="Sequences Arrays Vectors (GNU Emacs Lisp Reference Manual)">
<meta name="keywords" content="Sequences Arrays Vectors (GNU Emacs Lisp Reference Manual)">
<meta name="resource-type" content="document">
<meta name="distribution" content="global">
<meta name="Generator" content="makeinfo">
<meta name="viewport" content="width=device-width,initial-scale=1">

<link rev="made" href="mailto:bug-gnu-emacs@gnu.org">
<link rel="icon" type="image/png" href="https://www.gnu.org/graphics/gnu-head-mini.png">
<meta name="ICBM" content="42.256233,-71.006581">
<meta name="DC.title" content="gnu.org">
<style type="text/css">
@import url('/software/emacs/manual.css');
</style>
</head>

<body lang="en">
<div class="chapter-level-extent" id="Sequences-Arrays-Vectors">
<div class="nav-panel">
<p>
Next: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Records.html" accesskey="n" rel="next">Records</a>, Previous: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Lists.html" accesskey="p" rel="prev">Lists</a>, Up: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html" accesskey="u" rel="up">Emacs Lisp</a> &nbsp; [<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html#SEC_Contents" title="Table of contents" rel="contents">Contents</a>][<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Index.html" title="Index" rel="index">Index</a>]</p>
</div>
<hr>
<h2 class="chapter" id="Sequences_002c-Arrays_002c-and-Vectors">6 Sequences, Arrays, and Vectors</h2>
<a class="index-entry-id" id="index-sequence"></a>

<p>The <em class="dfn">sequence</em> type is the union of two other Lisp types: lists
and arrays.  In other words, any list is a sequence, and any array is
a sequence.  The common property that all sequences have is that each
is an ordered collection of elements.
</p>
<p>An <em class="dfn">array</em> is a fixed-length object with a slot for each of its
elements.  All the elements are accessible in constant time.  The four
types of arrays are strings, vectors, char-tables and bool-vectors.
</p>
<p>A list is a sequence of elements, but it is not a single primitive
object; it is made of cons cells, one cell per element.  Finding the
<var class="var">n</var>th element requires looking through <var class="var">n</var> cons cells, so
elements farther from the beginning of the list take longer to access.
But it is possible to add elements to the list, or remove elements.
</p>
<p>The following diagram shows the relationship between these types:
</p>
<div class="example">
<div class="group"><pre class="example-preformatted">          _____________________________________________
         |                                             |
         |          Sequence                           |
         |  ______   ________________________________  |
         | |      | |                                | |
         | | List | |             Array              | |
         | |      | |    ________       ________     | |
         | |______| |   |        |     |        |    | |
         |          |   | Vector |     | String |    | |
         |          |   |________|     |________|    | |
         |          |  ____________   _____________  | |
         |          | |            | |             | | |
         |          | | Char-table | | Bool-vector | | |
         |          | |____________| |_____________| | |
         |          |________________________________| |
         |_____________________________________________|
</pre></div></div>


<ul class="mini-toc">
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Sequence-Functions.html" accesskey="1">Sequences</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Arrays.html" accesskey="2">Arrays</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Array-Functions.html" accesskey="3">Functions that Operate on Arrays</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Vectors.html" accesskey="4">Vectors</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Vector-Functions.html" accesskey="5">Functions for Vectors</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Char_002dTables.html" accesskey="6">Char-Tables</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Bool_002dVectors.html" accesskey="7">Bool-vectors</a></li>
<li><a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Rings.html" accesskey="8">Managing a Fixed-Size Ring of Objects</a></li>
</ul>
</div>





</body></html>