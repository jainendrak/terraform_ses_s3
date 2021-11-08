#Creating S3 Bucket
resource "aws_s3_bucket" "ses-bucket-recieve-mail" {
  bucket = "ses-bucket-recieve-mail"
  acl    = "private"
}
resource "aws_s3_bucket" "ses-bucket-attachments" {
  bucket = "ses-bucket-attachments"
  acl    = "private"
}

#Create policy template for SES
data "aws_iam_policy_document" "SES" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.ses-bucket-recieve-mail.arn}/*"]
  }
}

