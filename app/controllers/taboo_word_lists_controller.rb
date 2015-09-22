class TabooWordListsController < ApplicationController
  require 'ostruct'
  require 'open-uri'
  require 'csv'

  def index
    @available_words = TabooWordList.where(version_number: -1).count
  end

  def new
    @new_taboo_word = TabooWordList.new
  end

  def create
    uploaded_file_path = params[:upload].path
    word_lists = CSV.read(uploaded_file_path)
    puts uploaded_file_path.to_s

    # if word_lists.collect {|x| x[0]}.select{|e| word_lists.collect{|x| x[0]}.count(e) > 1}.blank?
      word_lists.each_with_index do |word,i|
        @new_taboo_word = TabooWordList.new()
        @new_taboo_word.word = word[0]
        @new_taboo_word.taboo_word_1 = word[1]
        @new_taboo_word.taboo_word_2 = word[2]
        @new_taboo_word.taboo_word_3 = word[3]
        @new_taboo_word.taboo_word_4 = word[4]
        @new_taboo_word.taboo_word_5 = word[5]
        @new_taboo_word.version_number = -1
        if word.length != 6
          next
          @status = "Faliure"
          @error = []
          @error<< "Line number " +  i.to_s + " has less than 6 words"
          puts "Line number " +  i.to_s + " has an error"
          break
        else
          @new_taboo_word.save
        end
      end
      redirect_to '/taboo_word_lists/new'
    # else
      # @status = "Faliure"
      # @error = []
      # @error<< word_lists.collect {|x| x[0]}.select{|e| word_lists.collect{|x| x[0]}.count(e) > 1}.uniq.to_s + " word(s) are repeating in file"
      # puts word_lists.collect {|x| x[0]}.select{|e| word_lists.collect{|x| x[0]}.count(e) > 1}.uniq.to_s + " word(s) are repeating in file"
    # end
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
