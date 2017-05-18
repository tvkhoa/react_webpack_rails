# ReactWebpackRails
[![Travis CI](https://travis-ci.org/netguru/react_webpack_rails.svg?branch=master)](https://travis-ci.org/netguru/react_webpack_rails)

#### Rails - Webpack setup with React integration.
This gem provides easy and convenient way to build modern JavaScript stack on top of Rails applications using [Webpack](http://webpack.github.io/), [Webpacker](https://github.com/rails/webpacker), [React](https://facebook.github.io/react/), [Jest](https://facebook.github.io/jest/).

## Features
* [Install Generator](https://github.com/netguru/react_webpack_rails/blob/master/docs/install_generator.md) for quick [Webpack](http://webpack.github.io/) setup.
* Integrated [react-hot-loader](https://github.com/gaearon/react-hot-loader)
* ES6/7 support with [babeljs](https://babeljs.io/).
* Node.js based [server-side JavaScript execution](https://github.com/netguru/react_webpack_rails/blob/master/docs/server_side_rendering.md).
* Webpacker gives an easy and convenient way to manage and bundle JS application layer.
* [Jest](https://facebook.github.io/jest) allows to write modern tests.
* [React](https://facebook.github.io/react/) integration with server prerender option.

### Plugins:
* [rwr-alt](https://github.com/netguru/rwr-alt) plugin that makes it possible to populate and share Alt stores between react component located in different parts of rails views.
* [rwr-redux](https://github.com/netguru/rwr-redux) allows to use redux state containers in a rails views.
* [rwr-react_router](https://github.com/netguru/rwr-react_router) react-router integration.
* [rwr-view_helpers](https://github.com/netguru/rwr-view_helpers) handy view helpers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'react_webpack_rails'
```

Execute:

    $ bundle

Then run installation:

    $ rails g react_webpack_rails:install

*read more about [`install  generator`](https://github.com/netguru/react_webpack_rails/blob/master/docs/install_generator.md)*

### Babel

By default, `react-webpack-rails` uses Babel Stage 1 - Proposal. If you want to change the stage, you can do so in the `.babelrc` file. It is however not recommended to use Stage 0 in a production app, because the features present there can be dropped, which would break your application.

In order to make hot reload working, you'll need to opt out of Babel transpiling ES2015 modules by changing the Babel ES2015 preset to be `["es2015", { "modules": false }]`

## Usage
##### Check [docs](https://github.com/netguru/react_webpack_rails/tree/master/docs) for detailed api description.

#### Register component in application.js

From version `1.0` the gem is built upon `webpacker` and entry file for webpack 2.x is `app/javascript/packs/application.js`. In order to register component you need to add in the entry file:

```js
import Component from './components/some-component';
RWR.registerComponent('customComponentName', Component);
```

#### Use it in rails view

```erb
<%= react_component('customComponentName', { user: User.last }) %>
```

#### Use it in javascript file

```js
const element = $('#my-element');
RWR.renderComponent('customComponentName', {user_id: 1}, element);
```

#### Render component in controller

```ruby
def action_name
  render react_component: 'customComponentName', props: { user_id: 1 }
end
```

### Development environment
Run webpack in watch mode:

    $ ./bin/webpack -w

Run webpack in hot-auto-reloading mode using script:

    $ npm run start-hot-dev
    
It runs `webpack-dev-server` with `--hot --inline` flags required by hot-reload.

### Production environment

Webpacker hooks up a new `webpacker:compile` task to `assets:precompile`, which gets run whenever you run `assets:precompile`. The `javascript_pack_tag` and `stylesheet_pack_tag` helper method will automatically insert the correct HTML tag for compiled pack. So there is no need to run extra tasks.

#### Deployment
Check [docs/deployment.md](docs/deployment.md)

## Contributing

See the [contribution guide](https://github.com/netguru/react_webpack_rails/blob/master/CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
