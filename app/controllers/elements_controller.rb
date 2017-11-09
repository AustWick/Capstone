class ElementsController < ApplicationController
HEADERS = {'X-User-Email' => ENV['API_EMAIL'], 'Authorization' => "Token token=#{ENV['THESAURUS_KEY']}", "Accept" => 'thesaurus/json'}
  def show
    @element = Element.find(params[:id])
    @words_array = @element.suggest unless @element.suggest == "No suggestions for this word."
  end

  def update
    p "Word to replace?"
    p params[:word_to_replace]
    @element = Element.find(params[:id])
    @element.update(content: params[:word_to_replace])
    redirect_to "/documents/#{@element.document.id}"
    p params[:word_to_replace]
  end


  def suggest
    content.each do |element|
      @suggest = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{element}?key=#{ENV['THESAURUS_KEY']}"
      content.suggest
    end     
  end
end