module CommunitiesHelper

 def address(community,delimitter = "<br>")
  a = []
  a << community.address_line_one
  a << community.address_line_two if community.address_line_two.present?
  a << "<br>" + community.city + "," + community.state + "  " + community.postal_code
  a.join(delimitter).html_safe
 end

end
