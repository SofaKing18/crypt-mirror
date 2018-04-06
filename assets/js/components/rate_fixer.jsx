import React from 'react';
import socket from "../socket.js";
import { Socket } from "phoenix"

export default class RateFixer extends React.Component {
  constructor(props) {
    super(props);
    let admin_socket = new Socket("/admin", {})
    admin_socket.connect()
    let channel = admin_socket.channel("rate_fixation")
    channel.join()
    this.state = {channel: channel, from: "", till: ""};
  }

  render() {
    return (
      <div className='col-6'>
        <div className="card text-center">
          <div className="card-header">
            Fix rates
          </div>
          <div className="card-body">
            from:<input value={this.state.from} placeholder="2017-02-11 13:00:00" onChange={e => this.from(e.target.value)} />
            <hr/>
            till:<input value={this.state.till} placeholder="2020-04-11 14:10:00" onChange={e => this.till(e.target.value)} />
          </div>
          <div className="card-footer">
            <button onClick={() => this.fix_rates()}>Fix rates</button>
          </div>
        </div>
      </div>
    );
  }

  from(value) {
    this.setState({ from: value })
  }

  till(value) {
    this.setState({ till: value })
  }

  fix_rates() {
    this.state.channel.push("fix", { fix_ts: this.state.from, fix_till: this.state.till })
      .receive("ok", () => {alert("Rates fixed")})
  }
}

