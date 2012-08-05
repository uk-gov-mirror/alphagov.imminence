module GeoTools
  EARTH_RADIUS_IN_MILES = 3963.19
  MILES_PER_LATITUDE_DEGREE = 69.047
  LATITUDE_DEGREES = EARTH_RADIUS_IN_MILES / MILES_PER_LATITUDE_DEGREE
  PI_DIV_RAD = 0.0174

  # Presuming we're working in miles. Stolen from geokit.
  # This makes the assumption that the earth is flat, which is
  # likely to lead to inaccuracies over large distances.
  def distance_between(from, to, options={})
    return 0.0 if from == to # fixes a "zero-distance" bug
    Math.sqrt(
      (
        MILES_PER_LATITUDE_DEGREE * (from['lat']-to['lat'])
      )**2 +
      (
        units_per_longitude_degree(from['lat']) * (from['lng']-to['lng'])
      )**2
    )
  end

  def units_per_longitude_degree(lat)
    (LATITUDE_DEGREES * Math.cos(lat * PI_DIV_RAD)).abs
  end

  # Convert miles to degrees, ignoring the curvature of the earth
  #
  # 1° latitude = 69.047 miles
  def miles_to_degrees(miles)
    miles / MILES_PER_LATITUDE_DEGREE
  end
end