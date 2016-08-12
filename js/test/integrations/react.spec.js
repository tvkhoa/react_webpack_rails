import expect, { spyOn } from 'expect';
import React, { PropTypes } from 'react';
import ReactDOM from 'react-dom';
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

describe('ReactIntegration', function () {
  afterEach(function () {
    subject.components = {};
  });

  describe('.constructor', function () {
    it('intializes empty components dictionary', function () {
      expect(subject.components).toEqual({});
    });
  });

  describe('#registerComponent', function () {
    it('registers component using separate args', function () {
      subject.registerComponent('HelloWorld', HelloComponent);
      expect(subject.components.HelloWorld).toBe(HelloComponent);
    });

    it('registers component using Object', function () {
      subject.registerComponent({ HelloComponent });
      expect(subject.components.HelloComponent).toBe(HelloComponent);
    });
  });

  describe('#getComponent', function () {
    it('returns component by name', function () {
      subject.registerComponent('HelloWorld', HelloComponent);
      expect(subject.getComponent('HelloWorld')).toBe(HelloComponent);
    });

    it('returns undefined if component is not found', function () {
      expect(subject.getComponent('HelloWorld')).toBe(undefined);
    });
  });

  describe('#createComponent', function () {
    it('creates component with given props', function () {
      subject.registerComponent('HelloWorld', HelloComponent);
      const component = subject.createComponent('HelloWorld', { username: 'testUser' });

      expect(component.props).toEqual({ username: 'testUser' });
      expect(component.type).toBe(HelloComponent);
    });
  });

  describe('#unmountComponent', function () {
    it('unmount component at specified node', function () {
      const node = { nodeType: 1, nodeName: 'DIV' };
      const unmountSpy = spyOn(ReactDOM, 'unmountComponentAtNode');
      subject.unmountComponent(node);

      expect(unmountSpy.calls.length).toEqual(1);
      expect(unmountSpy).toHaveBeenCalledWith({ nodeType: 1, nodeName: 'DIV' });
    });
  });

  describe('#integrationWrapper', function () {
    const node = { nodeType: 1, nodeName: 'DIV' };

    describe('function mount', function () {
      it('calls renderComponent', function () {
        const payload = { name: 'componentName', props: { username: 'testUser' } };
        const mountSpy = spyOn(subject, 'renderComponent');
        subject.integrationWrapper.mount(node, payload);

        expect(mountSpy.calls.length).toEqual(1);
        expect(mountSpy).toHaveBeenCalledWith(
          'componentName',
          { username: 'testUser' },
          { nodeType: 1, nodeName: 'DIV' }
        );
      });
    });

    describe('function unmount', function () {
      it('calls unmountComponent', function () {
        const unmountSpy = spyOn(subject, 'unmountComponent');
        subject.integrationWrapper.unmount(node);

        expect(unmountSpy.calls.length).toEqual(1);
        expect(unmountSpy).toHaveBeenCalledWith({ nodeType: 1, nodeName: 'DIV' });
      });
    });
  });
});
