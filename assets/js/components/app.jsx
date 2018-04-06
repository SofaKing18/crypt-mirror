import React from 'react';
import Rate from './rate.jsx'
import RateFixer from './rate_fixer.jsx'
import Calculator from './calculator.jsx'


export default class App extends React.Component {
  render() {
    return (
      <div id="content" className='container'>
        
        <h1>Rocket Crypt</h1>
        <div className='row align-items-center text-center'>
        </div>
        <div className='row align-items-center'>
          <Rate key={1} data={{ symbol: 'BTC'}} />
          <Rate key={2} data={{ symbol: 'ETH' }} />
          <Rate key={3} data={{ symbol: 'BCH' }} />
        </div>
        <br/>
        
        <h1>Cryptulator</h1>
        <div className='row'>
          <Calculator key={4} />
        </div>
        <br />
        
        <h1> Rate Fixation </h1>
        <div className='row'>
          <RateFixer key={5} />
        </div>
      </div>
    );
  }
}
