# create S3 bucket storage for flow logs

resource "aws_s3_bucket" "flow_logs_bucket" {
    bucket = "flow.log.bucket"
    policy = file("./modules/storage/flowlogs-policy.json")
    force_destroy = true

    tags = {
        Name = "FlowLogs Storage"
    }
}

output "s3arn" {
    description = "arn of created bucket for flow logs storage"
    value = aws_s3_bucket.flow_logs_bucket.arn
}