module ApplicationHelper

  def flash_class(level)
    case level
      when :notice then "info"
      when :error then "error"
      when :alert then "warning"
    end
  end

  def icon(icon_type)
    content_tag(:i, '', :class => "icon-#{icon_type}")
  end

  def search_conditions_count(search_hash = {})
    count = 0
    count += search_hash[:c].keys.count if search_hash[:c]
    count += search_hash[:s].keys.count if search_hash[:s]
  end

  def setup_search_form(builder)
    content_for :document_ready, %Q{
      var search = new Search();
      $(document).on('click', 'a.add_fields', function() {
        search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
        return false;
      });
      $(document).on('click', 'a.remove_fields', function() {
        search.remove_fields(this);
        return false;
      });
    }.html_safe
  end

  def button_to_remove_fields(name, f, title = nil)
    content_tag :a, name, class: 'remove_fields btn btn-mini btn-danger', :title => title
  end

  def button_to_add_fields(name, f, type, title = nil)
    new_object = f.object.send "build_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: "new_#{type}") do |builder|
      render("/search/" + type.to_s + "_fields", f: builder)
    end
    content_tag :a, name, :class => 'add_fields btn btn-mini btn-primary', :title => title, 'data-field-type' => type, 'data-content' => "#{fields}"
  end

  def format_value(value)
    case value
    when String then truncate(value, :length => 40)
    else
      value
    end
  end

  def get_per_page(connection_id, name)
    key = "search_#{connection_id}_#{name}_per_page"
    session[key] || Kaminari.config.default_per_page
  end

end
