ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|label|textarea|select)/
    error_class = 'error'

    doc = Nokogiri::XML(html_tag)
    doc.children.each do |field|
      unless field['type'] == 'hidden'
        unless field['class'] =~ /\berror\b/
          field['class'] = "#{field['class']} error".strip
        end
      end
    end

    doc.to_html.html_safe
  else
    html_tag
  end
end