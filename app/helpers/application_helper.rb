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

  def calculate_sales(price, boxes)
    sale = price * boxes
    sale.round(2)
  end

  def show_car(racimo, rat)
    if calculate_weekly_production(racimo, rat) > 1400
      '<i class="fa fa-truck" aria-hidden="true"></i>'.html_safe
    end
  end

  def options_from_collection_for_select_with_data(collection, value_method, text_method, selected = nil, data = {})
    options = collection.map do |element|
      [element.send(text_method), element.send(value_method), data.map do |k, v|
        {"data-#{k}" => element.send(v)}
      end
      ].flatten
    end
    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

    options_for_select(options, select_deselect)
  end

  def workersUser
    Worker.where(:user_id => current_user)
  end
end
