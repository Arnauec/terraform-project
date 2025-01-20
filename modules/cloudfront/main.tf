# Creates an AWS CloudFront distribution for delivering static content globally.
# This resource configures the origin, caching behavior, viewer settings, and security.
resource "aws_cloudfront_distribution" "distribution" {

  # The origin block defines the source of content for CloudFront.
  # In this case, the origin is an S3 bucket whose domain name is passed as a variable.
  origin {
    domain_name = var.bucket_domain_name # The domain name of the S3 bucket
    origin_id   = var.origin_id          # A unique identifier for this origin (e.g., "auth-dev-origin").
  }

  # The default_cache_behavior block configures how CloudFront handles caching and serves content to users.
  default_cache_behavior {
    target_origin_id       = var.origin_id          # Refers to the origin ID defined above, linking this cache behavior to the origin.
    viewer_protocol_policy = "redirect-to-https"    # Redirects all HTTP traffic to HTTPS for secure communication.

    # Specifies the HTTP methods allowed for viewers (end users).
    allowed_methods = ["GET", "HEAD"]               # Only allows read operations, which are sufficient for serving static files.

    # Specifies the HTTP methods cached by CloudFront.
    cached_methods = ["GET", "HEAD"]                # Ensures only GET and HEAD requests are cached for efficiency.

    # Configures what CloudFront forwards to the origin (e.g., cookies, query strings).
    forwarded_values {
      query_string = false                          # Query strings are not forwarded to the origin, improving cache efficiency.

      # Configures how cookies are handled.
      cookies {
        forward = "none"                            # Cookies are not forwarded, as they are unnecessary for serving static content.
      }
    }

    # Time-to-live (TTL) settings for caching content in CloudFront.
    default_ttl = 3600                              # Default cache duration: 1 hour.
    max_ttl     = 86400                             # Maximum cache duration: 1 day.
    min_ttl     = 0                                 # Minimum cache duration: 0 seconds (content can be updated immediately if needed).
  }

  # Enables the CloudFront distribution, allowing it to serve requests.
  enabled = true

  # The viewer_certificate block configures SSL/TLS settings for secure content delivery.
  viewer_certificate {
    cloudfront_default_certificate = true          # Use the default CloudFront SSL certificate for HTTPS.
  }

  # The restrictions block defines geographic access controls for the distribution.
  restrictions {
    geo_restriction {
      restriction_type = "none"                    # No geographic restrictions are applied (all locations can access the content).
    }
  }

  # Adds metadata tags to the CloudFront distribution for better organization and cost tracking.
  tags = {
    Environment = var.environment                  # Indicates the environment (e.g., dev, staging, prod).
    Name        = "${var.environment}-${var.path}-cloudfront" # A descriptive name for the distribution (e.g., "dev-auth-cloudfront").
  }
}
