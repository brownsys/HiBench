# Hadoop Benchmark Suite (HiBench) #
## HiBench - the Hadoop Benchmark Suite ##
### Forked from version 2.2 by Jonathan Mace on 4/23/2013 ###

Currently working with Hadoop 2.0.4-alpha-rc2 and a stable snapshot of Mahout 0.8

Confirmed working:
pagerank
wordcount
sort
bayes
kmeans

The rest are untested

Steps to set up:
1.  Modify HiBench/bin/hibench-config.sh
2.  Make sure that hadoop is installed into Maven:
   1.  Go to Hadoop root
   2.  $ mvn install
3.  Install Mahout
   1.  Go to HiBench/common/mahout-trunk
   2.  $ mvn -Phadoop-0.23 clean install -DskipTests -Dhadoop.version=2.0.4-alpha
-Dmahout.skip.distribution=false

Further points to note:
*  All jobs are set up to use the 'default' queue.  Changing this is difficult.
