output "webserverPubIP" {
    value = aws_instance.webserver.public_ip
}

output "jumpHostPubIP" {
    value = aws_instance.jumpHost.public_ip
}

output "privateVMprvtIP" {
    value = aws_instance.privateVM.private_ip
}