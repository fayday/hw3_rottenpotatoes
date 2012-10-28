# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
	Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = /#{e1}.*#{e2}/m

  within('#movies') do
   # assert page.has_content?(regexp)	
    assert page.has_xpath?('//*', :text => regexp)	
  end
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.gsub(/,/, ' ').split
  if uncheck
    ratings.each do |rating|
      step %Q{I uncheck "ratings_#{rating}"}
    end
  else
    ratings.each do |rating|
      step %Q{I check "ratings_#{rating}"}
    end
  end  
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

Then /^(?:|I )should see movies with the following ratings: (.*)/ do |rating_list|
  ratings = rating_list.gsub(/,/, ' ').split
  ratings.each do |rating|
    step %Q{I should see /#{rating}/}
  end  
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  regexp = /\A#{regexp}/

  if page.respond_to? :should
    page.should have_xpath('//tbody/tr/td', :text => regexp)
  else
    assert page.has_xpath?('//tbody/tr/td', :text => regexp)
  end
end

Then /^(?:|I )should not see movies with ratings: (.*)/ do |rating_list|
  ratings = rating_list.gsub(/,/, ' ').split
  ratings.each do |rating|
    step %Q{I should not see /#{rating}/}
  end
end


Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  regexp = /\A#{regexp}/

  if page.respond_to? :should
    page.should have_no_xpath('//tbody/tr/td', :text => regexp)
  else
    assert page.has_no_xpath?('//tbody/tr/td', :text => regexp)
  end
end

Then /^(?:|I )should not see any movie$/ do
  count_tr = []
  within('#movies') do
    count_tr = page.all(:xpath, '//tbody/tr')
  end     
  assert count_tr.length == 0   
end

Then /^(?:|I )should see all movies$/ do
  count_rows = []
  Movie.all.each do |el|
    count_rows << el.id
  end
 
  count_tr = []
  within('#movies') do
    count_tr = page.all(:xpath, '//tbody/tr')
  end
     
  assert count_tr.length == count_rows.length
end

Then /^(?:|I )should see movies sorted ascendingly by: (.*)/ do |order|
  dump = []
  Movie.order("#{order} ASC").all.each do |el|
    dump << el.title
  end

  i=0
  until i == dump.length - 1
    step %Q{I should see "#{dump[i]}" before "#{dump[i+1]}"}
    i += 1
  end
end  
  
  
