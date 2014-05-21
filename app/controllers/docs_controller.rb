class DocsController < ApplicationController
  skip_authorization_check

  def index
    render layout: 'swagger'
  end
end
