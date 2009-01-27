require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe 'welcome/show should have' do
  before do
    render 'welcome/show'
  end

  it 'h1' do
    response.should have_tag('h1')
  end

  it 'h2' do
    response.should have_tag('h2')
  end
end