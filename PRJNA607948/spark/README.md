Convert GFA 1.0 to Apache Parquet format
---


* Install Apache Spark version 2.4.5, built for Scala 2.11, http://spark.apache.org
* Install `adam-gfa`, https://github.com/heuermh/adam-gfa


Transform GFA 1.0 to generic `Gfa1Record` records in Parquet format

```
spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframe \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../swab_ONT.2kbp.gfa \
  swab_ONT.2kbp.parquet

spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframe \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../swab_ONT.2kbp.odgi-prune.b3.gfa \
  swab_ONT.2kbp.odgi-prune.b3.parquet
```


Transform path-with-traversals GFA 1.0 to generic `Gfa1Record` records in Parquet format

```
spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframe \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../traversals/swab_ONT.2kbp.withTraversals.gfa \
  swab_ONT.2kbp.withTraversals.parquet

spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframe \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../traversals/swab_ONT.2kbp.odgi-prune.b3.withTraversals.gfa \
  swab_ONT.2kbp.odgi-prune.b3.withTraversals.parquet
```


Transform GFA 1.0 to specific `Link`, `Path`, `Segment`, and `Traversal` records in Parquet format

```
spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframes \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../swab_ONT.2kbp.gfa \
  swab_ONT.2kbp.parquet

spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframes \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../swab_ONT.2kbp.odgi-prune.b3.gfa \
  swab_ONT.2kbp.odgi-prune.b3.parquet
```


Transform path-with-traversals GFA 1.0 to specific `Link`, `Path`, `Segment`, and `Traversal` records in Parquet format

```
spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframes \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../traversals/swab_ONT.2kbp.withTraversals.gfa \
  swab_ONT.2kbp.withTraversals

spark-submit \
  --conf spark.sql.parquet.compression.codec=gzip \
  --class com.github.heuermh.adam.gfa.Gfa1ToDataframes \
  adam-gfa_2.11-0.4.0-SNAPSHOT.jar \
  ../traversals/swab_ONT.2kbp.odgi-prune.b3.withTraversals.gfa \
  swab_ONT.2kbp.odgi-prune.b3.withTraversals
```


Compare file sizes

```
$ du -h *.parquet

388K	swab_ONT.2kbp.parquet

212K	swab_ONT.2kbp.odgi-prune.b3.parquet

124K	swab_ONT.2kbp.links.parquet
184K	swab_ONT.2kbp.paths.parquet
108K	swab_ONT.2kbp.segments.parquet
16K	    swab_ONT.2kbp.traversals.parquet

92K	    swab_ONT.2kbp.odgi-prune.b3.links.parquet
16K	    swab_ONT.2kbp.odgi-prune.b3.paths.parquet
116K	swab_ONT.2kbp.odgi-prune.b3.segments.parquet
16K	    swab_ONT.2kbp.odgi-prune.b3.traversals.parquet

572K	swab_ONT.2kbp.withTraversals.parquet

212K	swab_ONT.2kbp.odgi-prune.b3.withTraversals.parquet

124K	swab_ONT.2kbp.withTraversals.links.parquet
32K	    swab_ONT.2kbp.withTraversals.paths.parquet
108K	swab_ONT.2kbp.withTraversals.segments.parquet
412K	swab_ONT.2kbp.withTraversals.traversals.parquet

92K	    swab_ONT.2kbp.odgi-prune.b3.withTraversals.links.parquet
16K	    swab_ONT.2kbp.odgi-prune.b3.withTraversals.paths.parquet
116K	swab_ONT.2kbp.odgi-prune.b3.withTraversals.segments.parquet
16K	    swab_ONT.2kbp.odgi-prune.b3.withTraversals.traversals.parquet
```


Interactive spark-shell session with generic `Gfa1Record` records in Parquet format

```
spark-shell \
  --conf spark.sql.parquet.compression.codec=gzip \
  --jars adam-gfa_2.11-0.4.0-SNAPSHOT.jar

scala> import spark.implicits._
import spark.implicits._

scala> import com.github.heuermh.adam.gfa.sql.gfa1.Gfa1Record
import com.github.heuermh.adam.gfa.sql.gfa1.Gfa1Record

scala> val records = spark.read.parquet("swab_ONT.2kbp.parquet").as[Gfa1Record]
records: org.apache.spark.sql.Dataset[com.github.heuermh.adam.gfa.sql.gfa1.Gfa1Record] = [recordType: string, id: string ... 17 more fields]

scala> records.show
+----------+---+--------+------+---------+-------------+---------+----------------+-----------+------+------+-------+--------------+-------------+--------+--------+--------+-------+----+
|recordType| id|sequence|length|readCount|fragmentCount|kmerCount|sequenceChecksum|sequenceUri|source|target|overlap|mappingQuality|mismatchCount|pathName|segments|overlaps|ordinal|tags|
+----------+---+--------+------+---------+-------------+---------+----------------+-----------+------+------+-------+--------------+-------------+--------+--------+--------+-------+----+
|         S|  1|       G|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  2|       C|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  3|       A|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  4|       A|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  5|       T|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  6|     CTT|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  7|       C|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  8|       A|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S|  9|       T|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 10|       C|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 11|       A|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 12|       G|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 13|      AT|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 14|       T|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 15|       C|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 16|       T|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 17|       G|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 18|       C|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 19|       A|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
|         S| 20|      CT|  null|     null|         null|     null|            null|       null|  null|  null|   null|          null|         null|    null|    null|    null|   null|  []|
+----------+---+--------+------+---------+-------------+---------+----------------+-----------+------+------+-------+--------------+-------------+--------+--------+--------+-------+----+
only showing top 20 rows
```

Interactive spark-shell session with specific `Link`, `Path`, `Segment`, and `Traversal` records in Parquet format

```
spark-shell \
  --conf spark.sql.parquet.compression.codec=gzip \
  --jars adam-gfa_2.11-0.4.0-SNAPSHOT.jar

scala> import spark.implicits._
import spark.implicits._

scala> import com.github.heuermh.adam.gfa.sql.gfa1.{Link, Segment}
import com.github.heuermh.adam.gfa.sql.gfa1.{Link, Segment}

scala> val segments = spark.read.parquet("swab_ONT.2kbp.segments.parquet").as[Segment]
segments: org.apache.spark.sql.Dataset[com.github.heuermh.adam.gfa.sql.gfa1.Segment] = [id: string, sequence: string ... 7 more fields]

scala> val links = spark.read.parquet("swab_ONT.2kbp.links.parquet").as[Link]
links: org.apache.spark.sql.Dataset[com.github.heuermh.adam.gfa.sql.gfa1.Link] = [id: string, source: struct<id: string, orientation: string> ... 8 more fields]

scala> segments.createOrReplaceTempView("segments")

scala> links.createOrReplaceTempView("links")

scala> sql("select s1.sequence as source, s2.sequence as target from segments s1, segments s2, links where s1.id == links.source.id and links.target.id == s2.id").show
+------+----------------+
|source|          target|
+------+----------------+
|     G|               C|
|     G|               T|
|     G|               G|
|     C|               A|
|     C|               G|
|     A|               A|
|     A|               G|
|     A|               C|
|     A|        ATAAATTA|
|     A|               T|
|     A|         ATCTTCG|
|     A|               A|
|     T|             CTT|
|     T|               A|
|   CTT|               C|
|   CTT|               T|
|     C|               A|
|     C|TCATTAGATTCTGCCG|
|     C|             CTT|
|     C|         GCGCCAT|
+------+----------------+
only showing top 20 rows
```
