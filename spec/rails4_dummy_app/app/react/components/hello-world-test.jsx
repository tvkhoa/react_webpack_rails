import React from 'react';
import TestUtils from 'react-dom/test-utils';
import expect from 'expect';
import HelloWorld from './hello-world';

describe('HelloWorld', () => {
  const component = TestUtils.renderIntoDocument(<HelloWorld/>);

  it('renders', () => {
    expect(TestUtils.findRenderedComponentWithType(component, HelloWorld)).toExist();
  });
});
