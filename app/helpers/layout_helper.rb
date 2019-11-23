module LayoutHelper

  def title_bar(title)
    content_tag :div, class: 'title-bar' do
      html = content_tag :h2, title, class: 'title-bar--title'
      if block_given?
        html << content_tag(:div, yield, class: 'title-bar--actions')
      end
      html
    end
  end

end
