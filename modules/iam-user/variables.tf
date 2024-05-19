variable "create_access_key" {
  default = false
}
variable "attach_s3_rw" {
  default = false
}
variable "buckets_for_rw" {
  default = []
}
variable "name" {

}
variable "force_destroy" {
  default = true
}
