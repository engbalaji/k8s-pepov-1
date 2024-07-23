
variable "k8s_ca_certificate" {
  description = "The base64-encoded Kubernetes cluster CA certificate"
  type        = string
  default = "akJFHASDKJFHKASJDHKAJ"
}

variable "k8s_host" {
  description = "The Kubernetes API server host"
  type        = string
  default = "https://AE9FB6FE6579289ADB73BFD7F2232C3C.gr7.us-east-1.eks.amazonaws.com"
}

variable "k8s_token" {
  description = "The Kubernetes service account token"
  type        = string
  default = "k8s-aws-v1.aHR0cHM6Ly9zdHMuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUE1N0g1RlBJSUlHTllRUjVXJTJGMjAyNDA3MjMlMkZ1cy1lYXN0LTElMkZzdHMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDcyM1QyMTU3NTJaJlgtQW16LUV4cGlyZXM9NjAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JTNCeC1rOHMtYXdzLWlkJlgtQW16LVNpZ25hdHVyZT0wN2NiMDUzZTFlZmI1NTEwOTRkNmE4ZDExNmVlNDU1NTU5MDAzMGNkMTI0OGEwZWQ0YjQ4OTVkMmQ1ZTYzZTU5"