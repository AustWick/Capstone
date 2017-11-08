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
      return syn
      # syn.each do |s|
      #   s
      # end
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
    puts "#{fl}================"
    1.times do
      return Verbs::Conjugator.conjugate content, :tense => :past
    end
    1.times do
      return Verbs::Conjugator.conjugate content, :tense => :present
    end
    1.times do
      return Verbs::Conjugator.conjugate content, :tense => :future
    end
  end   
end
