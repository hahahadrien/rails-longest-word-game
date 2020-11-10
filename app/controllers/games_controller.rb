require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    # The new action will be used to display a new random grid and a form.
    o = [('A'..'Z')].map(&:to_a).flatten
    string = (0...10).map { o[rand(o.length)] }.join
    @letters = string
    # .each {|letter| p "${letter}  "}
  end

  # def score
  #   # The form will be submitted (with POST) to the score action.
  #   # Cas 1) The word cant be built out of the original grid
  #   if params[:word].each_char.any?{ |char| lowercase.@letters?(char) || uppercase.@letters?(char) } == true

  #     if # Cas 3) The word is valid according to the grid and is an English word
  #       return "Congratulations! #{params[:word]} is a valid English word!"
  #     else # Cas 2) The word is valid according to the grid, but is not a valid English word
  #       return "Sorry but #{params[:word]} does not seem to be a valid English word..."

  #   else # Cas 1) The word cant be built out of the original grid
  #     return "Sorry but #{params[:word]} cannot be built out of #{@letters}"
  #   end
  # end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{params[:word]}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score
    if included?(params[:word], @letters)
      if english_word?(params[:word])
        "well done"
      else
        "not an english word"
      end
    else
      "not in the grid"
    end
  end

  # # Gemfile
  # # [...]
  # group :development, :test do
  #   # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  #   gem 'pry-byebug'
  # end
end
