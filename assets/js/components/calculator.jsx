import React from 'react';
import Rate from './rate.jsx'


export default class Calculator extends React.Component {

  constructor(props) {
    super(props);

    this.state = { crypt: "BTC", quantity: "", iso8601field: ""};
  }

  render() {
    return (
      <div className='col-6'>
        <div className='row align-items-center'>
          Quanty: <input type="number" step="any" value={this.state.quantity} onChange={e => this.number(e.target.value)} />
          <select size="1" onChange={e => this.crytp(e.target.value)}>
              <option value="BTC">BTC</option>
              <option value="ETH">ETH</option>
              <option value="BCH">BCH</option>
          </select>
          <hr/>
          timestamp:<input value={this.state.iso8601field} placeholder="2017-02-11 13:00:00" onChange={e => this.iso8601(e.target.value)} />
          <button onClick={() => this.calculate()}>Convert</button>
          <h6>{this.state.result}</h6>
        </div>
      </div>
    );
  }

  crytp(symbol) {
    this.setState({crypt: symbol })
  }

  iso8601(value) {
    this.setState({ iso8601field: value })
  }

  number(value) {
    this.setState({quantity: value})
  }

  calculate() {
    let that = this
    const qty = this.state.quantity
    const crypt = this.state.crypt
    let url = `/api/calcalator/to_usd?quantity=${qty}&crypt=${crypt}`
    if (this.state.iso8601field.length > 0) {
      url = url + `&timestamp=${encodeURIComponent(this.state.iso8601field)}`
    }
    $.ajax({
      url: url,
    }).done(function (data) {
      that.setState({result: (`${qty} ${crypt} = ${data.usd} $`)})
    });
  }
}