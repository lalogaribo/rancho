module ApplicationHelper
  def gravatar_for(user, options = {size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
    image_tag(gravatar_url, alt: user.name, class: 'img-circle')
  end


  def calculate_weekly_production(racimo, ratio)
    racimo * ratio
  end

  def show_car(racimo, rat)
    if calculate_weekly_production(racimo, rat) > 1400
      '<i class="fa fa-truck" aria-hidden="true"></i>'.html_safe
    end
  end
end
