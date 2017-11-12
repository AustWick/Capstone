class DocumentsController < ApplicationController
  HEADERS = {'X-User-Email' => ENV['API_EMAIL'], 'Authorization' => "Token token=#{ENV['DICTIONARY_KEY']}", "Accept" => 'thesaurus/json'}

  def index
    @documents = Document.all
  end

  def new
    
  end

  def create
    doc = Document.create(title: params[:title], user_id: 1)
    order_holder = 0
    params[:content].split(/(?![a-zA-Z\d'-])|(?<![a-zA-Z\d'-])/).each do |word_element|
      order_holder += 1
      Element.create(
                    content: word_element, 
                    document_id: doc.id, 
                    order: order_holder
                    )
    end 
    redirect_to "/documents/#{doc.id}"
  end

  def show
    @noun = 0
    @verb = 0
    @adjective = 0
    @adverb = 0
    @preposition = 0
    @conjunction = 0
    @determiner = 0
    @exclamation = 0
    @pronoun = 0
    @other = 0

    @document = Document.find(params[:id])
    @sentence = @document.elements.order("elements.order")
    
    @word_array = []
    @document.elements.each do |element|
      @word_array << element.content
    end
    @word_string = @word_array.join()
    @word_string.gsub!(/\W+/, ' ')
    @word_array = @word_string.split(' ')
    
    @word_array.each do |word|
      url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=#{ENV['DICTIONARY_KEY']}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri) #change the verb from Get if needed
      response = http.request(request)
      xml_doc  = Nokogiri::XML(response.body)
      fl = xml_doc.xpath("//fl") #replace the tagname with the desired content

      fl_array = []

      fl_string = fl.to_s
      fl_string.gsub!(/[<fl>\W]/, '')
      fl_array << fl_string

      fl_each = fl_array.join()
      if fl_each.start_with?("noun") == true
        @noun += 1
      elsif fl_each.start_with?("verb") == true
        @verb += 1
      elsif fl_each.start_with?("adjective") == true
        @adjective += 1
      elsif fl_each.start_with?("adverb") == true
        @adverb += 1
      elsif fl_each.start_with?("preposition") == true
        @preposition += 1
      elsif fl_each.start_with?("conjunction") == true
        @conjunction += 1
      elsif fl_each.start_with?("determiner") == true
        @determiner += 1
      elsif fl_each.start_with?("exclamation") == true
        @exclamation += 1
      elsif fl_each.start_with?("pronoun") == true
        @pronoun += 1
      else
        @other += 1
      end
    end

    parsey = []
    @sentence.each do |el|
      parsey << el.content
      parsey.map! {|a| a.to_s}.join
      parser = Gingerice::Parser.new
      parsed_response = parser.parse(parsey.map! {|a| a.to_s}.join)
      @thing = parsed_response["result"]
    end
  end

  def destroy
    document = Document.find(params[:id])
    document.delete
    redirect_to "/documents"
  end
end