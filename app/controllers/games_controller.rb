class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = grid(10)
  end

  def score
  @letters = params[:letters]
  @word = params[:word]
  @result = run_game(@word, @letters)
  end

  def grid(size)
    result = []
    letters = ('A'..'Z').to_a
    size.to_i.times { result << letters.sample }
    result
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    # time_score = (start_time - end_time) * (-1)
    attempt.upcase!
    grid = grid.split(" ")
    # time = end_time - start_time
    # score = (attempt.length * 5) - time
    if word_qualifier(attempt, grid) && real_word_check(attempt)
      "<strong>Congratulations!</strong> #{attempt} is a word! "
    elsif word_qualifier(attempt, grid) == false
      "Sorry but #{attempt} can't be built out of #{grid.join(', ')}."
    elsif real_word_check(attempt) == false
      "I'm sorry this is not an English Word"
    end
  end

  def word_qualifier(attempt, grid)
    attempt.chars.all? { |element| attempt.count(element) <= grid.count(element) }
  end

  def real_word_check(attempt)
    url = "https://wagon-dictionary.herokuapp.com/"
    word_checker = URI.open(url + attempt).read
    word = JSON.parse(word_checker)
    return word["found"]
  end
end
