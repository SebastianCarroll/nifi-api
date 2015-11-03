require 'spec_helper'

describe Nifipi do
  it 'has a version number' do
    expect(Nifipi::VERSION).not_to be nil
  end

  it 'compiles' do
    nifi = Nifipi::Nifi
  end
end
