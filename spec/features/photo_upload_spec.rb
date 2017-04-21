require 'rails_helper'

RSpec.describe 'Photo Upload', type: :feature do

  let(:filename) { 'banff.jpg' }
  let(:filepath) { Rails.root.join("spec/support/#{filename}").to_s }
  let(:user) { FactoryGirl.create :user }

  before do
    login_as(user, :scope => :user, :run_callbacks => false)
    visit '/photos'
  end

  it 'contains an upload button' do
    expect(page).to have_content 'Select files…'
  end

  it 'upload photo' do
    add_input_js = <<-EOJS
      $('body').append('<input id="fake-input-file" name="fake-input-file" type="file" />')
EOJS
    page.execute_script(add_input_js)
    page.attach_file('fake-input-file', filepath)
    add_file_js = <<-EOJS
      window.Emporium.photos.uploader.addFiles($('#fake-input-file')[0], {}, window.Emporium.photos.uploader.getEndpoint())
EOJS
    page.execute_script(add_file_js)

    # wait upload to start
    while (page.find('#upload_item_1').nil? rescue true)
      sleep 0.1
    end

    upload_item_1 = page.find('#upload_item_1')
    progress = upload_item_1.find('.progress')

    # wait upload to finish
    while progress.visible?
      sleep 0.5
    end

    expect(upload_item_1.text).to eq filename
  end

end
