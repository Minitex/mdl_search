module MDL
  class BorealisPdf < BorealisAsset
     def src
      if is_child?
        "https://cdm16022.contentdm.oclc.org/utils/getfile/collection/#{collection}/id/#{id}/filename"
      else
        "https://cdm16022.contentdm.oclc.org/utils/getfile/collection/#{collection}/id/#{parent_id}/filename/#{id}"
      end
    end

    def download
      Download.new(src, 'Download PDF')
    end

    def is_child?
      # Collection "p16022coll64" is special case: it is a compound object
      # made-up of a single multi-page PDF. We are working on ways to detect
      # these sorts of cases. For now, this behavior is hard-coded
      parent_id != id && collection != 'p16022coll64'
    end

    def type
      'pdf'
    end

    def parent_id
      document['id'].split(':').last
    end
  end
end
