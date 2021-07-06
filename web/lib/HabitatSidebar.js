import {
  getSigner,
  wrapListener,
  renderAmount,
  walletIsConnected,
  getConfig,
  getToken,
  ethers
} from './utils.js';
import {
  getUsername,
  getProviders,
  getGasTank,
  onChainUpdate
} from './rollup.js';

import './HabitatColorToggle.js';
import './HabitatTokenAmount.js';

const { HBT } = getConfig();

const NAV_TEMPLATE =
`
<style>
.sidebar {
  display: flex;
  max-width: max-content;
  flex-direction: column;
  place-items: center;
  border-radius: 2em 0 2em 0;
  box-shadow: 4px 4px 20px rgba(0,0,0,.4);
  padding-bottom: 2em;
  overflow: hidden;
  padding: 0;
  margin: 2em auto;
  background-color: none;
}
.sidebar button,
.sidebar .button {
  width: 100%;
}
#top {
  background-color: var(--color-bg);
  border-radius: 0 0 2em 0;
  padding: 1em;
}
#balances {
  width: 100%;
}
.bl {
  text-align: center;
  font-size: .7em;
  border: 1px solid;
  border-radius: 1em;
  padding: .5em;
  background-color: var(--color-bg);
}
.bl a {
  color: var(--color-text);
}
</style>
<div class='sidebar'>
  <div id='top'>
    <div class='flex col center around'>
      <div class='flex col'>
        <object type='image/svg+xml' style='height:2em;' data='/lib/assets/v2-logo-full.svg'></object>
      </div>
      <space></space>
      <div id='walletbox' class='flex col'>
        <div class='dropdown'>
          <a href='' id='connect' class='noHover' style='border:none;font-size:1.2em;'>Connect</a>
        </div>
        <space></space>
        <p id='status' class='smaller'></p>
      </div>
    </div>
    <space></space>
    <div class='flex col evenly'>
      <div class='no-max-width' style='display:grid;'>
        <a class='button black' href='#habitat-communities'>Communities</a>
        <a class='button' target='_blank' href='/evolution/'>Evolution</a>
        <a class='button' target='_blank' href='/explorer/'>Block Explorer</a>
      </div>
      <space></space>
    </div>
  </div>

  <div id='balances' class='flex col evenly' style='padding:.5em;'>
    <space></space>
    <div class='no-max-width' style='display:grid;width:calc(100% - 1em);'>
      <div>
        <div style='padding: 0 1em;'>
          <p class='icon-eth'>Mainnet</p>
        </div>
        <space></space>
        <p class='bl flex center'><habitat-token-amount id='mainnetBalance' class='flex' token='${HBT}'></habitat-token-amount></p>
      </div>
      <space></space>
      <space></space>
      <div>
        <div style='padding: 0 1em;'>
          <p>🏕 Rollup</p>
        </div>
        <space></space>
        <p class='bl flex center'><habitat-token-amount id='rollupBalance' class='flex' token='${HBT}'></habitat-token-amount></p>
      </div>
      <space></space>
      <space></space>
      <div class='left'>
        <div style='padding: 0 1em;'>
          <p>⛽️ Gas</p>
        </div>
        <space></space>
        <p class='bl flex center'><habitat-token-amount id='gasTankBalance' class='flex' token='${HBT}'></habitat-token-amount></p>
      </div>
    </div>
    <space></space>
    <habitat-color-toggle style='position:relative;padding-bottom:1.5em;transform:none;'></habitat-color-toggle>
  </div>
</div>`;

class HabitatSidebar extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback () {
    this.innerHTML = NAV_TEMPLATE;
    this._walletContainer = this.querySelector('#walletbox');

    wrapListener(this.querySelector('a#connect'), async () => {
      await getSigner();
      this.update();
      window.location.hash = '#habitat-account';
    });

    this.update();
  }

  async update () {
    onChainUpdate(this.update.bind(this));

    if (!this.isConnected) {
      return;
    }

    if (!walletIsConnected()) {
      return;
    }

    const signer = await getSigner();
    const account = await signer.getAddress();
    const center = this._walletContainer.querySelector('#connect');
    const walletStatus = this._walletContainer.querySelector('#status');

    walletStatus.textContent = '🙌 Connected';

    center.textContent = await getUsername(account);
    this._walletContainer.classList.add('connected');

    const token = await getToken(HBT);
    const { habitat } = await getProviders();
    {
      const value = await token.balanceOf(account);
      const e = this.querySelector('#mainnetBalance');
      e.setAttribute('owner', account);
      e.setAttribute('amount', value);
    }
    {
      const value = await habitat.callStatic.getBalance(token.address, account);
      const e = this.querySelector('#rollupBalance');
      e.setAttribute('owner', account);
      e.setAttribute('amount', value);
    }
    {
      const { value } = await getGasTank(account);
      const e = this.querySelector('#gasTankBalance');
      e.setAttribute('owner', account);
      e.setAttribute('amount', value);
    }
  }
}
customElements.define('habitat-sidebar', HabitatSidebar);
