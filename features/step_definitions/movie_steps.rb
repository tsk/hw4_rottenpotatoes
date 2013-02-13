# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.index(e2), "Wrong Order"
end
Then /I should (not )?see movies rated: (.*)/ do |check,rating_list|
    #puts rating_list.inspect
    #puts page.body.length
    ratings = rating_list.split(",")
    #puts page.body.count(ratings[0])
    #puts page.body
    #puts page
    if(check)
        ratings.each do |rating| 
            page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr[td = \"#{rating}\"]) = 0]")
        end
    else
        db_size = Movie.find(:all, :conditions => {:rating => ratings}).size
        page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
    end
end

Then /the director of "(.*)" should be "(.*)"/ do |movie, director|
    m = Movie.find_by_title(movie)
    assert director == m.director
end

Then /I should see all of the movies/ do
    movies = Movie.all
    movies.each do |movie|
        assert page.body =~/#{movie.title}/m, "#{movie.title} not found."
    end
end

Then /I should not see any movies/ do
    movies = Movie.all
    movies.each do |movie|
        assert true unless page.body =~/#{movie.title}/m
    end
end

#Given /I am on the details page for "(.*)"/ do |movie|
#    @movie = Movie.find_by_title(movie)
#    assert @movie.title == movie
#end

When /I (un)?check all ratings/ do |uncheck|
    if(uncheck)
        "PG-13,G,R,PG".split(",").each do |rating|
            uncheck('ratings['+rating+']')
        end
    else
        "PG-13,G,R,PG".split(",").each do |rating|
            check('ratings['+rating+']')
        end
    end
end
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
      rating = "ratings["+rating+"]"
      if uncheck
          uncheck(rating)
      else
          check(rating)
      end
  end
end
