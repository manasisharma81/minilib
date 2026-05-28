class PagesController < ApplicationController
  def home
    render({ :template => "page_templates/home" })
  end
end
