# ReactWebpackRails
[![Travis CI](https://travis-ci.org/netguru/react_webpack_rails.svg?branch=master)](https://travis-ci.org/netguru/react_webpack_rails)

#### Rails - Webpack setup with React integration.
This gem provides easy and convenient way to build modern JavaScript stack on top of Rails applications using [Webpack](http://webpack.github.io/) and [React](https://facebook.github.io/react/).

## Features
* [Install Generator](https://github.com/netguru/react_webpack_rails/blob/master/docs/install_generator.md) for quick [Webpack](http://webpack.github.io/) setup.
* Integrated [react-hot-loader](https://github.com/gaearon/react-hot-loader)
* ES6/7 support with [bablejs](https://babeljs.io/).
* Node.js based [server-side JavaScript execution](https://github.com/netguru/react_webpack_rails/blob/master/docs/server_side_rendering.md).
* [React](https://facebook.github.io/react/) integration with server prerender option.
* [React-router](https://github.com/rackt/react-router) integration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'react_webpack_rails'
```

Execute:

    $ bundle

Then run installation:

    $ rails g react_webpack_rails:install

This will create following files:

```
├── app
│   ├── react
│   │   ├── components
│   │   │   ├── hello-world.jsx
│   │   │   └── hello-world-test.jsx
│   │   └── index.js
│   ├── views
│   │   └── layouts
│   │       └── _react_hot_assets.html.erb
│   └── assets
│       └── javascripts
│           └──react_bundle.js
├── webpack
│   ├── dev.config.js
│   ├── hot-dev.config.js
│   ├── production.config.js
│   └── tests.config.js
├── .babelrc
├── karma.conf.js
├── package.json
└── webpack.config.js
```

Establish the node packages (may take a few moments)

    $ npm install    # you may see warnings to consider updating the provided package.json file with license and repository

Make sure you have [webpack](https://webpack.github.io/docs/installation.html) installed globally:

    $ npm install webpack -g

Generate `react_bundle` for first time:

    $ webpack

And require integration and bundle files in `application.js`

```js
//= require react_integration
//= require react_bundle
```

### Babel

By default, `react-webpack-rails` uses Babel Stage 1 - Proposal. If you want to change the stage, you can do so in the `.babelrc` file. It is however not recommended to use Stage 0 in a production app, because the features present there can be dropped, which would break your application.

## Usage
##### Check [docs](https://github.com/netguru/react_webpack_rails/tree/master/docs) for detailed api description.
#### to use hot-reloading add partial in your application.html.erb to `<body>`:
(it's not needed when you want to use just webpack in watch mode without hot-reloading)
```erb
<%= render 'layouts/react_hot_assets' %>
```

#### Register component in index.js

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
Run webpack in watch mode using script:

    $ npm start

Run webpack in hot-auto-reloading mode using script (to use it you have to add `react_hot_assets` partial as mentioned before):

    $ npm run start-hot-dev

Or manually:

    $ webpack -w --config YOUR_CONFIG


### Production environment
Run webpack in production mode before compiling assets using script:

    $ npm run build

or manually:

    $ webpack -p --config YOUR_CONFIG

#### Deployment
Check [docs/deployment.md](docs/deployment.md)

## Contributing

See the [contribution guide](https://github.com/netguru/react_webpack_rails/blob/master/CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
