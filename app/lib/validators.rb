class StockEntryValidator < ActiveModel::Validator
  def validate(record)
    binding.pry
    unless record.name.starts_with? 'X'
      record.errors[:name] << 'Need a name starting with X please!'
    end
  end
end