import boto3
import zipfile
import os
import logging
import socket
from datetime import datetime, timezone
from pathlib import Path

BUCKET  = "seu-bucket-name"
REGION  = "us-east-1"
SOURCE  = "/var/www/html"
TMP_DIR = "/tmp"

logging.basicConfig(
    filename="/var/log/backup.log",
    level=logging.INFO,
    format="%(asctime)s %(message)s"
)

def main():
    ts       = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
    filename = f"backup_{ts}_{socket.gethostname()}.zip"
    zippath  = f"{TMP_DIR}/{filename}"

    logging.info(f"Iniciando backup -> {filename}")

    with zipfile.ZipFile(zippath, "w", zipfile.ZIP_DEFLATED) as zf:
        for file in Path(SOURCE).rglob("*"):
            if file.is_file():
                zf.write(file, file.relative_to(SOURCE))

    s3 = boto3.client("s3", region_name=REGION)
    s3.upload_file(zippath, BUCKET, f"backups/{filename}")

    os.remove(zippath)
    logging.info(f"Backup concluido: s3://{BUCKET}/backups/{filename}")
    print(f"Backup concluido: s3://{BUCKET}/backups/{filename}")

if __name__ == "__main__":
    main()