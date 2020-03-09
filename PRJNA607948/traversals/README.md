Create path-with-traversals GFA 1.0 format
---


* Install dsh-bio version 1.3.2 or later, https://github.com/heuermh/dishevelled-bio#installing-dishevelled-bio-via-conda


Create path-with-traversals GFA 1.0 format

```
dsh-bio traverse-paths -i ../swab_ONT.2kbp.gfa |\
  dsh-bio truncate-paths -o swab_ONT.2kbp.withTraversals.gfa

dsh-bio traverse-paths -i ../swab_ONT.2kbp.odgi-prune.b3.gfa |\
  dsh-bio truncate-paths > swab_ONT.2kbp.odgi-prune.b3.withTraversals.gfa
```


Compare file sizes

```
$ du -h *.gfa ../*.gfa | sort --human-numeric-sort
484K	../swab_ONT.2kbp.odgi-prune.b3.gfa
484K	swab_ONT.2kbp.odgi-prune.b3.withTraversals.gfa
1.6M	../swab_ONT.2kbp.gfa
11M	    swab_ONT.2kbp.withTraversals.gfa
```
