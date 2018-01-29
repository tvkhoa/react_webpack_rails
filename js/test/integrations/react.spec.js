import expect, { spyOn } from 'expect';
import React from 'react';
import PropTypes from 'prop-types';
import ReactDOM from 'react-dom';
import { AppContainer } from 'react-hot-loader';
import subject from '../../src/integrations/react';

class HelloComponent extends React.Component {
  static propTypes() {
    return {
      username: PropTypes.string.isRequired,
    };
  }

  render() {
    return (<div>Hello World! {this.props.username}</div>);
  }
}

class FooComponent extends React.Component {
  static propTypes() {
    return {
      username: PropTypes.string.isRequired,
    };
  }

  render() {
    return (<div>Foo! Bar!</div>);
  }
}

describe('ReactIntegration', () => {
  afterEach(() => {
    subject.components = {};
  });

  describe('.constructor', () => {
    it('intializes empty components dictionary', () => {
      expect(subject.components).toEqual({});
    });
  });

  describe('#registerComponent', () => {
    it('registers component using separate args', () => {
      subject.registerComponent('HelloWorld', HelloComponent);
      expect(subject.components.HelloWorld).toBe(HelloComponent);
    });

    it('registers component using Object', () => {
      subject.registerComponent({ HelloComponent });
      expect(subject.components.HelloComponent).toBe(HelloComponent);
    });
  });

  describe('#registerComponents', () => {
    it('adds multiple components', () => {
      subject.registerComponents({ HelloComponent, FooComponent });
      expect(subject.components.HelloComponent).toBe(HelloComponent);
      expect(subject.components.FooComponent).toBe(FooComponent);
    });
  });

  describe('#getComponent', () => {
    it('returns component by name', () => {
      subject.registerComponent('HelloWorld', HelloComponent);
      expect(subject.getComponent('HelloWorld')).toBe(HelloComponent);
    });

    it('returns undefined if component is not found', () => {
      expect(subject.getComponent('HelloWorld')).toBe(undefined);
    });
  });

  describe('#createComponent', () => {
    it('creates component with given props wrapped in AppContainer for hot-reloading', () => {
      subject.registerComponent('HelloWorld', HelloComponent);
      const wrapper = subject.createComponent('HelloWorld', { username: 'testUser' });

      expect(wrapper.type).toBe(AppContainer);

      const component = wrapper.props.children;
      expect(component.props).toEqual({ username: 'testUser' });
      expect(component.type).toBe(HelloComponent);
    });
  });

  describe('#unmountComponent', () => {
    it('unmount component at specified node', () => {
      const node = { nodeType: 1, nodeName: 'DIV' };
      const unmountSpy = spyOn(ReactDOM, 'unmountComponentAtNode');
      subject.unmountComponent(node);

      expect(unmountSpy.calls.length).toEqual(1);
      expect(unmountSpy).toHaveBeenCalledWith({ nodeType: 1, nodeName: 'DIV' });
    });
  });

  describe('#renderComponent', () => {
    it('attaches integration data to node', () => {
      const node = { nodeType: 1, nodeName: 'DIV', dataset: {} };
      const props = { key: 1 };
      const reactSpy = spyOn(ReactDOM, 'render');
      subject.renderComponent('componentName', props, node);
      expect(node.dataset.rwrElement).toEqual('true');
      expect(node.dataset.integrationName).toEqual('react-component');
      expect(node.dataset.payload).toEqual('{"name":"componentName","props":{"key":1}}');
    });
  });

  describe('#integrationWrapper', () => {
    const node = { nodeType: 1, nodeName: 'DIV' };

    describe('function mount', () => {
      it('calls renderComponent', () => {
        const payload = { name: 'componentName', props: { username: 'testUser' } };
        const mountSpy = spyOn(subject, 'renderComponent');
        subject.integrationWrapper.mount(node, payload);

        expect(mountSpy.calls.length).toEqual(1);
        expect(mountSpy).toHaveBeenCalledWith(
          'componentName',
          { username: 'testUser' },
          { nodeType: 1, nodeName: 'DIV' },
        );
      });
    });

    describe('function unmount', () => {
      it('calls unmountComponent', () => {
        const unmountSpy = spyOn(subject, 'unmountComponent');
        subject.integrationWrapper.unmount(node);

        expect(unmountSpy.calls.length).toEqual(1);
        expect(unmountSpy).toHaveBeenCalledWith({ nodeType: 1, nodeName: 'DIV' });
      });
    });
  });
});
