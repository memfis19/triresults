class RaceRef
  include Mongoid::Document

  field :n, as: :name, type: String
  field :date, type: Date

  embedded_in :entrant, touch: true
  belongs_to :race, foreign_key: :_id

end
