require 'rails_helper'

RSpec.describe ReactWebpackRails::ViewHelpers, type: :helper do
  describe '#react_element' do
    subject { helper.react_element('react-component') }

    it { expect(helper).to respond_to(:react_component) }

    it 'renders html tag' do
      expect(subject).to be_an_instance_of(ActiveSupport::SafeBuffer)
      expect(subject).to eq(
        "<div data-integration-name=\"react-component\" "\
        "data-payload=\"{}\" data-react-element=\"true\"></div>"
      )
    end

    context 'when payload is a String' do
      subject { helper.react_element('elementName', 'not even a json') }

      it 'does not cast to JSON' do
        expect(subject).to include("data-payload=\"not even a json\"")
      end
    end

    context 'when payload is a hash' do
      subject { helper.react_element('react-component', foo: :bar) }
      it 'is does cast to JSON' do
        expect(subject).to include("data-payload=\"{&quot;foo&quot;:&quot;bar&quot;}\"")
      end
    end

    context 'when options without tag given' do
      subject { helper.react_element('react-component', {foo: :bar}) }
      it 'is renders div' do
        expect(subject).to include('<div ', '></div>')
      end

      it 'pass given options' do
        expect(subject).to include("data-payload=\"{&quot;foo&quot;:&quot;bar&quot;}\"")
      end
    end

    context 'when options with tag given' do
      subject { helper.react_element('react-component', {foo: :bar}, {tag: :li}) }
      it 'is renders passed tag' do
        expect(subject).to include('<li ', '></li>')
      end

      it 'pass given options without tag' do
        expect(subject).to include("data-payload=\"{&quot;foo&quot;:&quot;bar&quot;}\"")
      end
    end
  end

  describe '#react_component' do
    it { expect(helper).to respond_to(:react_component) }

    it 'wraps #react_element with proper options' do
      expect(helper)
        .to receive(:react_element)
        .with('react-component', { props: { 'foo' => 'bar' }, name: 'Todo' }, {})
        .once
      helper.react_component('Todo', foo: 'bar')
    end

    context 'when props are not passed' do
      subject { helper.react_component('Todo') }

      it 'sets an empty object as default' do
        expect(helper).to receive(:react_element).with(
          'react-component', { props: {}, name: 'Todo' }, {}
        ).once
        helper.react_component('Todo')
      end
    end

    context 'with server_side: true' do
      let(:node_integration_runner) { double('node_integration_runner') }
      let(:result) { double('result') }
      let(:ssred_component) do
        File.read(Rails.root.join('spec/fixtures/ssred_component.html'))
      end

      before do
        allow_any_instance_of(ReactWebpackRails::NodeIntegrationRunner)
          .to receive(:run) { ssred_component }
      end

      it 'initializes NodeIntegrationRunner with proper args' do
        allow(ReactWebpackRails::NodeIntegrationRunner)
          .to receive(:new) { node_integration_runner }
        allow(node_integration_runner).to receive(:run) { result }
        allow(result).to receive(:html_safe)
        expect(ReactWebpackRails::NodeIntegrationRunner).to receive(:new)
          .with('react-component', props: { 'foo' => 'bar' }, name: 'Todo')

        helper.react_component('Todo', { foo: 'bar' }, server_side: true)
      end

      it 'calls NodeIntegrationRunner instance' do
        expect_any_instance_of(ReactWebpackRails::NodeIntegrationRunner)
          .to receive(:run)
        helper.react_component('Todo', { foo: 'bar' }, server_side: true)
      end
    end

    context 'when camelize_props enabled' do
      before do
        allow(Rails.application.config.react)
          .to receive(:camelize_props)
          .and_return(true)
      end

      context 'and AMS object is in props' do
        let(:ams_props) { TestSerializer.new({}, root: false) }
        it 'camelize props' do
          expect(helper).to receive(:react_element).with(
            'react-component', { props: { 'testName' => 'name test' }, name: 'Todo' }, {}
          ).once
          helper.react_component('Todo', ams_props)
        end
      end
    end
  end

  describe '#react_router' do
    it { expect(helper).to respond_to(:react_router) }

    it 'wraps #react_component with proper options' do
      expect(helper).to receive(:react_element).with('react-router', name: 'TodoRouter').once
      helper.react_router('TodoRouter')
    end
  end
end
