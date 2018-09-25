class Order < ApplicationRecord
  include AASM

  aasm :column => :state do
    state :new, :initial => true
    state :priced
    state :wip
    state :completed
    state :paid

    # forward
    event :set_price do
      transitions :from => [:new], :to => :priced
    end

    event :accept_price do
      transitions :from => [:priced], :to => :wip
    end

    event :mark_as_completed do
      transitions :from => [:wip], :to => :completed
    end

    event :pay_for do
      transitions :from => [:completed], :to => :paid
    end

    #backward
    event :reject_work do
      transitions :from => [:completed], :to => :wip
    end
  end
end