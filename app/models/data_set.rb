class DataSet
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :service
  embeds_many :places
  embeds_many :actions

  field :version, :type => Integer, :default => 1
  before_save :set_version, :on => :create
  before_save :reconcile_place_locations

  def reconcile_place_locations
    places.map(&:reconcile_location)
  end

  def set_version
    other_data_sets = service.data_sets.to_a - [self]

    if self.version.blank? or (self.version == 1 and other_data_sets.length >= 1)
      self.version = other_data_sets.length + 1
    end
  end

  def data_file=(file)
    CSV.parse(file.read, :headers => true) do |row|
      places.build(
        :name => row['name'],
        :address1 => row['address1'],
        :address2 => row['address2'],
        :town => row['town'],
        :postcode => row['postcode'],
        :access_notes => row['access_notes'],
        :general_notes => row['general_notes'],
        :url => row['url'],
        :source_address => row['source_address'],
        :lat => row['lat'],
        :lng => row['lng']
      )
    end
  end

  def active?
    self.version == service.active_data_set_version
  end

  def activate!
    service.active_data_set_version = self.version
    service.save
  end

  def new_action(user,type,comment)
    action = Action.new(:requester_id=>user.id,:request_type=>type,:comment=>comment)
    self.actions << action
    action
  end

  def places_near(lat, lng, opts = {})
    ordered_places = places.geocoded.sort_by { |p| p.distance_from(lat, lng) }
    if opts[:limit]
      ordered_places = ordered_places.slice(0, opts[:limit].to_i)
    elsif opts[:max_distance]
      ordered_places = ordered_places.select { |p| p.distance <= opts[:max_distance].to_f }
    end
    ordered_places
  end
end
