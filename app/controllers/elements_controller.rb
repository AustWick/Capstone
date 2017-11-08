class ElementsController < ApplicationController
HEADERS = {'X-User-Email' => ENV['API_EMAIL'], 'Authorization' => "Token token=#{ENV['THESAURUS_KEY']}", "Accept" => 'thesaurus/json'}
  def show
    @element = Element.find(params[:id])
  end

  def suggest
    content.each do |element|
      @suggest = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{element}?key=#{ENV['THESAURUS_KEY']}"
      content.suggest
    end     
  end
end