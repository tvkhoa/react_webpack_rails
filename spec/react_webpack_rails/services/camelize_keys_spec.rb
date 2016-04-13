require 'spec_helper'
require 'react_webpack_rails/services/camelize_keys'
require 'active_support/core_ext/string'

describe ReactWebpackRails::Services::CamelizeKeys do
  describe '.call' do
    context 'when props object is an array' do
      let(:props) { ['some_props', 'props_some'] }

      it { expect(described_class.call(props)).to eq(props) }

      context 'when array contains hash' do
        let(:props) do
          [{ nested_hash: %w(first_value second_value) }, 'some_string']
        end
        let(:camelized_props) do
          [{ 'nestedHash' => %w(first_value second_value) }, 'some_string']
        end

        it 'camelizes nested keys' do
          expect(described_class.call(props).to eq(camelized_props))
        end
      end
    end

    context 'when props object is a hash' do
      let(:props) { { props_name: 'name', props_value: 'value' } }
      let(:camelized_props) { { 'propsName' => 'name', 'propsValue' => 'value' } }

      it { expect(described_class.call(props)).to eq(camelized_props) }
    end

    context 'when props has nested hash' do
      let(:props) { { nested_hash: { props_name: 'name' } } }
      let(:camelized_props) { { 'nestedHash' => { 'propsName' => 'name' } } }

      it { expect(described_class.call(props)).to eq(camelized_props) }
    end
  end
end
