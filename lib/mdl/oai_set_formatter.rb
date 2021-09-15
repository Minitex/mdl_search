# frozen_string_literal: true
require 'cdmbl/formatters'

###
# This formatter collects three fields into one so that we can
# represent each MDL collection as an OAI-PMH compliant set.
# We configure the blacklight_oai_provider to use the field
# containing this value (oai_set_ssi) as the facet to query,
# and then represent the result using the OaiSet model. See
# CatalogController.
module MDL
  class OaiSetFormatter
    DELIMITER = '||'.freeze

    class << self
      def format(value)
        [
          CDMBL::SetSpecFormatter,
          CDMBL::CollectionNameFormatter,
          CDMBL::CollectionDescriptionFormatter
        ].map { |f| f.format(value) }.join(delimiter)
      end

      def delimiter
        DELIMITER
      end
    end
  end
end
