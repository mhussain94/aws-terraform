provider "aws" {
  region   = "eu-west-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile = "default"
}
#resource "typeofresource" "namethatyouwanttogive"
resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-hussain-test-tf-first-bucket"
  acl    = "private"

  tags = {
    Environment = "test"
  }
}

#Uploading test file to a bucket
#Terraform can automatically detect change in the file because of the etag
resource "aws_s3_bucket_object" "my-object" {
  bucket = "${aws_s3_bucket.my-bucket.id}" #using string variable to call here. See how aws_s3_bucket.my_bucket, the name of the bucket resource is called here
  key    = "hellworld.tf"
  source = "../helloworld/helloworld.tf" #pat to the file

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../helloworld/helloworld.tf")
}