import expect, { spyOn, createSpy } from 'expect';
import React from 'react';
import ReactDOMClient from 'react-dom/client';
import subject from '../../src/integrations/react';

function HelloComponent(props) {
  return React.createElement('div', null, 'Hello World! ', props.username);
}

function FooComponent() {
  return React.createElement('div', null, 'Foo! Bar!');
}

describe('ReactIntegration', () => {
  afterEach(() => {
    subject.components = {};
    subject.roots = new Map();
    expect.restoreSpies();
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
    it('creates component element with given props', () => {
      subject.registerComponent('HelloWorld', HelloComponent);
      const element = subject.createComponent('HelloWorld', {
        username: 'testUser',
      });

      expect(element.type).toBe(HelloComponent);
      expect(element.props).toEqual({ username: 'testUser' });
    });
  });

  describe('#renderComponent', () => {
    it('attaches integration data to node and creates a root', () => {
      const node = { nodeType: 1, nodeName: 'DIV', dataset: {} };
      const fakeRoot = { render: createSpy() };
      const createRootSpy = spyOn(ReactDOMClient, 'createRoot').andReturn(
        fakeRoot,
      );
      subject.registerComponent('componentName', HelloComponent);

      subject.renderComponent('componentName', { key: 1 }, node);

      expect(node.dataset.rwrElement).toEqual('true');
      expect(node.dataset.integrationName).toEqual('react-component');
      expect(node.dataset.payload).toEqual(
        '{"name":"componentName","props":{"key":1}}',
      );
      expect(createRootSpy.calls.length).toEqual(1);
      expect(fakeRoot.render.calls.length).toEqual(1);
    });

    it('reuses existing root on subsequent renders', () => {
      const node = { nodeType: 1, nodeName: 'DIV', dataset: {} };
      const fakeRoot = { render: createSpy() };
      const createRootSpy = spyOn(ReactDOMClient, 'createRoot').andReturn(
        fakeRoot,
      );
      subject.registerComponent('componentName', HelloComponent);

      subject.renderComponent('componentName', { key: 1 }, node);
      subject.renderComponent('componentName', { key: 2 }, node);

      expect(createRootSpy.calls.length).toEqual(1);
      expect(fakeRoot.render.calls.length).toEqual(2);
    });
  });

  describe('#unmountComponent', () => {
    it('unmounts and removes root at specified node', () => {
      const node = { nodeType: 1, nodeName: 'DIV', dataset: {} };
      const fakeRoot = { render: createSpy(), unmount: createSpy() };
      spyOn(ReactDOMClient, 'createRoot').andReturn(fakeRoot);
      subject.registerComponent('componentName', HelloComponent);

      subject.renderComponent('componentName', {}, node);
      subject.unmountComponent(node);

      expect(fakeRoot.unmount.calls.length).toEqual(1);
      expect(subject.roots.has(node)).toBe(false);
    });

    it('does nothing when no root exists for node', () => {
      const node = { nodeType: 1, nodeName: 'DIV' };
      expect(() => subject.unmountComponent(node)).toNotThrow();
    });
  });

  describe('#integrationWrapper', () => {
    const node = { nodeType: 1, nodeName: 'DIV' };

    describe('function mount', () => {
      it('calls renderComponent', () => {
        const payload = {
          name: 'componentName',
          props: { username: 'testUser' },
        };
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
        expect(unmountSpy).toHaveBeenCalledWith({
          nodeType: 1,
          nodeName: 'DIV',
        });
      });
    });
  });
});
