# GET Top Entities by Phrase /phrases/:entity.json
#
# Params:
# entity - enumerated - legislator/state/volume/chamber
# phrase - string
# mincount - integer
# page - integer
# per_page - integer
# sort - string
# state - string
# party - enumerated - D/R/I
# chamber - enumerated - house/senate/extensions
# date - date
# start_date - date
# end_date - date


module CapitolWordsWrapper

  STATES = %w(AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)

  API_ENDPOINT = "http://capitolwords.org/api/1"
  START_DATE = "2015-01-01"
  END_DATE = "2015-12-31"

  def self.phrase(phrase)

    uri = Addressable::URI.parse(API_ENDPOINT + "/phrases/state.json")
    uri.query_values = {
      phrase: phrase,
      sort: "count",
      start_date: START_DATE,
      end_date: END_DATE,
      apikey: ENV["SUNLIGHT_FOUNDATION_KEY"]
    }

    table = HTTParty.get(uri.normalize.to_s).parsed_response["results"]
    table.map { |row| row.merge("count" => row["count"].to_i) }.select { |row| STATES.include?(row["state"]) }

  end

end
