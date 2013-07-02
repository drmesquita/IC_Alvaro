# -*- encoding : utf-8 -*-

require 'typhoeus'
require 'nokogiri'

class Crawler
	IEEEX_URL = "http://ieeexplore.ieee.org/search/searchresult.jsp"

	def initialize concurrency, output_folder, cookie
		@params = {
			reload: true,
  			rowsPerPage: 100,
  			queryText: "",
  		}

  		@cookie = cookie || ""
  		@output_folder = output_folder

  		@hydra = Typhoeus::Hydra.new(max_concurrency: concurrency)
	end

	def set_param key, value
		@params[key] = value
	end

	def crawl
		initial_response = build_request.run
		nodeset = Nokogiri::HTML(initial_response.body)
		
		n_results = get_n_results(nodeset)
		puts n_results.to_s + "results found"
		
		n_pages = get_n_pages(n_results)
		process_result_page(nodeset)

		2.upto(n_pages) do |p|
			request = build_request p
			request.on_complete do |response|
				process_result_page(Nokogiri::HTML(response.body))
			end
			@hydra.queue request
		end

		@hydra.run
	end

	private

	def build_request page_number=1
		Typhoeus::Request.new(
		  IEEEX_URL,
		  params: @params.merge({pageNumber: page_number}),
		  headers: { 
		  	Accept: "text/html",
		  }
		)
	end

	def get_n_results nodeset
		nodeset.css(".results-returned").text.strip.split(' ').first.to_i
	end

	def get_n_pages n_results
		 (n_results.to_f / @params[:rowsPerPage]).ceil
	end

	def process_result_page nodeset
		nodeset.css(".detail").each do |result|
			title = result.children.css("h3").text.strip
			link = (result.children.css(".links a").find {|a| a.text.strip == "PDF" })['href']
			#puts link
			arnumber = link[/.*arnumber=([^\&]*)/,1]
			
			puts "Queueing \"#{title}\""

			request_pdf_page arnumber
		end
	end

	def request_pdf_page arnumber
		request = Typhoeus::Request.new(
			"http://ieeexplore.ieee.org/stamp/stamp.jsp",
			params: { reload: true, arnumber: arnumber },
			headers: { 
			  Accept: "text/html",
			  Cookie: @cookie
			 }
		)
		#puts arnumber

		request.on_complete do |response|
			#puts response.body
			url = Nokogiri::HTML(response.body).css("html frameset frame[src]")[1]['src']
			filename = @output_folder + url[/.*\/([^\.pdf]*)/,1] + ".pdf"

			request_pdf url, filename
		end

		@hydra.queue request
	end

	def request_pdf url, filename
		request = Typhoeus::Request.new(
			url,
			headers: { 
			  Accept: "text/html",
			  Cookie: @cookie
			 }
		)

		request.on_complete do |response|
			open(filename, "wb") do |file|
				file.write(response.body)
			end

			puts filename + " downloaded."
		end

		@hydra.queue request
	end
end