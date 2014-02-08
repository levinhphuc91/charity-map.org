class Dashboard::GiftCardsController < InheritedResources::Base
  layout "dashboard2"

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
end
