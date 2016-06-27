class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: true
  # validates() is the standard Rails validator. It will check one or moure
  # model fields against one or more conditions
  # presence:true tells the validator to check that each of the named fields is present
  # and its contents are not empty.

  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  # numericality() option to verify that the price is a valid number
end
