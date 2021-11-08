esource "aws_ses_receipt_rule_set" "main" {
  provider = "aws.ses"
  rule_set_name = "s3"
}

resource "aws_ses_receipt_rule" "main" {
  provider = "aws.ses"
  name          = "s3"
  rule_set_name = "${aws_ses_receipt_rule_set.main.rule_set_name}"
  enabled       = true
  scan_enabled  = true
  s3_action {
    bucket_name = "${data.aws_s3_bucket.mailbox.id}"
    object_key_prefix = "mailbox/${var.receiver_address}"
    position = 1
  }
}

# Activate rule set
resource "aws_ses_active_receipt_rule_set" "main" {
  provider = "aws.ses"
  rule_set_name = aws_ses_active_receipt_rule_set.main.rule_set_name
}
