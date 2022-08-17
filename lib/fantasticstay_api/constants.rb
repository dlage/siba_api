# frozen_string_literal: true

module FantasticstayApi
  # Constants
  module Constants
    # Response headers
    RATELIMIT_REMAINING = 'X-RateLimit-Remaining'

    RATELIMIT_LIMIT = 'X-RateLimit-Limit'

    RATELIMIT_RESET = 'X-RateLimit-Reset'

    CONTENT_TYPE = 'Content-Type'

    CONTENT_LENGTH = 'content-length'

    CACHE_CONTROL = 'cache-control'

    ETAG = 'ETag'

    SERVER = 'Server'

    DATE = 'Date'

    LOCATION = 'Location'

    USER_AGENT = 'User-Agent'

    ACCEPT = 'Accept'

    ACCEPT_CHARSET = 'Accept-Charset'

    OAUTH_SCOPES = 'X-OAuth-Scopes'

    ACCEPTED_OAUTH_SCOPES = 'X-Accepted-Oauth-Scopes'

    # Link headers
    HEADER_LINK = 'Link'

    HEADER_NEXT = 'X-Next'

    HEADER_LAST = 'X-Last'

    META_REL = 'rel'

    META_LAST = 'last'

    META_NEXT = 'next'

    META_FIRST = 'first'

    META_PREV = 'prev'

    PARAM_PAGE = 'page'

    PARAM_PER_PAGE = 'per_page'

    PARAM_START_PAGE = 'start_page'

    PARAM_INCLUDE_RELATED = 'include_related_objects'
  end
end
