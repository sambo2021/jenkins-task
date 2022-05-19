output "network_vpc_id"{
    value = aws_vpc.iti_vpc.id
}
output "network_public_subnet_1_id"{
    value = aws_subnet.public-subnet-1.id
}
output "network_public_subnet_2_id"{
    value = aws_subnet.public-subnet-2.id
}
output "network_private_subnet_1_id"{
    value = aws_subnet.private-subnet-1.id
}
output "network_private_subnet_2_id"{
    value = aws_subnet.private-subnet-2.id
}
output "network_public_security_group_id"{
    value = aws_security_group.publicsecuritygroup.id
}
output "network_private_security_group_id"{
    value = aws_security_group.securitygroup.id
}
