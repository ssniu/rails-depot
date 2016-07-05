def create
  produce = Product.find(param[:product_id])
  @line_item = @cart.add_product(product.id)

  respond_to do |format|
    if @line_item.save
      format.html {redirect_to store_url}
      format.js {@current_item = @line_item}
      format.json {render action: 'show',
        status: :created, location: @line_item}
    else
      format.html {render action: 'new'}
      format.json {render json: @line_item.errors,
        status: :unprocessable_entity}
    end
  end
end 
