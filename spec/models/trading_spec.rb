require 'rails_helper'
require 'pry-debugger'

RSpec.describe TradingManager do
  let!(:valid_trade) {
    {
      :kind=>"quota_order",
      :caller_uuid=>"uuid_001",
      :seller_account=>{:client_number=>"12345"},
      :buyer_account=>{:client_number=>"98765"},
      :placer=>{:party_id=>"12345", :party_name=>"Joe the Trader"},
      :order_type=>"transfer_quota",
      :stocks=>
        [{:concept_id=>"hok1-nz", :symbol=>"hok1", :ordered_qty=>"100"},
          {:concept_id=>"lun-nz", :symbol=>"lun1", :ordered_qty=>"10"}]
    }
   }
  
  before(:each) { 
    buy_client = create(:buy_client)
    sell_client = create(:sell_client)
    hok1 = create(:stock, symbol: "hok1")
    lun1 = create(:stock, symbol: "lun1")    
  }
  
  context 'for a Valid Quota Transfer' do
    
    it 'takes a new trade and returns a valid Trade Object' do
      tm = TradingManager.new(valid_trade)
      expect(tm).to be_an_instance_of TradingManager            
    end
  
    it 'processes a valid trade and returns a completed Order' do
      tm = TradingManager.new(valid_trade)
      tm.execute
      expect(tm.order.state).to eql(:complete)
    end
      
    it 'should create 2 transactions' do
      tm = TradingManager.new(valid_trade)
      tm.execute
      expect(tm.order.transactions.count).to eql(2)
    end
    
    it 'should contain a buy and a sell transaction' do
      tm = TradingManager.new(valid_trade)
      tm.execute
      expect(tm.order.transactions.map(&:type)).to contain_exactly(:buy, :sell)
    end
    
    it 'should contain a buy transaction for the buy client' do
      tm = TradingManager.new(valid_trade)
      tm.execute
      expect(tm.order.buy_transaction.account.client_number).to eql(valid_trade[:buyer_account][:client_number])
    end
  
    it 'should contain 2 stock entries' do
    end
    
    it 'should have a stock entry for HOK1 of 100 units' do
    end
    
    it 'should add 100 Hok1 units to the buyer account' do
    end

    it 'should deduct 100 Hok1 units from the sellers account' do
    end

    
  end
  
  context 'for an Invalid Transfer Trade' do
      
  end
  
end