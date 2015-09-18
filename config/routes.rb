Rails.application.routes.draw do
  get 'taboo_word_lists/fetch_new_word'
  get 'taboo_word_lists/check_new_words'
  resources :taboo_word_lists
end
