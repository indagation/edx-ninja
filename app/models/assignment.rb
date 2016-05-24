class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :submissions

  def description
    if display_name.present?
      display_name
    elsif resource_link_id.present?
      resource_link_id
    else
      "Not known"
    end
  end

  def due_date_string
    if due_date.present?
      due_date.strftime("%m/%d/%y %H:%M %Z")
    else
      "Not Set"
    end
  end

  def absolute_due_date
    if graceperiod.present?
      due_date + graceperiod
    else
      due_date
    end
  end    

  def absolute_due_date_string
    if absolute_due_date.present?
      absolute_due_date.strftime("%m/%d/%y %H:%M %Z")
    else
      "Not Set"
    end
  end

  def graceperiod_string
    if graceperiod.present?
      "#{graceperiod} seconds"
    else
      "Not Set"
    end
  end  
end
