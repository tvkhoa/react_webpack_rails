import RWR from 'react-webpack-rails';
RWR.run();

import HelloWorld from './components/hello-world';
RWR.registerComponent('HelloWorld', HelloWorld);

import Counter from './components/counter';
RWR.registerComponent('Counter', Counter);

if (module.hot) {
  module.hot.accept();
  RWR.mountNodes();
}
