
const Tether = artifacts.require("Tether");
const Reward= artifacts.require("Reward");
const Decentral_Bank = artifacts.require("Decentral_bank");

require('chai')
.use(require('chai-as-promised'))
.should()

contract('Decentral_Bank',([owner, customer])=> {
    let tether, reward, Decentral_bank

    function tokens (amount) {
        return web3.utils.toWei(amount,'ether')
    }

    before( async () => {
        tether = await Tether.new()
        reward = await Reward.new()
        Decentral_bank = await Decentral_Bank.new(reward.address, tether.address)


        await reward.transfer(Decentral_bank.address, tokens('1000000'))

        await tether.transfer(Decentral_bank.address, tokens('100000'),{from:owner})

        await tether.transfer(customer, tokens('100'), {from: owner})
    })

    describe('Mock Tether Deployment', async ()=>{
        it('matched name successfully', async () => {
            const name = await tether.name()
            assert.equal(name, 'Tether Token')
        })
    })

    describe('Reward Deployment', async ()=>{
        it('Reward name successfully', async () => {
            const name = await reward.name()
            assert.equal(name, 'Reward Token')
        })
    })

    describe('Decentral_bank', async () => {
        it('Decentralbank name successfully', async () => {
            const name = await Decentral_bank.name()
            assert.equal(name, 'DecentralBank')
        }) 

        it('contract has token', async () => {
            let balance = await reward.balanceOf(Decentral_bank.address)
            assert.equal(balance.toString(), tokens('1000000'))
        })

        describe('Yield Farming', async () => {
            it('check balance of customer', async () => {
                let result = await tether.balanceOf(customer)
                assert.equal(result, tokens('100'),'investor before staking')
                // approve transfer token
                await tether.approval(Decentral_bank.address, tokens('100'), {from: customer})
                // deposit token to defi bank
                await Decentral_bank.Deposit(tokens('100'), {from: customer})
                //check token in the wallet
                result = await tether.balanceOf(customer)
                assert.equal(result, tokens('0'))
                // customer staking balance
                result = await Decentral_bank.stakingBalance(customer)
                assert.equal(result, tokens('100'))
                // isstaking ?
                result = await Decentral_bank.hasStaking(customer)
                assert.equal(result, true)
             })
                it('check balance of reward', async () => {
                // pay a reward
                await Decentral_bank.issuedToken({from: owner})

                // unstake token
                await Decentral_bank.unstakeToken({from: customer})

                result = await Decentral_bank.stakingBalance(customer)
                assert.equal(result, tokens('0'))

                let status = await Decentral_bank.hasStaking(customer)
                assert.equal(status, false)
                 })
        })

        describe('apply_debt', async () => {
            it('Decentralbank apply debt successfully', async () => {

                await tether.approval_debt(customer,tokens('20'))

                await Decentral_bank.apply_debt(tokens('20'),{from: customer})
                result = await Decentral_bank.debt(customer)
                assert.equal(result, tokens('20'))
            }) 
    })
    })
})