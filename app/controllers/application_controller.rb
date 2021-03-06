class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user
  before_action :basic_auth, if: :production?

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def configure_permitted_parameters
    # 新規登録時(sign_up時)にnicknameというキーのパラメーターを追加で許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :family_name, :last_name, :j_family_name , :j_last_name, :birthday, :prefecture , :municipalities, :address , :building , :phone_number, :card_number , :expiration_date, :security_number])
  end

  private

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
