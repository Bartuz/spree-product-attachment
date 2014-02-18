module Spree
	module Admin
		class DownloadablesController < Spree::Admin::BaseController
			helper 'spree/products'
			resource_controller
		  before_filter :load_data

		  respond_to :html

		  new_action.response do |wants|
			wants.html {render :action => :new, :layout => false}
		  end

		  create.response do |wants|
			wants.html {redirect_to admin_product_downloadables_path(@product)}
		  end
		  
		  create.failure.wants.html do
			render :action => :index
		  end

		  update.response do |wants|
			wants.html {redirect_to admin_product_downloadables_path(@product)}
		  end

		  create.before do
			if params[:downloadable].has_key? :viewable_id
			  if params[:downloadable][:viewable_id] == "All"
				object.viewable_type = 'Product'
				object.viewable_id = @product.id
			  else
				object.viewable_type = 'Variant'
				object.viewable_id = params[:downloadable][:viewable_id]
			  end
			else
			  object.viewable_type = 'Product'
			  object.viewable_id = @product.id
			end
		  end

		  destroy.before do 
			@viewable = object.viewable
		  end

		  destroy.response do |wants| 
			wants.html do
			  render :text => ""
			end
		  end

		  private

		  def load_data
            @product = Spree::Product.find_by_permalink(params[:product_id])
            raise "Product is #{params[:product_id]}. Product count #{@product.count}"
            @variants = @product.variants.collect do |variant|
              [variant.options_text, variant.id]
            end
            @variants.insert(0, [I18n.t(:all), @product.master.id])
          end
		end
	end
end
