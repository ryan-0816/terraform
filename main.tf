resource "aws_s3_bucket" "static_site" {
    bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
    bucket = aws_s3_bucket.static_site.id

    rule {
        object_ownership = "ObjectWriter"
    }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
    bucket = aws_s3_bucket.static_site.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
    depends_on = [
        aws_s3_bucket_public_access_block.public_access_block,
        aws_s3_bucket_ownership_controls.ownership_controls
    ]
    bucket = aws_s3_bucket.static_site.id
    acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
    bucket = aws_s3_bucket.static_site.id

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}

resource "aws_s3_object" "index_html" {
    depends_on = [
        aws_s3_bucket.static_site,
        aws_s3_bucket_acl.bucket_acl
    ]
    bucket = aws_s3_bucket.static_site.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
    depends_on = [
        aws_s3_bucket.static_site,
        aws_s3_bucket_acl.bucket_acl
    ]
    bucket = aws_s3_bucket.static_site.id
    key = "error.html"
    source = "error.html"
    acl = "public-read"
    content_type = "text/html"
}
