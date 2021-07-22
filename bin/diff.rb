#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'
require 'pry'

# from https://stackoverflow.com/questions/1791639/converting-upper-case-string-into-title-case-using-ruby
class String
  def titlecase
    split(/([[:alpha:]]+)/).map(&:capitalize).join
  end
end

class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [->(val, field) { field.header == :position ? val.to_s.titlecase : val }] }
  end

  def external_csv_options
    { converters: [->(val, field) { field.header == :position ? val.to_s.titlecase : val }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
