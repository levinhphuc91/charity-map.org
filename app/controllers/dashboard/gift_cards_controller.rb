require 'charitio'
require 'sms'
require 'uri'

class Dashboard::GiftCardsController < InheritedResources::Base
  include GiftCardsHelper
  include ApplicationHelper
  layout "dashboard2"
  before_filter :authenticate_user!
  before_filter :connect_backend_api

  def index
    @cleared_credits_amount = cleared_credits_amount(@charitio, current_user.email)
    @pending_clearance_credits_amount = pending_clearance_credits_amount(@charitio, current_user.email)
    super
  end

  def create
    @gift_card = GiftCard.new(params[:gift_card])
    # @transaction = @charitio.create_transaction(from: @gift_card.user.email, 
    #   to: @gift_card.recipient_email, amount: @gift_card.amount, currency: "VND",
    #   references: @gift_card.references_to_string)
    # if @transaction.ok?
    #   @transaction = @transaction.response
    #   @gift_card.master_transaction_id = @transaction.uid
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
      @user = current_user
      @charitio = Charitio.new(@user.email, @user.api_token || ENV['CM_API_TOKEN'])
      if @user.api_token.blank?
        @workoff = @charitio.create_user(email: @user.email, category: "MERCHANT")
        if @workoff.ok?
          @user.update_attribute :api_token, @workoff.response["auth_token"]
        else
          redirect_to dashboard_path, alert: "#{@workoff.response}"
        end
      end
    end
end