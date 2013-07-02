# -*- encoding : utf-8 -*-

class ClParser

	DEFAULT = {
		cookie: "",
		concurrency: 15,
		query: "",
		out: ""
	}

	def initialize args=nil
		@args = DEFAULT

		if !args.nil?
			parse args 
		end
	end

	def parse args
		return if args.count < 1

		print_help if args[0] == "--help"

		args.select { |a| a.start_with? "--" }.each do |key| 
			index = args.index key
			value = args[index+1]
			@args[key.gsub("--","").to_sym] = value
		end
	end

	def get arg
		@args[arg]
	end

	private

	def print_help
		puts "--query \"query\" \t=> especifica query da busca"
		puts "\tformato da query: (((termo) AND \"Campo\":termo2)) OR termo3)"
		puts "\texemplos de campos disponíveis: \"Publication Title\", \"Authors\""
		puts "--concurrency concurrency_level \t=> especifica o nível de concorrência (requisições/downloads a serem feitos ao mesmo tempo). Default: 15"
		puts "--cookie \t=> especifica cookie a ser utilizado nas requisições"
		puts "--out \t=> especifica pasta para output (necessita ser uma pasta existente)"
		puts "\nexemplo: --query \"(((fpga) AND reconfigurable) AND \"Publication Title\": reconfig)\" --concurrency 20 --cookie \"cookie\" --out \"artigos/\""
		exit!
	end
end