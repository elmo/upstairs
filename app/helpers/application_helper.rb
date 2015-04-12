module ApplicationHelper

  def footer
    ['home'].include?(controller_name) ? narrow_footer : narrow_footer
  end

  def big_footer
    render partial: '/layouts/big_footer'
  end

  def narrow_footer
    render partial: '/layouts/narrow_footer'
  end

end
