namespace :admin do
  desc "Load Deemed Values"
  task deemed_value_load: :environment do
    f = File.open("lib/tasks/DeemedValuesAprilFebruaryFY.csv", 'r')
    f.gets # get header
    f.each do |line|
      DeemedValueReferenceImport.import_dv(line.chomp)
    end
  end
  
  desc "Allocate ACE at Start of FY"
  task allocate_ace: :environment do
    EntitlementManger.new.allocate_ace_at_period_start
  end
  
  desc "Client Entitlement Positions for all Stock"
  task client_position: :environment do
    client = Client.first
    entitle = client.entitlement_positions.on(Date.today - 1.years).for(:all)
    entitle.each do |stock|
      puts "Stock: #{stock[:stock_symbol]}  Qty: #{stock[:qty]}"
    end
  end

end
