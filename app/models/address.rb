class Address

  attr_accessor :city, :state, :location;

  def initialize(city, state, location)
    @city = city
    @state = state
    @location = Point.new(location[:coordinates][0], location[:coordinates][1]) if !location.nil?
  end

  def mongoize
    {:city => @city, :state => @state, :loc => Point.mongoize(@location)}
  end

  def self.demongoize(object)
    case object
      when nil then
        nil
      when Hash then
        Address.new(object[:city], object[:state], object[:loc])
      when (Address) then
        object
    end
  end

  def self.mongoize(object)
    case object
      when Address then
        object.mongoize
      when Hash then
        Address.new(object[:city], object[:state], object[:loc]).mongoize
      else
        object
    end
  end

  #used by criteria to convert object to DB-friendly form
  def self.evolve(object)
    case object
      when Address then
        object.mongoize
      else
        object
    end
  end

end