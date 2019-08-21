output "address" {
    value       = aws_db_instance.fm_db.address
    description = "DB endpoint"
}


output "port" {
    value       = aws_db_instance.fm_db.port
    description = "DB port number" 
}
