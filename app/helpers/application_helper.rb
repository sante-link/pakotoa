module ApplicationHelper
  def abbr_subject(subject)
    if subject =~ /CN=(.*)\// then
      $1
    else
      subject
    end
  end
end
