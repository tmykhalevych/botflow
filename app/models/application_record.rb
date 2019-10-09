class ApplicationRecord < ActiveRecord::Base
  include R18n::Helpers
  self.abstract_class = true
end
