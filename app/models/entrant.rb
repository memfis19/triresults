class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'results'

  embeds_one :racer, as: :parent, class_name: 'RacerInfo', autobuild: true
  embeds_one :race, class_name: 'RaceRef', autobuild: true
  embeds_many :results, class_name: 'LegResult', after_add: :update_total, after_remove: :update_total, order: [:"event.o".asc]

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  delegate :first_name, :first_name=, to: :racer
  delegate :last_name, :last_name=, to: :racer
  delegate :gender, :gender=, to: :racer, prefix: "racer"
  delegate :birth_year, :birth_year=, to: :racer
  delegate :city, :city=, to: :racer
  delegate :state, :state=, to: :racer

  delegate :name, :name=, to: :race, prefix: "race"
  delegate :date, :date=, to: :race, prefix: "race"

  RESULTS = {"swim" => SwimResult,
             "t1" => LegResult,
             "bike" => BikeResult,
             "t2" => LegResult,
             "run" => RunResult
  }

  DEFAULT_EVENTS = {"swim_secs" => "swim.secs",
                    "swim_pace_100" => "swim.pace_100",
                    "t1_secs" => "t1.secs",
                    "bike_secs" => "bike.secs",
                    "bike_mph" => "bike.mph",
                    "t2_secs" => "t2.secs",
                    "run_secs" => "run.secs",
                    "run_mmile" => "run.mmile"}

  def update_total(result)
    sum = results.map(&:secs.nil? ? 0 : :secs).inject(0, &:+) if results
    self.secs = sum;
  end

  def the_race
    race.race
  end

  def overall_place
    o.place if o
  end

  def gender_place
    gender.place if gender
  end

  def group_name
    group.name if group
  end

  def group_place
    group.place if group
  end

  RESULTS.keys.each do |name|
    define_method("#{name}") do
      result=results.select { |result| name==result.event.name if result.event }.first
      if !result
        result=RESULTS["#{name}"].new(:event => {:name => name})
        results << result
      end
      result
    end

    define_method("#{name}=") do |event|
      event=self.send("#{name}").build_event(event.attributes)
    end

    RESULTS["#{name}"].attribute_names.reject { |r| /^_/===r }.each do |prop|

      define_method("#{name}_#{prop}") do
        event=self.send(name).send(prop)
      end

      define_method("#{name}_#{prop}=") do |value|
        event=self.send(name).send("#{prop}=", value)
        update_total nil if /secs/===prop
      end
    end

  end

end
