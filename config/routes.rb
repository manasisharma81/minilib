Rails.application.routes.draw do
  devise_for :users

  get("/", { :controller => "pages", :action => "home" })
  get("/my_profile", { :controller => "users", :action => "show_current_user" })
  get("/edit_my_profile", { :controller => "users", :action => "edit_current_user_form" })
  post("/update_my_profile", { :controller => "users", :action => "update_current_user" })
  get("/users/:path_id", { :controller => "users", :action => "show" })

  get("/books", { :controller => "books", :action => "index" })
  get("/books/:path_id", { :controller => "books", :action => "show" })
  get("/search_books", { :controller => "books", :action => "search_form" })
  get("/book_search_results", { :controller => "books", :action => "search_results" })
  post("/preview_google_book/:path_google_books_id", { :controller => "books", :action => "preview_google_book" })
  post("/add_google_book/:path_google_books_id", { :controller => "books", :action => "add_google_book" })
  get("/insert_book_form", { :controller => "books", :action => "new_form" })
  post("/create_book", { :controller => "books", :action => "create_row" })
  get("/modify_book/:path_id", { :controller => "books", :action => "edit_form" })
  post("/update_book/:path_id", { :controller => "books", :action => "update_row" })
  get("/delete_book/:path_id", { :controller => "books", :action => "destroy_row" })

  get("/borrow_requests", { :controller => "borrow_requests", :action => "index" })
  get("/borrow_requests/:path_id", { :controller => "borrow_requests", :action => "show" })
  post("/create_borrow_request/:path_book_id/:path_owner_id", { :controller => "borrow_requests", :action => "create_row" })
  post("/create_borrow_message/:path_borrow_request_id", { :controller => "borrow_messages", :action => "create_row" })
  get("/approve_borrow_request/:path_id", { :controller => "borrow_requests", :action => "approve" })
  get("/deny_borrow_request/:path_id", { :controller => "borrow_requests", :action => "deny" })
  get("/close_borrow_request/:path_id", { :controller => "borrow_requests", :action => "close" })

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
