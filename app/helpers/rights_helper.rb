module RightsHelper

  def rights_link(config)
  	 link_to config[:url], title: config[:name], alt: config[:name] do
    	image_tag config[:image_url], class: "img-fluid"
  	end
  end

  def rights_block(config)
    linked_url = link_to config[:url]
    arr = [config[:text], " ", linked_url]
    content_tag :p do
      content_tag :label, "Standardized Rights Statement:", class: "label label-default"
      arr.each do |item|
        concat content_tag :span, item
      end
    end
  end

end