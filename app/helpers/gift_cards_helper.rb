module GiftCardsHelper
  def cleared_credits_amount(charitio, email)
    @sum = 0
    @transactions = charitio.get_transactions(email: email)
    if @transactions.ok?
      @transaction_ids = []
      @transactions.response.each {|transaction| @transaction_ids.push(transaction["uid"])}
      @transaction_ids.each do |uid|
        @cleared_credits = charitio.get_cleared_credits(master_transaction_id: uid)
        @cleared_credits.response.each {|credit| @sum += credit.amount} if @cleared_credits.ok?
      end
      return @sum
    else
      return @sum
    end
  end

  def pending_clearance_credits_amount(charitio, email)
    @sum = 0
    @transactions = charitio.get_transactions(email: email)
    if @transactions.ok?
      @transactions = @transactions.response
      @transaction_ids = []
      @transactions.each {|transaction| @transaction_ids.push(transaction["uid"])}
      @transaction_ids.each do |uid|
        @cleared_credits = charitio.get_pending_clearance_credits(master_transaction_id: uid)
        @cleared_credits.response.each {|credit| @sum += credit.amount} if @cleared_credits.ok?
      end
      return @sum
    else
      return @sum
    end
  end

  def redeem_gift_card_from_signup(gift_card, recipient)
    if gift_card.redeemable?
      @charitio = Charitio.new(gift_card.user.email, gift_card.user.api_token)
      @transaction = @charitio.create_transaction(from: gift_card.user.email,
        to: recipient.email, amount: gift_card.amount.to_f, currency: "VND",
        references: gift_card.references_to_string)
      if @transaction.ok?
        gift_card.activate(@transaction.response["uid"], recipient.email)
      else
        logger.error(%Q{\
          [#{Time.zone.now}][Registration#create Charitio.create_transaction] \
            Affected user: #{recipient.id} / Truncated email: #{recipient.email.split('@').first} \
            API response: #{@transaction.response} \
            Params: #{{from: gift_card.user.email,
                      to: recipient.email, amount: gift_card.amount.to_f, currency: "VND",
                      references: gift_card.references_to_string}}
          }
        )
      end
    end
  end
end