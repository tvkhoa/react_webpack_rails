Install Generator
=======

`Install` generator is build from 5 independent generators responsible for different parts of installation process. All steps except core generator can be skipped by passing one of possible [options](#options).

```bash
$ rails generate react_webpack_rails:install
```

Install generator run with default options will create following structure:

```
├── app
│   ├── javascript
│   │   ├── packs
│   │   │   ├── components
│   │   │   │   └── hello-world.jsx (example)
│   │   │   ├── tests
│   │   │   │   └── hello-world.test.jsx (example)
│   │   │   └── application.js (core)
│   ├── views
│   │   └── react_examples
│   │       └── component.html.erb (example)
│   ├── assets
│   │   └── javascripts
│   │       └──react_bundle.js (core)
│   └── controllers
│       └── react_examples_controller.rb (example)
├── .babelrc (core)
└── package.json (core)
```

And modify:
- `config/routes.rb` by adding a route for example component,
- `app/javascript/packs/application.js` by adding import of RWR, example component and enabling hot-reload;
- `app/views/layouts/application.html.erb` by adding `javascript_pack_tag`
- `config/webpack/shared.js` by adding proper output in order to combine RWR and webpacker

### Options
* `--no-example` - skip example generator
* `--no-hot-reload` - skip hot_reload generator
* `--no-jest-setup` - skip jest_setup generator
* `--redux` - install and setup [`rwr-redux`](https://github.com/netguru/rwr-redux) gem

### Generators

#### Core generator

It is the most basic generator, which is responsible for adding mandatory files
in order to make `Rails` and `react_webpack_reails` integration working. It
includes:
* `.babelrc` and `.eslintrc` configuration
* adds `package.json` libraries
* includes libraries in application's manifests

#### Example generator
This generator creates a simple scaffold including:
* route
* controller
* view
* import and run of `RWR` object
* registering `react` component

#### Hot Reload generator
Hot Module Replacement (HMR) exchanges, adds, or removes modules while an application is running without a `page reload`.
From version *1.0* we use webpacker, which gives us easy way to use `HMR`. In
order to run `webpack-dev-server` in hot-reload mode generator:
* enables hot-reload in entry point file (`application.js`)
* adds required libraries to `package.json`

To run `webpack-dev-server` in HMR mode, you need to run `npm run
start-hot-dev`.

#### Jest setup generator
We also switched from `Karma` to `Jest` in 1.0 version. The generator adds only
few packages to `package.json`.
According to webpacker's convention, test mest be placed in the
`app/javascript/packs/tests/` directory. Also the must end with `.test.jsx`
(i.e. hello-world.test.jsx). In other case you have to change format in
webpacker's configuration.

#### Redux generator
This generator gives you ability to integrate `Redux` with the rails
application. The generator:
* adds required libraries to `package.json`
* adds import to entry file
* registers `redux-store` and `redux-container`
* adds `rwr-redux` to `Gemfile`

#### View helpers
The generator:
* adds `rwr-view_helpers` to Gemfile
* adds requires libraries to `package.json`
