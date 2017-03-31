require 'rails_helper'

RSpec.describe CreateUpload do

  let(:upload) { build(:upload) }
  let(:upload_attributes) { upload.attributes.reject { |k,v| v.nil? }.symbolize_keys }
  let(:presigned_url) { "https://emporium.s3.amazonaws.com/#{upload.object_key}" }
  let(:cloud_storage_object) { class_double('CloudStorage::Object').as_stubbed_const(transfer_nested_constants: true) }

  subject { described_class.new(cloud_storage_object: cloud_storage_object, **upload_attributes) }

  shared_context 'stub cloud storage object' do
    before do
      object_instance = instance_double('CloudStorage::Object')
      allow(cloud_storage_object).to receive(:new).with(upload.object_key).and_return(object_instance)
      allow(object_instance).to receive(:presigned_url).and_return(presigned_url)
    end
  end

  describe '#call' do
    context 'by default' do
      include_context 'stub cloud storage object'

      it 'creates an upload successfully' do
        expect { subject.call }.to broadcast(:success)
      end
    end

    context 'with missing attributes' do
      let(:upload_attributes) { {} }

      it 'broadcasts validation error event' do
        expect { subject.call }.to broadcast(:validation_error)
      end
    end
  end

end
