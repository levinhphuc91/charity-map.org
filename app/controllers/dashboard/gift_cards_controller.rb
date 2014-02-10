require 'charitio'
require 'sms'

class Dashboard::GiftCardsController < InheritedResources::Base
  include GiftCardsHelper
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
    SMS.send(to: "#{params[:recipient_phone]}",
      text: "(Charity Map) Xin chao, ban vua nhan duoc mot gift card duoc gui tu #{current_user.name.split.last}. Moi ban ghe tham: www.charity-map.org/giftcards va dien ma so: 12402830 de bat dau ung ho tu thien."
    ) if params[:recipient_phone]
    # @transaction = @charitio.create_transaction(from: @gift_card.user.email, to: @gift_card.recipient_email, amount: @gift_card.amount, references: @gift_card.references_to_string)
    # if @transaction.ok?
    #   @transaction = @transaction.response
    #   @gift_card.master_transaction_id = @transaction.uid
    # @gift_card.save!
    redirect_to dashboard_gift_cards_path, notice: "New gift card added."
    # else
    #   logger.debug("== DEBUG == #{@transaction.response}")
    #   redirect_to new_dashboard_gift_card_path, alert: "Unsuccessful: #{@transaction.response}"
    # end
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
      @charitio = Charitio.new(current_user.email, current_user.api_token || ENV['CM_API_TOKEN'])
    end
end
