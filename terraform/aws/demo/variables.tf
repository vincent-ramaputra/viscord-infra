variable "region" {
  description = "Same region as the app bucket, so S3 traffic stays in-region."
  type        = string
  default     = "ap-southeast-3"
}

variable "availability_zone" {
  type    = string
  default = "ap-southeast-3a"
}

variable "instance_type" {
  description = "4 GB is enough for the whole compose stack (plus swap). Must be x86: the images are amd64-only, so no t4g."
  type        = string
  default     = "t3.medium"
}

variable "use_spot" {
  description = <<-EOT
    Run as a persistent spot instance that is stopped (not terminated) on interruption: the disk and
    Elastic IP survive and AWS restarts it when capacity returns, at the cost of unpredictable downtime.
    Changing this replaces the instance, which wipes the root disk (and the database) - back up first.
  EOT
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "GiB. Holds the OS, every image and all Docker volumes (Postgres, RabbitMQ, TLS certs)."
  type        = number
  default     = 20
}

variable "zone_name" {
  description = "Existing Route53 hosted zone."
  type        = string
  default     = "viscord.app"
}

variable "subdomain" {
  description = "The app is served at <subdomain>.<zone_name> and voice at sfu.<subdomain>.<zone_name>."
  type        = string
  default     = "demo"
}

variable "app_bucket_name" {
  type    = string
  default = "viscord-dev-409684965426-ap-southeast-3-an"
}

variable "rtc_port_range" {
  description = "WebRTC UDP range; must match RTC_MIN_PORT/RTC_MAX_PORT and the ports mapping in compose."
  type        = object({ from = number, to = number })
  default     = { from = 40000, to = 40099 }
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair (in var.region) installed for the ubuntu user. Null = SSM only. Changing it replaces the instance."
  type        = string
  default     = "demo-vm"
}

variable "ssh_allowed_cidr" {
  description = "Your IP as a /32, e.g. \"203.0.113.7/32\", to open port 22. Null = port 22 stays closed. Never 0.0.0.0/0."
  type        = string
  default     = "182.253.138.151/32"

  validation {
    condition     = var.ssh_allowed_cidr != "0.0.0.0/0"
    error_message = "Don't open SSH to the whole internet; use your own IP as a /32 or use SSM."
  }
}
