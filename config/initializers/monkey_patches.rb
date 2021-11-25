# frozen_string_literal: true

ActionView::Helpers::DateTimeSelector.module_eval do
  include ActionView::Context

  ##
  # Monkey patching the #build_select method to add the outer Bulma div for
  # styling.
  #
  def build_select(type, select_options_as_html)
    select_options = {
      id: input_id_from_type(type),
      name: input_name_from_type(type)
    }.merge!(@html_options)
    select_options[:disabled] = 'disabled' if @options[:disabled]
    select_options[:class] = css_class_attribute(type, select_options[:class], @options[:with_css_classes]) if @options[:with_css_classes]

    select_html = "\n".dup
    select_html << content_tag('option', '', value: '') + "\n" if @options[:include_blank]
    select_html << prompt_option_tag(type, @options[:prompt]) + "\n" if @options[:prompt]
    select_html << select_options_as_html

    content_tag(:div, class: 'select') do
      content_tag('select', select_html.html_safe, select_options) + "\n"
    end.html_safe
  end
end
