class TabooWordListsController < ApplicationController
  require 'ostruct'

  def index
    @all_words = TabooWordList.all
  end
  def create
    params[:word_lists].each do |word|
      new_taboo_word = TabooWordList.new()
      new_taboo_word.taboo_word = word[:taboo_word]
      new_taboo_word.option1 = word[:option1]
      new_taboo_word.option2 = word[:option2]
      new_taboo_word.option3 = word[:option3]
      new_taboo_word.option4 = word[:option4]
      new_taboo_word.option5 = word[:option5]
      new_taboo_word.flag = false
      new_taboo_word.save
    end
  end

  def check_new_words
    new_words = TabooWordList.where(flag: false)
    @words_available = OpenStruct.new
    if new_words.length >= Rails.application.config.limit #limit
      @words_available.flag = true
    else
      @words_available.flag = false
    end
  end

  def fetch_new_word
    @new_words = TabooWordList.where(flag: false).first(Rails.application.config.limit) #limit
    @new_words.each do |word|
      word.flag = true
      word.save
    end
  end

end
