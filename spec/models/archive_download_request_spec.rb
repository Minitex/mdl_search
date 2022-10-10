require 'rails_helper'

describe ArchiveDownloadRequest do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:mdl_identifier) }
  end
end
