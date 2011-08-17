xml.instruct!
xml.kml("xmlns" => "http://www.opengis.net/kml/2.2", 'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.Document do
    xml.name @service.name
    @places.each do |place|
      xml.Placemark do
        xml.atom :link, place.url
        xml.name(place.name) if place.name.present?
        xml.description(place.general_notes) if place.general_notes.present?
        xml.address place.full_address
        unless place.location.nil? or place.location.empty?
          xml.Point do
            xml.coordinates "#{place.location[0]},#{place.location[1]},0"
          end
        end
      end
    end
  end
end