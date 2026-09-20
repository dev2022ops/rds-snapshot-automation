import boto3

rds = boto3.client("rds")

def lambda_handler(event, context):
    snapshot_id = event["snapshot_id"]

    response = rds.describe_db_snapshots(
        DBSnapshotIdentifier=snapshot_id
    )

    return {
        "snapshot_id": snapshot_id,
        "status": response["DBSnapshots"][0]["Status"]
    }
