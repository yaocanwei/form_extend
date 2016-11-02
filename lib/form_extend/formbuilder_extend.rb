require "form_extend/locales"

module FormExtend
  class FormbuilderExtend < ActionView::Helpers::FormBuilder
    include FormExtend::I18n
    (field_helpers.map(&:to_s) - %w(radio_button hidden_field fields_for check_box label) + 
      %w(date_select)).each do|selector|
      class_eval <<-READER, __FILE__, __LINE__
        def #{selector}(field, options={})
          label_field(field, options) + super(field, options.except(:label)).html_safe
        end
      READER

    end

    def check_box(field, options={}, checked_value="1", unchecked_value="0")
      label_field(field, options) + super(field, options.except(:label), checked_value, unchecked_value).html_safe
    end

    def select(field, choices, options = {}, html_options = {})
      label_field(field, options) + super(field, choices, options, html_options.except(:label)).html_safe
    end

    def time_zone_select(field, priority_zones = nil, options = {}, html_options = {})
      label_field(field, options) + super(field, priority_zones, options, html_options.except(:label)).html_safe
    end


    def label_field(field, options = {})
      return ''.html_safe if options.delete(:no_label)
      text = options[:label].is_a?(Symbol) ? locales(options[:label]) : options[:label]
      text ||= locales(("field_" + field.to_s.gsub(/\_id$/, "")).to_sym)
      text += @template.content_tag("span", " *", :class => "required") if options.delete(:required)
      @template.content_tag("label", text.html_safe,
                                     :class => (@object && @object.errors[field].present? ? "error" : nil),
                                     :for => (@object_name.to_s + "_" + field.to_s))
    end
  end
end