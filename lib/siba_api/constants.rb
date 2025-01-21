# frozen_string_literal: true

module SIBAApi
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

    # Default API config constants
    API_WSDL = 'https://siba.ssi.gov.pt/bawsdev/boletinsalojamento.asmx?wsdl'

    API_HOTEL_UNIT = '121212121'

    API_HOTEL_UNIT_INFO = {
      'Codigo_Unidade_Hoteleira' => '121212121',
      'Estabelecimento' => '00',
      'Nome' => 'Hotel teste',
      'Abreviatura' => 'teste',
      'Morada' => 'Rua da Alegria, 172',
      'Localidade' => 'Portalegre',
      'Codigo_Postal' => '1000',
      'Zona_Postal' => '234',
      'Telefone' => '214017744',
      'Fax' => '214017766',
      'Nome_Contacto' => 'Nuno teste',
      'Email_Contacto' => 'teste.teste@sef.pt'
    }.freeze

    API_ACCESS_KEY = '999999999'

    API_ESTABLISHMENT = '00'
  end
end
