variable "instance_type"{
    default = ["t2.micro","t2.medium","t2.large"]
}
variable "ami" {
   default = {
      "image": "ami-053b0d53c279acc90"
   }
}