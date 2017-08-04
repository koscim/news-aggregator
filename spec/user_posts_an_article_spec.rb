require "spec_helper"

feature "User posts an article", %(
  As a slacker
  I want to be able to submit an incredibly interesting article
  So that other slackers may benefit
  As a slacker
  I want to be able to visit a page that shows me all the submitted articles
  So that I can slack off
  As an errant slack
  I want to receive an error message
  When I submit an invalid article
  As a plagiarizing slacker
  I want to receive an error message
  When I submit an article that has already been submitted

  Acceptance Criteria:
  [X] When I visit the root path, I can see a form to submit an article
  [X] If I submit an article with an article title, URL, and description,
      I am sent to an "articles" page telling me that my article was
      successfully submitted and my article is saved to a CSV file
  [X] If I submit an article without an article title, I am sent to an
      "error" page telling me that my article was NOT successfully
      submitted and telling me an article title is needed
  [X] If I submit an article without a URL, I am sent to an "error"
      page telling me that my article was NOT successfully submitted and
      telling me a URL is needed
  [X] If I submit an article without a description, I am sent to an
      "error" page telling me that my article was NOT successfully
      submitted and telling me a description is needed
  [X] If I submit a blank form, I am sent to an "error" page telling me
      that my article was NOT successfully submitted and telling me
      that an article title, URL, and description is needed
) do
  before :each do
    CSV.open("articles.csv", "ab") do |csv|
      csv << ["Pigs are awesome", "http://www.pigsareawesome.com", "pigs are some cooolllllllll piggiesssssssss"]
    end
  end

  after :each do
    CSV.open("articles.csv", "wb") do |csv|
      csv << ["title", "url", "description"]
    end
  end

  scenario "user sees a form field for the article title, url, and description" do
    visit '/articles/new'
    expect(page).to have_field('title')
    expect(page).to have_field('url')
    expect(page).to have_field('description')
  end
  scenario "user submits an article with an article title, URL, and description" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'URL', with: 'http://www.borscht.com'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_link('http://www.borscht.com')
    expect(page).to have_content('Borscht Is Delicious http://www.borscht.com Borscht is delicious because it is.')
  end

  scenario "user clicks the link of a submitted article and is redirected to that site" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'URL', with: 'http://www.borscht.com'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_link('http://www.borscht.com')
    expect(page).to have_content('Borscht Is Delicious http://www.borscht.com Borscht is delicious because it is.')
    click_link 'http://www.borscht.com'
    expect(page).to have_current_path("http://www.borscht.com", url: true);

  end

  scenario "user submits an article without an article title" do
    visit '/articles/new'
    fill_in 'URL', with: 'http://www.borscht.com'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_content('Error! Must include title, URL, and description')
  end

  scenario "user submits an article without a URL" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_content('Error! Must include title, URL, and description')
  end

  scenario "user submits an article without a description" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'URL', with: 'http://www.borscht.com'
    click_button 'Submit'

    expect(page).to have_content('Error! Must include title, URL, and description')
  end

  scenario "user submits an empty form" do
    visit '/articles/new'
    click_button 'Submit'

    expect(page).to have_content('Error! Must include title, URL, and description')
  end

  scenario "user submits an article with an invalid url" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'URL', with: 'www.borscht.com'
    fill_in 'Description', with: 'Borscht is delicious because it is.'
    click_button 'Submit'

    expect(page).to have_content('Error! URL must include http')
  end

  scenario "user submits an article with a description that is less than 20 characters" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Borscht Is Delicious'
    fill_in 'URL', with: 'http://www.borscht.com'
    fill_in 'Description', with: 'Borscht is delish.'
    click_button 'Submit'

    expect(page).to have_content('Error! Description must be longer than 20 characters')
  end

  scenario "user submits an article that has already been added" do
    visit '/articles/new'
    fill_in 'Article Title', with: 'Pigs are awesome'
    fill_in 'URL', with: 'http://www.pigsareawesome.com'
    fill_in 'Description', with: 'pigs are some cooolllllllll piggiesssssssss'
    click_button 'Submit'

    expect(page).to have_content('Error! That article has already been submitted')
  end

end
