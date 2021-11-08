# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_letter(10).join
    @start_time = Time.now
  end

  def score
    letters = params[:letters].split('')
    @attempt = params[:attempt]
    start_time = Time.parse(params[:start_time])
    end_time = Time.now

    @result = run_game(@attempt, letters, start_time, end_time)
  end

  private

  def generate_letter(letter_size)
    Array.new(letter_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def included?(guess, letters)
    guess.split('').all? { |letter| letters.include? letter }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, letters, start_time, end_time)
    result = { time: end_time - start_time }

    result[:score], result[:message] = score_and_message(
      attempt, letters, result[:time]
    )
    result
  end

  def score_and_message(attempt, letters, time)
    if included?(attempt.upcase, letters)
      score = compute_score(attempt, time)
      [score, 'well done']
    else
      [0, 'not in the grid']
    end
  end
end
