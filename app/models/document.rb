class Document < ApplicationRecord
  HEADERS = {'X-User-Email' => ENV['API_EMAIL'], 'Authorization' => "Token token=#{ENV['DICTIONARY_KEY']}", "Accept" => 'thesaurus/json'}

  belongs_to :user
  has_many :elements

  require 'gingerice'

  def ye_olde
    url = "http://www.dictionaryapi.com/api/v1/references/dictionary/xml/#{content}?key=#{ENV['DICTIONARY_KEY']}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri) #change the verb from Get if needed
    response = http.request(request)
    xml_doc  = Nokogiri::XML(response.body)
    syn = xml_doc.xpath("//syn").text #replace the tagname with the desired content
  end

  def cor
    parsey = []
    @sentence.each do |element|
      parsey << element.content
      parsey.map! {|a| a.to_s}.join
      parser = Gingerice::Parser.new
      parsed_response = parser.parse(@sentence.join)
      return parsed_response["result"]
    end  
  end
end
