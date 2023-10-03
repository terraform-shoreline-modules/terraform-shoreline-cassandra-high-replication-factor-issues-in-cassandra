
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Replication Factor Issues in Cassandra
---

This incident type refers to issues that occur in Cassandra due to a high replication factor. Replication factor is a setting that determines how many copies of data are stored in a cluster. A high replication factor means that more copies of data are stored in the cluster, which can cause performance issues and potentially lead to data inconsistencies. When this incident occurs, it may affect the availability and stability of the Cassandra cluster, impacting the ability to read and write data.

### Parameters
```shell
export NODE_IP="PLACEHOLDER"

export KEYSPACE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export PARTITION_KEY_VALUE="PLACEHOLDER"

export NEW_REPLICATION_FACTOR="PLACEHOLDER"
```

## Debug

### Connect to a Cassandra node in the cluster
```shell
cqlsh ${NODE_IP}
```

### Check the replication factor for a given keyspace and table
```shell
DESCRIBE KEYSPACE ${KEYSPACE_NAME};

DESCRIBE TABLE ${TABLE_NAME};
```

### Check the number of replicas for a given keyspace and table
```shell
SELECT * FROM system_schema.columns WHERE keyspace_name='${KEYSPACE_NAME}' AND table_name='${TABLE_NAME}';
```

### Check the status of the nodes in the cluster
```shell
nodetool status
```

### Check the replication factor for a given keyspace and table on all nodes in the cluster
```shell
nodetool getendpoints ${KEYSPACE_NAME} ${TABLE_NAME} ${PARTITION_KEY_VALUE}
```

### Check the status of the nodes in the cluster to identify any nodes that are down or experiencing issues
```shell
nodetool status
```

### Check the replication factor for a given keyspace and table on all nodes in the cluster to identify any inconsistencies
```shell
nodetool consistency ${KEYSPACE_NAME}.${TABLE_NAME}
```

### Check the system logs for any errors or warnings related to replication factor
```shell
tail -f /var/log/cassandra/system.log | grep "replication factor"
```

### Check the read/write latency for the cluster
```shell
nodetool tpstats
```

## Repair

### Reduce the replication factor: One possible remediation for this incident is to reduce the replication factor. This can be done by adjusting the configuration settings in Cassandra to store fewer copies of data. However, this may impact data availability and durability, so it's important to carefully consider the trade-offs before making changes.
```shell


#!/bin/bash



# Set the replication factor

REPLICATION_FACTOR=${NEW_REPLICATION_FACTOR}



# Update the Cassandra configuration file

sudo sed -i "s/replication_factor:.*/replication_factor: $REPLICATION_FACTOR/" /etc/cassandra/cassandra.yaml



# Restart Cassandra

sudo systemctl restart cassandra


```