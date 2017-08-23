# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'
#
agent = Mechanize.new
#
# # Read in a page
base_url = "https://www.torontohousing.ca/about/our-housing/"

base_page = agent.get(base_url)

page_urls = base_page.at("#zz4_RootAspMenu").search("a").map do |a|
  a.attr("href")
end

page_urls.each do |url|
  page = agent.get(url)
  page.search("tr").each_with_index do |tr, index|
    next if index == 0
    record = {
      dev_id: tr.search("td").first.text,
      development_name:tr.search("td")[1].text,
      address: tr.search("td").last.text,
      area: page.at("#pageTitle").text.strip
    }
    ScraperWiki.save_sqlite([:dev_id], record)
  end
end
#
# # Find somehing on the page using css selectors
# p page.at('div.content')

#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
