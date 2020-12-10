# file to deploy application load balancer with listeners

# create application load balancer

resource "aws_lb" "webAlb" {
    name = var.alb_name
    internal = false
    load_balancer_type = "application"
    security_groups = var.alb_security_group_id
    subnets = [var.pub_sub1_id, var.pub_sub2_id]
}

# create target groups 

resource "aws_lb_target_group" "albTgHttp" {
    name = "HTTP-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
}

#resource "aws_lb_target_group" "albTgHttps" {
#    name = "HTTPS-tg"
#    port = 443
#    protocol = "HTTPS"
#    vpc_id = var.vpc_id
#}

resource "aws_lb_target_group_attachment" "httpAttach1" {
    target_group_arn = aws_lb_target_group.albTgHttp.arn
    target_id = var.web1_id
    port = 80
}

resource "aws_lb_target_group_attachment" "httpAttach2" {
    target_group_arn = aws_lb_target_group.albTgHttp.arn
    target_id = var.web2_id
    port = 80
}

#resource "aws_lb_target_group_attachment" "httpsAttach1" {
#    target_group_arn = aws_lb_target_group.albTgHttps.arn
#    target_id = var.web1_id
#    port = 443
#}

#resource "aws_lb_target_group_attachment" "httpsAttach2" {
#    target_group_arn = aws_lb_target_group.albTgHttps.arn
#    target_id = var.web2_id
#    port = 443
#}

# create listeners

resource "aws_lb_listener" "listenerHttp" {
    load_balancer_arn = aws_lb.webAlb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward" 
        target_group_arn = aws_lb_target_group.albTgHttp.arn
    }
}

#resource "aws_lb_listener" "listenerHttps" {
#    load_balancer_arn = aws_lb.webAlb.arn
#    port = "443"
#    protocol = "HTTPS"
#    ssl_policy = 
#    certificate_arn = 
#
#    default_action {
#        type = "forward" 
#        target_group_arn = aws_lb_target_group.albTgHttps.arn
#    }
#}
