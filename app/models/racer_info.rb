class RacerInfo
  include Mongoid::Document

  field :_id, default: -> { racer_id }
  field :racer_id, as: :_id

  # field :fn, default: -> { first_name }
  # field :first_name, as: :fn, type: String

  field :first_name, default: -> { fn }
  field :fn, as: :first_name, type: String

  # field :ln, default: -> { last_name }
  # field :last_name, as: :ln, type: String

  field :last_name, default: -> { ln }
  field :ln, as: :last_name, type: String

  # field :g, default: -> { gender }
  # field :gender, as: :g, type: String

  field :gender, default: -> { g }
  field :g, as: :gender, type: String

  # field :yr, default: -> { birth_year }
  # field :birth_year, as: :yr, type: Integer

  field :birth_year, default: -> { yr }
  field :yr, as: :birth_year, type: Integer

  # field :res, default: -> { residence }
  # field :residence, as: :res, type: Address
  field :residence, default: -> { res }
  field :res, as: :residence, type: Address

  embedded_in :parent, polymorphic: true

  validates_presence_of :first_name, :last_name, :gender, :birth_year
  validates :gender, inclusion: {in: %w(M F)}
  validates :birth_year, numericality: {less_than: Date.current.year}

  ["city", "state"].each do |action|

    define_method("#{action}") do
      self.residence ? self.residence.send("#{action}") : nil
    end

    define_method("#{action}=") do |name|
      object=self.residence ||= Address.new
      object.send("#{action}=", name)
      self.residence=object
    end

  end

end
