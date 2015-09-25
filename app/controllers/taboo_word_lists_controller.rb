class TabooWordListsController < ApplicationController
  require 'ostruct'
  require 'open-uri'
  require 'csv'

  def index
    @available_words = TabooWordList.where(version_number: -1).count
  end

  def new
    @new_taboo_word = TabooWordList.new
    @new_word_count = params[:new_word_count]
    @words_with_error = params[:words_with_error]
    @repeated_words = params[:repeated_words]
  end

  def create
    uploaded_file_path = params[:file].path
    word_lists = CSV.read(uploaded_file_path)
    @message = ""
    @all_error_rows = ""
    @new_word_count = 0
    @words_with_error = Array.new
    @repeated_words = Array.new
    @repeated_words = word_lists.collect {|x| x[0]}.select{|e| word_lists.collect{|x| x[0]}.count(e) > 1}.uniq
    word_lists.each_with_index do |word,i|
      new_taboo_word = TabooWordList.new()
      new_taboo_word.word = word[0]
      new_taboo_word.taboo_word_1 = word[1]
      new_taboo_word.taboo_word_2 = word[2]
      new_taboo_word.taboo_word_3 = word[3]
      new_taboo_word.taboo_word_4 = word[4]
      new_taboo_word.taboo_word_5 = word[5]
      new_taboo_word.version_number = -1
      if word.length != 6
        @words_with_error << i + 1
        next
      elsif new_taboo_word.save
          @new_word_count = @new_word_count + 1
      end
    end
    if @words_with_error.size == word_lists.size
      @all_error_rows = "- All rows in this file contains errors"
    elsif @new_word_count == 0
        @message = " - All words are already present in database"
    end
  end

  def change_version_number
    unpublished_words = TabooWordList.where(version_number: -1)
    current_version = TabooWordList.maximum("version_number")
    unpublished_words.each do |word|
      word.version_number = current_version + 1
      word.save
    end
    redirect_to '/taboo_word_lists'
  end

  def check_updates
    current_version = TabooWordList.maximum("version_number")
    @words_available = OpenStruct.new
    if params[:vno].to_i >= current_version
      @status = "Faliure"
      @error = []
      @error<< "You have latest version"
    else
      @words_available.new_version = current_version
      @words_available.save
    end
  end

  def fetch_new_word
    current_version = TabooWordList.maximum("version_number")
    if params[:vno].to_i >= current_version
      @status = "Faliure"
      @error = []
      @error<< "You have updated wordlist"
    else
      @new_words = TabooWordList.where("version_number > ?",params[:vno])
    end
  end

end
