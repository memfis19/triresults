class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :date, type: Date
  field :loc, as: :location, type: Address

  embeds_many :events, as: :parent, order: [:order.asc]
  has_many :entrants, foreign_key: "race._id", dependent: :delete, order: [:secs.asc, :bib.asc]

  scope :upcoming, -> { where :date => {"$gte" => Date.current} }
  scope :past, -> { where :date => {"$lt" => Date.current} }
end
