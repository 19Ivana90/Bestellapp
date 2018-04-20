module BootstrapHelper
  def labeled_icon(icon, label)
    content_tag(:span, nil, class: "glyphicon glyphicon-#{icon}") +
      "&nbsp;#{label}".html_safe
  end

  def link_button(label, url, size: nil, options: {})
    options[:class] ||= ''
    options[:class] << ' btn'
    options[:class] << ' btn-default' unless options[:class] =~ /btn-(primary|success|info|warning|danger|link)/
    options[:class] << " btn-#{size}" if size.present?

    link_to(label, url, options)
  end

  def link_button_with_icon(label, icon, url, size: nil, options: {})
    text = %(<span class="glyphicon glyphicon-#{icon}"></span>)
    text << "<span>#{label}</span>" if label.present?

    link_button(text.html_safe, url, size: size, options: options)
  end

  def button_with_icon(label, icon, size: nil, options: {})
    options[:class] ||= ''
    options[:class] << ' btn'
    options[:class] << ' btn-default' unless options[:class] =~ /btn-(primary|success|info|warning|danger|link)/
    options[:class] << " btn-#{size}" if size.present?

    options.reverse_merge!(type: 'button')

    text = %(<span class="glyphicon glyphicon-#{icon}"></span>)
    text << "<span>#{label}</span>" if label.present?

    content_tag(:button, text.html_safe, options)
  end

  def horizontal_form_options
    {
      :html => { :class => 'form-horizontal' },
      :wrapper => :horizontal_form,
      :wrapper_mappings => {
        :check_boxes => :horizontal_radio_and_checkboxes,
        :radio_buttons => :horizontal_radio_and_checkboxes,
        :file => :horizontal_file_input,
        :boolean => :horizontal_boolean
      }
    }
  end
end
