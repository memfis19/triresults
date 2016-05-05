class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'results'

  embeds_many :results, class_name: 'LegResult', after_add: :update_total, after_remove: :update_total, order: [:"event.o".asc]

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  def update_total(result)
    sum = 0
    sum = results.map(&:secs).inject(0, &:+)
    self.secs = sum;
  end

end
