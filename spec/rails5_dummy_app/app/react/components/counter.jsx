import React from 'react';
import Button from './button';

class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  componentWillMount() {
    console.log("Counter will mount");
  }

  componentDidMount() {
    console.log("Counter did mount");
  }

  render() {
    const { count } = this.state;
    const addOne = () =>
      this.setState({ count: count + 1 });
    return (
      <div>
        Current count:&nbsp;
        {count}
        <br />
        <Button onClick={addOne}>
          add
        </Button>
      </div>
    );
  }
}

export default Counter;
