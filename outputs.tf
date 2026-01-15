output "url" {
  value = "http://${aws_eip.vm_ip.public_ip}"
}

output "ip" {
  value = aws_eip.vm_ip.public_ip
}

output "private_key" {
  value     = tls_private_key.rsa.private_key_pem
  sensitive = true
}