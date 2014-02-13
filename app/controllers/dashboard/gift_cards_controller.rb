require 'charitio'
require 'sms'
require 'uri'

class Dashboard::GiftCardsController < InheritedResources::Base
  include GiftCardsHelper
  include ApplicationHelper
  layout "dashboard2"
  prepend_before_filter :authenticate_user!
  before_filter :connect_backend_api

  def index
    super
  end

  def create
    @gift_card = GiftCard.new(params[:gift_card])
    if @gift_card.save
      SMS.send(to: phone_striped(params[:recipient_phone]),
        text: "(Charity Map) Ban vua nhan duoc mot gift card tu #{current_user.name}. Xin hay truy cap: www.charity-map.org/gifts va dien ma so: #{@gift_card.token} de bat dau su dung."
      ) if !params[:recipient_phone].blank?
      UserMailer.delay.send_gift_card_info(@gift_card)
      redirect_to dashboard_gift_cards_path, notice: "New gift card added."
    else
      redirect_to new_dashboard_gift_card_path, alert: "@gift_card.errors.full_messages.join(' ')"
    end
  end

  def destroy
    @gift_card = GiftCard.find params[:id]
    if @gift_card.update_attribute :status, "INACTIVE"
      redirect_to dashboard_gift_cards_path, notice: "Mark as INACTIVE"
    else
      redirect_to dashboard_gift_cards_path, alert: "Unsuccessful operation."
    end
  end

  protected
    def begin_of_association_chain
      current_user
    end

    def connect_backend_api
      if user_signed_in? && (@user = current_user)
        @charitio = Charitio.new(@user.email, @user.api_token)
        if @user.api_token.blank?
          @workoff = @charitio.create_user(email: @user.email, category: "MERCHANT")
          if @workoff.ok?
            @user.update_attribute :api_token, @workoff.response["auth_token"]
          else
            redirect_to dashboard_path, alert: "API call not going through."
            logger.error(%Q{\
              [#{Time.zone.now}][User#connect_backend_api Charitio.create_user] \
                Affected user: #{@user.id} / Truncated email: #{@user.email.split('@').first} \
                API response: #{@workoff.response} \
              }
            )
          end
        end
        # @user_info = @charitio.get_user_info(email: @user.email)
        # if @user_info.ok? && @user_info.response["category"] != "MERCHANT"
        #   @charitio.update_user(email: @user.email, category: "MERCHANT")
        # end
      end
    end
end