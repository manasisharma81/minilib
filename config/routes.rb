Rails.application.routes.draw do
  devise_for :users

  get("/", { :controller => "users", :action => "show_current_user" })
  get("/my_profile", { :controller => "users", :action => "show_current_user" })
  get("/edit_my_profile", { :controller => "users", :action => "edit_current_user_form" })
  post("/update_my_profile", { :controller => "users", :action => "update_current_user" })

get("/books", { :controller => "books", :action => "index" })
get("/books/:path_id", { :controller => "books", :action => "show" })
get("/insert_book_form", { :controller => "books", :action => "new_form" })
post("/create_book", { :controller => "books", :action => "create_row" })
get("/modify_book/:path_id", { :controller => "books", :action => "edit_form" })
post("/update_book/:path_id", { :controller => "books", :action => "update_row" })
get("/delete_book/:path_id", { :controller => "books", :action => "destroy_row" })

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
