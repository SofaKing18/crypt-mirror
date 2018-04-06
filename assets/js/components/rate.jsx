import React from 'react';
import socket from "../socket.js";

export default class Rate extends React.Component {
  constructor(props) {
    super(props);

    let channel = socket.channel("crypt_rate_" + props.data.symbol)

    channel.join()
      .receive("ok", resp => {
        console.log("joined channel", resp)
        this.setState({ usd: resp.usd })
      })

    channel.on("rate_update", resp => { console.log(props.data.symbol + " update", resp) 
      this.setState({ usd: resp.usd })
    }) 
    this.state = { channel: channel, usd: null};
  }

  render() {
    return (
      <div className='col-3'>
        <div className="card text-center">
          <div className="card-header">
            {this.props.data.symbol}
          </div>
          <div className="card-body">
            <h5>{this.state.usd} $ </h5>
          </div>
        </div>
      </div>
    );
  }
}

