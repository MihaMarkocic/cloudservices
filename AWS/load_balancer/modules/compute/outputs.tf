output "web1ID" {
    description = "webserver1 ID for lb target group attachment"
    value = aws_instance.webserver1.id
}

output "web2ID" {
    description = "webserver2 ID for lb target group attachment"
    value = aws_instance.webserver2.id
}

output "web3ID" {
    description = "webserver2 ID for lb target group attachment"
    value = aws_instance.webserver3.id
}