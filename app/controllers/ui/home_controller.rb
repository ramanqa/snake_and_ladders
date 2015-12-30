module Ui
class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @host = request.host
  end
end
end # module UI