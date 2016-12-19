require 'spec_helper'
describe 'sftpd' do

  context 'with defaults for all parameters' do
    it { should contain_class('sftpd') }
  end
end
