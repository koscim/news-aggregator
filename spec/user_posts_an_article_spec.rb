require "spec_helper"

feature "User posts an article", %(
  As a slacker
  I want to be able to submit an incredibly interesting article
  So that other slackers may benefit

  Acceptance Criteria:
  [X] When I visit the root path, I can see a form to submit an article
  [X] If I submit an article with an article title, URL, and description,
      I am sent to an "articles" page telling me that my article was
      successfully submitted and my article is saved to a CSV file
  [ ] If I submit an article without an article title, I am sent to an
      "error" page telling me that my article was NOT successfully
      submitted and telling me an article title is needed
  [ ] If I submit an article without a URL, I am sent to an "error"
      page telling me that my article was NOT successfully submitted and
      telling me a URL is needed
  [ ] If I submit an article without a description, I am sent to an
      "error" page telling me that my article was NOT successfully
      submitted and telling me a description is needed
  [ ] If I submit a blank form, I am sent to an "error" page telling me
      that my article was NOT successfully submitted and telling me
      that an article title, URL, and description is needed
) do

  scenario "user submits an article with an article title, URL, and description" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'URL', with: 'http://www.borscht.com'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_content('Borscht Is Delicious http://www.borscht.com Borscht is delicious because it is.')
  end
  scenario "user submits an article without an article title" do
    visit '/articles/new'
    fill_in 'URL', with: 'http://www.borscht.com'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_content('Error')

  end

end
