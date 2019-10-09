module Telegram
  class KeyboardButton
    include Virtus.model
    attribute :text, String
    attribute :request_contact, Boolean, :default => false
    attribute :request_location, Boolean, :default => false
  end
end
