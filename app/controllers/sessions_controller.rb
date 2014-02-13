class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if params[:card_token] && (@gift_card = GiftCard.find_by(token: params[:card_token]))
      @gift_card.redeem(resource)
    end
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end