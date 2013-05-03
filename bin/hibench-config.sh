#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


this="${BASH_SOURCE-$0}"
bin=$(cd -P -- "$(dirname -- "$this")" && pwd -P)
script="$(basename -- "$this")"
this="$bin/$script"


export HIBENCH_VERSION="2.2"

###################### Global Paths ##################

HADOOP_HOME=$HADOOP_DEV_HOME
HADOOP_EXECUTABLE=$HADOOP_HOME/bin/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
HADOOP_EXAMPLES_JAR=$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.0.4-alpha.jar

if [ -n "$HADOOP_HOME" ]; then
	HADOOP_EXECUTABLE=$HADOOP_HOME/bin/hadoop
	HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
	HADOOP_EXAMPLES_JAR=$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.0.4-alpha.jar
else 					
##make some guess if none of these variables are set
	if [ -z $HADOOP_EXECUTABLE ]; then
		HADOOP_EXECUTABLE=`which hadoop`
	fi
	IFS=':'
	for d in `$HADOOP_EXECUTABLE classpath`; do
		if [ -z $HADOOP_CONF_DIR ] && [[ $d = */conf ]]; then
			HADOOP_CONF_DIR=$d
		fi
		if [ -z $HADOOP_EXAMPLES_JAR ] && [[ $d = *hadoop-examples*.jar ]]; then
			HADOOP_EXAMPLES_JAR=$d
		fi
	done
	unset IFS
fi

echo HADOOP_EXECUTABLE=${HADOOP_EXECUTABLE:? "ERROR: Please set paths in $this before using HiBench."}
echo HADOOP_CONF_DIR=${HADOOP_CONF_DIR:? "ERROR: Please set paths in $this before using HiBench."}
echo HADOOP_EXAMPLES_JAR=${HADOOP_EXAMPLES_JAR:? "ERROR: Please set paths in $this before using HiBench."}

if [ -z "$HIBENCH_HOME" ]; then
    export HIBENCH_HOME=`dirname "$this"`/..
fi

if [ -z "$HIBENCH_CONF" ]; then
    export HIBENCH_CONF=${HIBENCH_HOME}/conf
fi

. "${HIBENCH_CONF}/funcs.sh"


if [ -z "$HIVE_HOME" ]; then
    export HIVE_HOME=${HIBENCH_HOME}/common/hive-0.9.0-bin
fi


if $HADOOP_EXECUTABLE version|grep -i -q cdh4; then
	HADOOP_VERSION=cdh4
else
	HADOOP_VERSION=hadoop1
fi

if [ -z "$MAHOUT_HOME" ]; then
    export MAHOUT_HOME=${HIBENCH_HOME}/common/mahout-trunk
    echo MAHOUT_HOME=$MAHOUT_HOME
fi

if [ -z "$NUTCH_HOME" ]; then
    export NUTCH_HOME=${HIBENCH_HOME}/nutchindexing/nutch-1.2-$HADOOP_VERSION
fi

if [ -z "$DATATOOLS" ]; then
    export DATATOOLS=${HIBENCH_HOME}/common/autogen/dist/datatools.jar
fi

if [ $# -gt 1 ]
then
    if [ "--hadoop_config" = "$1" ]
          then
              shift
              confdir=$1
              shift
              HADOOP_CONF_DIR=$confdir
    fi
fi
HADOOP_CONF_DIR="${HADOOP_CONF_DIR:-$HADOOP_HOME/conf}"

# base dir HDFS
export DATA_HDFS=/user/jon

# local report
export HIBENCH_REPORT=${HIBENCH_HOME}/hibench.report

################# Compress Options #################
# swith on/off compression: 0-off, 1-on
export COMPRESS_GLOBAL=0
export COMPRESS_CODEC_GLOBAL=org.apache.hadoop.io.compress.DefaultCodec
#export COMPRESS_CODEC_GLOBAL=com.hadoop.compression.lzo.LzoCodec
#export COMPRESS_CODEC_GLOBAL=org.apache.hadoop.io.compress.SnappyCodec
