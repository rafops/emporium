require 'rails_helper'

RSpec.describe CloudStorageObject do

  let(:upload) { build :upload }
  let(:object_key) { upload.object_key }
  let(:bucket) { 'emporium' }
  subject { described_class.new(object_key) }

  before do
    allow(ENV).to receive(:fetch).with('AWS_BUCKET').and_return(bucket)
    Aws.config[:s3] = { stub_responses: true }
  end

  describe '#presigned_url' do
    it 'generates a presigned url for the object' do
      expect(subject.presigned_url).to start_with "https://#{bucket}.s3.us-stubbed-1.amazonaws.com/#{object_key}"
    end
  end

  describe '#delete' do
    it 'deletes an object' do
      expect(subject.delete).to be_an_instance_of(Seahorse::Client::Response)
    end
  end

end
