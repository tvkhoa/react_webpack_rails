import RWR from 'react-webpack-rails';
RWR.run();

import HelloWorld from './components/hello-world';
RWR.registerComponent('HelloWorld', HelloWorld);

if (module.hot) {
  module.hot.accept();
  RWR.reloadNodes();
}
