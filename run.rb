# -*- encoding : utf-8 -*-

require File.dirname(File.expand_path(__FILE__))+"/crawler.rb"
require File.dirname(File.expand_path(__FILE__))+"/cl_parser.rb"

cl_args = ClParser.new ARGV

crawler = Crawler.new cl_args.get(:concurrency), cl_args.get(:cookie)
crawler.set_param :queryText, cl_args.get(:query)
crawler.crawl