

#!/bin/bash



# Set the replication factor

REPLICATION_FACTOR=${NEW_REPLICATION_FACTOR}



# Update the Cassandra configuration file

sudo sed -i "s/replication_factor:.*/replication_factor: $REPLICATION_FACTOR/" /etc/cassandra/cassandra.yaml



# Restart Cassandra

sudo systemctl restart cassandra