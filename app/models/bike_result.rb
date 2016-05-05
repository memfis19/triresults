class BikeResult < LegResult
  field :mph, type: Float

  def calc_ave
    self[:mph] = event.miles*3600/secs if !event.nil? and !secs.nil? and !event.miles.nil?
    return self[:mph]
  end

end