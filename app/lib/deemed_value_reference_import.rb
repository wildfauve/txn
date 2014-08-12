class DeemedValueReferenceImport
  
  def self.import_dv(line)
    #Fishstock,Valid from,Valid to,Interim Deemed Value ($/kg) ,Notice number,schedule number,Notes,Notes
    props = line.split(",")
    DeemedValueRef.create_dvref(symbol: props[0], from: props[1], to: props[2], dv: props[3])
  end
end