module Telegram
  class ReplyKeyboardRemove < Keyboard
    attribute :selective, Boolean, :default => false

    def to_h
      h = { remove_keyboard: true }
      h[:selective] = selective unless selective.nil?
      h
    end
  end
end
