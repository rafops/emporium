require 'rails_helper'

RSpec.describe CreatePhoto do

  let(:photo) { build(:photo) }
  let(:photo_attributes) { photo.attributes.reject { |k,v| v.nil? }.symbolize_keys }
  let(:url) { "https://emporium.s3.amazonaws.com/#{photo.object_key}" }
  let(:cloud_storage_object) { class_double('CloudStorage::Object').as_stubbed_const(transfer_nested_constants: true) }

  subject { described_class.new(cloud_storage_object: cloud_storage_object, **photo_attributes) }

  shared_context 'stub cloud storage object' do
    before do
      object_instance = instance_double('CloudStorage::Object')
      allow(cloud_storage_object).to receive(:new).with(photo.object_key).and_return(object_instance)
      allow(object_instance).to receive(:url).and_return(url)
    end
  end

  describe '#call' do
    context 'by default' do
      include_context 'stub cloud storage object'

      it 'creates a photo successfully' do
        expect { subject.call }.to broadcast(:success)
      end
    end

    context 'with missing attributes' do
      let(:photo_attributes) { {} }

      it 'broadcasts validation error event' do
        expect { subject.call }.to broadcast(:validation_error)
      end
    end
  end

end
