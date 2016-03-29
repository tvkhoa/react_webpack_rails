import ReactDOM from 'react-dom';

function deprecationWarning() {
  if (typeof console !== 'undefined' && console.warn) {
    const msg = [
      'Deprecation warning - since v0.3.0: current integration with react-router was extracted and moved to external plugin.',
      'Use https://github.com/netguru/rwr-react_router instead.',
    ];

    console.warn(msg.join('\n'));
  }
}

class ReactRouterIntegration {
  constructor() {
    this.routers = {};
    this.enabled = false;
    this.registerRouter = this.registerRouter.bind(this);
    this.getRouter = this.getRouter.bind(this);
    this.renderRouter = this.renderRouter.bind(this);
  }

  registerRouter(name, route) {
    deprecationWarning();
    this.routers[name] = route;
  }

  getRouter(name) {
    return this.routers[name];
  }

  renderRouter(name, node) {
    if (this.enabled === true) {
      throw new Error(
        `Error when rendering ${name}\n\trenderRouter: can't render more than one router.`
      );
    }
    this.enabled = true;
    ReactDOM.render(this.getRouter(name), node);
  }

  unmountRouter(node) {
    ReactDOM.unmountComponentAtNode(node);
    this.enabled = false;
  }

  get integrationWrapper() {
    return {
      mount: function _mount(node, payload) {
        this.renderRouter(payload.name, node);
      }.bind(this),

      unmount: function _unmount(node) {
        this.unmountRouter(node);
      }.bind(this),
    };
  }
}

export default new ReactRouterIntegration;
