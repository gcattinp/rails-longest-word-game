require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = 10
    @letters = generate_grid(@grid)
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split('')

    if included?(@word, @letters)
      if english_word?(@word)
        @message = "Congratulations! #{@word} is a valid word!"
      else
        @message = "Sorry but #{@word} does not seem to be a valid English word.."
      end
    else
      @message = "#{@word} isn't on the grid"
    end

  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def english_word?(word)
    response = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

end
