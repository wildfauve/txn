namespace :admin do
  desc "Load Deemed Values"
  task deemed_value_load: :environment do
    f = File.open("lib/tasks/DeemedValuesAprilFebruaryFY.csv", 'r')
    f.gets # get header
    f.each do |line|
      DeemedValueReferenceImport.import_dv(line.chomp)
    end
  end
        

end
