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
    │   │   └── application.js (core)
│   ├── views
│   │   └── react_examples
│   │       └── component.html.erb (example)
│   ├── assets
│   │   └── javascripts
│   │       └──react_bundle.js (core)
│   └── controllers
│       └── react_examples_controller.rb (example)
├── .babelrc (core)
├── karma.conf.js (karma_setup)
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

*Detailed description of generators coming soon...*
