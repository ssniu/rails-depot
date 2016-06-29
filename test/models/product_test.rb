require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products #will cause products.yml fixture file to be used
  # test "the truth" do
  #   assert true
  # end
  test "produce attributes must not be empty" do
    product = Product.new
    assert product.invalid? #The assert line in this method is an actual test.
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?

  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
                          description: "yyy",
                          image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:one).title,
    # In the book, it is "products(:ruby).title", got the error message
    # No fixture named 'ruby' found for fixture set 'products'
    # Take "one" to replace the "ruby", cause there are 'one' & 'two'
    # fixtures in the fixture file
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
  def new_product(image_url)
    Product.new(title: "My Book Title",
                description: "yyy",
                price: 1,
                image_url: image_url)
  end
  test "image_url" do
    #Text-book is incorrect, it stated "test "image url", mising "_" between image_url

    ok = %w{fred.gif fred.jpg fred.png FRED.jpg FRED.Jpg
             http://a.b.c/z/y/z.gif}
    bad = %w{ fred.doc fred.gif/more fred.gif.more}
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end

  end

end
