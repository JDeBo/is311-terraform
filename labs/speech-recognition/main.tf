terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-speech-recognition-lab"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user_policy_attachment" "polly" {
  for_each   = var.students
  user       = each.key
  policy_arn = aws_iam_policy.polly.arn
}

resource "aws_iam_user_policy_attachment" "transcribe" {
  for_each   = var.students
  user       = each.key
  policy_arn = aws_iam_policy.transcribe.arn
}

data "aws_iam_policy_document" "transcribe" {
  statement {

    effect = "Allow"
    actions = [
      "transcribe:Get*",
      "transcribe:List*",
      "transcribe:StartTranscriptionJob"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "transcribe" {
  name   = "TranscribeAccessStudent"
  path   = "/"
  policy = data.aws_iam_policy_document.transcribe.json
}

data "aws_iam_policy_document" "polly" {
  statement {

    effect = "Allow"
    actions = [
      "polly:DescribeVoices",
      "polly:GetLexicon",
      "polly:GetSpeechSynthesisTask",
      "polly:ListLexicons",
      "polly:ListSpeechSynthesisTasks",
      "polly:SynthesizeSpeech"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "polly" {
  name   = "PollyAccessStudent"
  path   = "/"
  policy = data.aws_iam_policy_document.polly.json
}
