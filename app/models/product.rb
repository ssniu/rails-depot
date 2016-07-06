class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: true
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  # validates() is the standard Rails validator. It will check one or moure
  # model fields against one or more conditions
  # presence:true tells the validator to check that each of the named fields is present
  # and its contents are not empty.

  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  # numericality() option to verify that the price is a valid number

  # The uniqueness validation will perform a simple check to ensure that no other row
  # in the products table has the same title as the row we're about to save
  validates :title, uniqueness: true

  # Validate that the URL entered for the image is valide. "format" option
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG pr PNG image.'

  }

  def self.latest
    Product.order(:updated_at).last
  end

  private
  # ensure that there are no line items referencing this Product
  # hook method is a method that rails calls automatically at a given
  # point in an obejct's life
  # in this case, the method will be called before rails attempts to
  # destroy a row in the database,
  # if the hook method returns false, the row will not be destroyed
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end
end
