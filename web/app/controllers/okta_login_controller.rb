class OktaLoginController < ApplicationController
  skip_before_filter :authenticate_by_ip

  def index
  end

  def login
    require "web/okta_authentication_strategy"

    use_case_factory.authenticate(
      observer: self,
      session: app_session,
      authentication_strategy: Web::OktaAuthenticationStrategy.new(
        auth_hash: request.env["omniauth.auth"],
      )
    ).execute
  end

  def authentication_succeeded
    redirect_to root_path
  end
end
