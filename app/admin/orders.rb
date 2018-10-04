ActiveAdmin.register Order do

  scope :all
  scope :waiting
  scope :priced
  scope :work_in_progress
  scope :completed
  scope :paid
  scope :canceled

  after_save do |order|
    event = params[:order][:active_admin_requested_event]
    unless event.blank?
      safe_event = (order.aasm.events(permitted: true).map(&:name) & [event.to_sym]).first
      raise t('admin.forbidden',event: event, id: order.id) unless safe_event
      order.send("#{safe_event}!")      
    end
  end

  form do |f|
    inputs do
      input :user, label: t('admin.user_label'),
        as: :select, collection: User.all.map{|user| [user.email, user.id]}
      input :description, input_html: { readOnly: true }
      input :price, label: t('admin.price_label')
      
      li do
        label t('admin.input_label')
        if f.object.in_image_url.present?
          a href: f.object.in_image_url do
            img src: f.object.in_image_url.url(:thumb)
          end
        else
          span t('admin.no_input_image')
        end
      end
      
      input :out_image_url, as: :file, hint: f.object.out_image_url.present? \
        ? image_tag(f.object.out_image_url.url(:thumb))
        : content_tag(:span, t('no_output_image'))
      
      input :active_admin_requested_event, 
        label: t('admin.state_label'), 
        as: :select, collection: f.object.aasm.events(permitted: true).map(&:name) unless f.object.aasm.events(permitted: true).empty?
    end
    actions
  end

  permit_params :user_id, :active_admin_requested_event, :price, :out_image_url, :state

end
