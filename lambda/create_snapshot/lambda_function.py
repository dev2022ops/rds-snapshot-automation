import boto3
import os
from datetime import datetime, timezone

rds = boto3.client("rds")
DB_INSTANCE_ID = os.environ["DB_INSTANCE_ID"]

def lambda_handler(event, context):
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    snapshot_id = f"{DB_INSTANCE_ID}-{timestamp}"

    response = rds.create_db_snapshot(
        DBInstanceIdentifier=DB_INSTANCE_ID,
        DBSnapshotIdentifier=snapshot_id
    )

    return {
        "snapshot_id": snapshot_id,
        "status": response["DBSnapshot"]["Status"]
    }
