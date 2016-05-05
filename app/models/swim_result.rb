class SwimResult < LegResult
  field :pace_100, type: Float

  def calc_ave
    self[:pace_100] = secs / (event.meters / 100) if !event.nil? and !secs.nil? and !event.meters.nil?
    return self[:pace_100]
  end

end