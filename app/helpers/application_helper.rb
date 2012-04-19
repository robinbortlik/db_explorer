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
  
  
  def setup_search_form(builder)
    content_for :document_ready, %Q{
      var search = new Search();
      $('a.add_fields').live('click', function() {
        search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
        return false;
      });
      $('a.remove_fields').live('click', function() {
        search.remove_fields(this);
        return false;
      });
    }.html_safe
  end

  def button_to_remove_fields(name, f, title = nil)
    content_tag :a, name, class: 'remove_fields', :title => title
  end

  def button_to_add_fields(name, f, type, title = nil)
    new_object = f.object.send "build_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: "new_#{type}") do |builder|
      render("/search/" + type.to_s + "_fields", f: builder)
    end
    content_tag :a, name, :class => 'add_fields', :title => title, 'data-field-type' => type, 'data-content' => "#{fields}"
  end
    
end
