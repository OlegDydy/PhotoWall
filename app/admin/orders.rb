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
      input :user, label: 'admin.user_label'
      input :price, label: 'admin.price_label'
      input :in_image_url, as: :file, label: 'admin.input_label',
        input_html: { disabled: true }, hint: f.object.in_image_url.present? \
        ? image_tag(f.object.in_image_url.url(:thumb))
        : content_tag(:span, t('admin.no_input_image'))
      
      input :out_image_url, as: :file, hint: f.object.out_image_url.present? \
        ? image_tag(f.object.out_image_url.url(:thumb))
        : content_tag(:span, t('no_output_image'))
      
      input :active_admin_requested_event, 
        label: t('admin.state_label'), 
        as: :select, collection: f.object.aasm.events(permitted: true).map(&:name) unless f.object.aasm.events(permitted: true).empty?
    end
    actions
  end

  permit_params :active_admin_requested_event, :price, :out_image_url, :state

end
