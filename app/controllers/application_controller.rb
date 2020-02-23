require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Automagically call foo_params() to sanitize params[:foo]
  # Required for load_and_authorize_resource properly creating and updating models.
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  around_action :apply_user_preferences
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

  def self.add_breadcrumb(title, url, options = {})
    before_action options do |controller|
      controller.send(:add_breadcrumb, title, url)
    end
  end

helper_method :user_signed_in?
def user_signed_in?
  true
end

helper_method :current_user
def current_user
  User.new(id: 1, email: 'romain@examplecom', time_zone: 'Pacific/Tahiti')
end

  def certificate_authority_title
    abbr_subject(@certificate_authority.subject)
  end

  def policy_title
    @policy.name
  end

  def apply_user_preferences
    if user_signed_in? then
      Time.zone = current_user.time_zone
     # I18n.locale = current_user.locale
    end
    yield
  ensure
    Time.zone = Time.zone_default
    #I18n.locale = I18n.default_locale
  end
end
