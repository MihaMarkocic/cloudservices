# create S3 bucket storage for flow logs

resource "aws_s3_bucket" "flow_logs_bucket" {
    bucket = "flow.log.bucket"

    tags = {
        Name = "FlowLogs Storage"
    }
}

output "s3arn" {
    description = "arn of created bucket for flow logs storage"
    value = aws_s3_bucket.flow_logs_bucket.arn
}