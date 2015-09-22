Rails.application.routes.draw do
  get 'taboo_word_lists/fetch_new_word'
  get 'taboo_word_lists/check_updates'
  post 'taboo_word_lists/change_version_number'
  resources :taboo_word_lists
end
