module ApplicationHelper
  def status_image(status)
    image = "link_icons/cross.png"
    if status.is_a? TrueClass
      image = "link_icons/tick.png" if status
    else
      case status
      when String
        image = "link_icons/tick.png" if status.downcase == 'active'
      else
        image = "link_icons/tick.png" if status
      end
    end
    image_tag image
  end  
end
