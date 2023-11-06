#output "web_instance_ip" {
output "aws_instance_ip" {
  value = aws_instance.web.*.public_ip
}

#output "Web-server-URL" {
#output "gcp_instance_ip" {
#  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
#}

