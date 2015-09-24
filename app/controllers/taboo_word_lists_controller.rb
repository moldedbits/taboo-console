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
    puts "sfskdnfksdfksdngksngksdngksdnf\n"
    # request.query_string.split(/&/).inject({}) do |hash, setting|
    #   key, val = setting.split(/=/)
    #   hash[key.to_sym] = val
    #   hash
    # end
    puts params[:file].to_s
    uploaded_file_path = params[:file].path
    # CSV.foreach(uploaded_file_path, headers: true) do |row|
    #   row.to_a
    #   TabooWordList.create! row.to_hash
    # end
    word_lists = CSV.read(uploaded_file_path)
    puts params[:upload].to_s
    new_word_count = 0
    words_with_error = Array.new
    repeated_words = Array.new
    repeated_words = word_lists.collect {|x| x[0]}.select{|e| word_lists.collect{|x| x[0]}.count(e) > 1}.uniq
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
          words_with_error << i + 1
          next
          @status = "Faliure"
          @error = []
          @error<< "Line number " +  (i+1).to_s + " has less than 6 words"
          puts "Line number " +  (i+1).to_s + " has an error"
        else
          @new_taboo_word.save
          new_word_count = new_word_count + 1
        end
      end
      # render 'taboo_word_lists/new',status: @status

      # redirect_to new_taboo_word_list_path(:new_word_count => new_word_count, :words_with_error => words_with_error, :repeated_words => repeated_words)

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
