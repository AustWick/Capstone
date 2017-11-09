require 'net/http'
require 'wavefile'
require 'verbs'
class Element < ApplicationRecord
HEADERS = {'X-User-Email' => ENV['API_EMAIL'], 'Authorization' => "Token token=#{ENV['THESAURUS_KEY']}", "Accept" => 'thesaurus/json'}

HEADERS2 = {'X-User-Email' => ENV['API_EMAIL'], 'Authorization' => "Token token=#{ENV['DICTIONARY_KEY']}", "Accept" => 'thesaurus/json'}

  belongs_to :document
  
  def word?
    !!(content =~ /\A[a-zA-Z\d'-]+\z/)
  end

  def suggest
    url = "http://www.dictionaryapi.com/api/v1/references/thesaurus/xml/#{content}?key=#{ENV['THESAURUS_KEY']}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri) #change the verb from Get if needed
    response = http.request(request)
    xml_doc  = Nokogiri::XML(response.body)
    syn = xml_doc.xpath("//syn").text #replace the tagname with the desired content
    sug = xml_doc.xpath("//suggestion").text #replace the tagname with the desired content

    if sug == "#{content}th"
      return content.to_i.to_words
    elsif syn == ""
      return "No suggestions for this word."
    else

      # return syn.split(/(?![a-zA-Z\d'-])|(?<![a-zA-Z\d'-])/)
      words = syn.split(/(?![a-zA-Z\d'-])|(?<![a-zA-Z\d'-])/)
      word_array = []
      words.each do |word|
          if word =~ /[a-zA-Z\d'-]+/
            word_array << word
          end
      end
     return word_array
    end
  end

  def listen
    url = "http://www.dictionaryapi.com/api/v1/references/dictionary/xml/#{content}?key=#{ENV['DICTIONARY_KEY']}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri) #change the verb from Get if needed
    response = http.request(request)
    xml_doc  = Nokogiri::XML(response.body)
    et = xml_doc.xpath("//it") #replace the tagname with the desired content   
  end

  def type?
    url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{content}?key=#{ENV['DICTIONARY_KEY']}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri) #change the verb from Get if needed
    response = http.request(request)
    xml_doc  = Nokogiri::XML(response.body)
    fl = xml_doc.xpath("//fl") #replace the tagname with the desired content
      return Verbs::Conjugator.conjugate content, :plurality => :singular
      return Verbs::Conjugator.conjugate content, :plurality => :plural
  end   
end
