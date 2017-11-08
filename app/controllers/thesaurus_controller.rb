class ThesaurusController < ApplicationController
  def suggest
    @content.each do |element|
      if element == "birds"
        puts "sparrow"
      elsif element == "why"
        puts "wherefore"
      elsif element == "do"
        puts "must"
      elsif element == "suddenly"
          puts "spontaneously"
      elsif element == "appear"
          puts "precipitate"
      else
        puts "sorry, we don't have any suggestions for this word"
      end
    end     
  end 
end