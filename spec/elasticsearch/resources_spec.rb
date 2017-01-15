# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
      describe '#locales_paths' do
        subject { super().locales_paths }
        it { is_expected.to have(1).items }
      end
    end
  end
end
