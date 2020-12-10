output "webserver1PubIP" {
    value = aws_instance.webserver1.public_ip
}

output "webserver1PrvtIP" {
    value = aws_instance.webserver1.private_ip
}

output "webserver2PubIP" {
    value = aws_instance.webserver2.public_ip
}

output "webserver2PrvtIP" {
    value = aws_instance.webserver2.private_ip
}

output "bastionPubIP" {
    value = aws_instance.bastion.public_ip
}

output "databasePrvtIP" {
    value = aws_instance.database.private_ip
}