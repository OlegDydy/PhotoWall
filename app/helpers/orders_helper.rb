module OrdersHelper
  def order_image_tag(order)
    if (order.ready?)
      # replace original image with artwork
      return image_tag('NoImage.png') if order.out_image_url.file.nil?
      if ( order.paid? )
        image_tag(order.out_image_url.url(:thumb), full_size: order.out_image_url)
      else
        image_tag(order.out_image_url.url(:thumb))
      end
    else
      # put uploaded image
      return image_tag('NoImage.png') if order.in_image_url.file.nil?
      image_tag(order.in_image_url.url(:thumb), full_size: order.in_image_url )
    end
  end
end
