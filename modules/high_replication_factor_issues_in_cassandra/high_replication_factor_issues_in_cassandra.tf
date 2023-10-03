resource "shoreline_notebook" "high_replication_factor_issues_in_cassandra" {
  name       = "high_replication_factor_issues_in_cassandra"
  data       = file("${path.module}/data/high_replication_factor_issues_in_cassandra.json")
  depends_on = [shoreline_action.invoke_describe_keyspace_table,shoreline_action.invoke_update_cassandra_replication]
}

resource "shoreline_file" "describe_keyspace_table" {
  name             = "describe_keyspace_table"
  input_file       = "${path.module}/data/describe_keyspace_table.sh"
  md5              = filemd5("${path.module}/data/describe_keyspace_table.sh")
  description      = "Check the replication factor for a given keyspace and table"
  destination_path = "/agent/scripts/describe_keyspace_table.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_cassandra_replication" {
  name             = "update_cassandra_replication"
  input_file       = "${path.module}/data/update_cassandra_replication.sh"
  md5              = filemd5("${path.module}/data/update_cassandra_replication.sh")
  description      = "Reduce the replication factor: One possible remediation for this incident is to reduce the replication factor. This can be done by adjusting the configuration settings in Cassandra to store fewer copies of data. However, this may impact data availability and durability, so it's important to carefully consider the trade-offs before making changes."
  destination_path = "/agent/scripts/update_cassandra_replication.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_describe_keyspace_table" {
  name        = "invoke_describe_keyspace_table"
  description = "Check the replication factor for a given keyspace and table"
  command     = "`chmod +x /agent/scripts/describe_keyspace_table.sh && /agent/scripts/describe_keyspace_table.sh`"
  params      = ["TABLE_NAME","KEYSPACE_NAME"]
  file_deps   = ["describe_keyspace_table"]
  enabled     = true
  depends_on  = [shoreline_file.describe_keyspace_table]
}

resource "shoreline_action" "invoke_update_cassandra_replication" {
  name        = "invoke_update_cassandra_replication"
  description = "Reduce the replication factor: One possible remediation for this incident is to reduce the replication factor. This can be done by adjusting the configuration settings in Cassandra to store fewer copies of data. However, this may impact data availability and durability, so it's important to carefully consider the trade-offs before making changes."
  command     = "`chmod +x /agent/scripts/update_cassandra_replication.sh && /agent/scripts/update_cassandra_replication.sh`"
  params      = ["NEW_REPLICATION_FACTOR"]
  file_deps   = ["update_cassandra_replication"]
  enabled     = true
  depends_on  = [shoreline_file.update_cassandra_replication]
}

