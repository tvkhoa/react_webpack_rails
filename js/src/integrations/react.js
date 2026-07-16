import React from 'react';
import ReactDOMClient from 'react-dom/client';
import ReactDOMServer from 'react-dom/server';

class ReactIntegration {
  constructor() {
    this.components = {};
    this.roots = new Map();
    this.registerComponent = this.registerComponent.bind(this);
    this.getComponent = this.getComponent.bind(this);
    this.createComponent = this.createComponent.bind(this);
    this.renderComponent = this.renderComponent.bind(this);
    this.unmountComponent = this.unmountComponent.bind(this);
    this.renderComponentToString = this.renderComponentToString.bind(this);
  }

  registerComponent(...args) {
    if (typeof args[0] === 'object') {
      const component = args[0];
      this.components = Object.assign({}, this.components, component);
    }

    const [name, component] = args;
    this.components[name] = component;
  }

  registerComponents(components) {
    this.components = Object.assign({}, this.components, components);
  }

  getComponent(name) {
    return this.components[name];
  }

  createComponent(name, props) {
    const constructor = this.getComponent(name);
    return React.createElement(constructor, props);
  }

  renderComponent(name, props, node) {
    const nativeNode = node.selector ? node[0] : node;
    ReactIntegration.attachIntegrationData(nativeNode, name, props);
    let root = this.roots.get(nativeNode);
    if (!root) {
      root = ReactDOMClient.createRoot(nativeNode);
      this.roots.set(nativeNode, root);
    }
    root.render(this.createComponent(name, props));
  }

  unmountComponent(node) {
    const nativeNode = node.selector ? node[0] : node;
    const root = this.roots.get(nativeNode);
    if (root) {
      root.unmount();
      this.roots.delete(nativeNode);
    }
  }

  renderComponentToString(name, props) {
    const component = this.createComponent(name, props);
    return ReactDOMServer.renderToString(component);
  }

  get integrationWrapper() {
    return {
      mount: function _mount(node, payload) {
        this.renderComponent(payload.name, payload.props, node);
      }.bind(this),

      unmount: function _unmount(node) {
        this.unmountComponent(node);
      }.bind(this),

      nodeRun: function _prerender(payload) {
        return this.renderComponentToString(payload.name, payload.props);
      }.bind(this),
    };
  }

  static attachIntegrationData(node, name, props) {
    const { dataset } = node;
    if (dataset.rwrElement) return;
    dataset.rwrElement = 'true';
    dataset.integrationName = 'react-component';
    dataset.payload = JSON.stringify({ name, props });
  }
}

export default new ReactIntegration();
