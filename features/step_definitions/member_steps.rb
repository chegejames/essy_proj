def path_to(page_name)
  case page_name

  when /^members page/
    members_path
  end
end

Given(/^I am on the "(.*?)"$/) do |page|
  path_to(page)

end

Given(/^I follow "(.*?)"$/) do |link|
  click_link(link)
end

Then(/^I should see "(.*?)"$/) do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end
