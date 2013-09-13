class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Automagically call foo_params() to sanitize params[:foo]
  # Required for load_and_authorize_resource properly creating and updating models.
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render text: "<h1 class=\"alert alert-danger\">Permission Denided</h1>", layout: "application"
  end

  check_authorization unless: :devise_controller?

  def add_breadcrumb(title, url)
    @breadcrumb ||= []
    if Symbol === title then
      title = send(title)
    else
      title = I18n.t(title)
    end
    url = eval(url) if url =~ /_url|_path/
    @breadcrumb << [title, url]
  end

  def self.add_breadcrumb title, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, title, url)
    end
  end

  def authority_title
    I18n.t("authorities.show.title", name: @authority.name)
  end
end
