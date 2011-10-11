module ProjectAccessHelper
  # based on ApplicationHelper#principals_check_box_tags
  def users_check_box_tags(name, principals)
    s = ''
    principals.sort.each do |principal|
      s << "<label>#{ check_box_tag name, principal.id, false } #{h principal}</label>\n<br/>\n"
    end
    s.html_safe
  end
end

