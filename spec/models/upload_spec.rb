require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject { build :upload }

  describe '#valid?' do
    context 'by default' do
      it 'is valid' do
        expect(subject.valid?).to be true
      end
    end

    context 'as a new object' do
      subject { described_class.new }

      it 'is invalid' do
        expect(subject.valid?).to be false
      end
    end

    context 'with empty object_key' do
      before { subject.object_key = nil }

      it 'is invalid' do
        expect(subject.valid?).to be false
      end
    end

    context 'with empty uuid' do
      before { subject.uuid = nil }

      it 'is invalid' do
        expect(subject.valid?).to be false
      end
    end

    context 'with empty name' do
      before { subject.name = nil }

      it 'is valid' do
        expect(subject.valid?).to be true
      end
    end
  end

end
