module Spree
	module Admin
		class DownloadablesController < Spree::Admin::BaseController
			resource_controller

		  respond_to :html

		  new_action.response do |wants|
			wants.html {render :action => :new, :layout => false}
		  end

		  create.response do |wants|
			wants.html {redirect_to admin_product_downloadables_url(@product)}
		  end
		  
		  create.failure.wants.html do
			render :action => :index
		  end

		  update.response do |wants|
			wants.html {redirect_to admin_product_downloadables_url(@product)}
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
		end
	end
end
