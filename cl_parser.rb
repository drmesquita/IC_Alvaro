# -*- encoding : utf-8 -*-

class ClParser

	DEFAULT = {
		cookie: "__gads=ID=7fa00c658b5a8f42:T=1367873830:S=ALNI_Ma49AvYki8A-QXdgdOLwGLZVNQjVw; unicaID=Jgl1y6BRnOZ-YFF5K8A; __atuvc=0%7C22%2C0%7C23%2C0%7C24%2C2%7C25%2C3%7C26; WLSESSION=857891468.20480.0000; visitstart=21:44; JSESSIONID=fTMNRLgLHsRMkR23jWLHRBW21CQNnGHSd26TpWzftWMYx0LRk9yK!2028994074; WT_FPC=id=27bc846362786308ed91372108884125:lv=1372113871054:ss=1372108884125; ipCheck=200.131.199.27; ERIGHTS=a2XeQrHnqJ1jCXix2BRdHMQf9UDJ972JGL*a9rJJjxxGBjVMNXJbNZJTyAx3Dx3D-18x2dfzloVZaY72rsoix2BefrHXeAx3Dx3Dmssr5cG31pVgg4sjNPgVEwx3Dx3D-PAOjt399QMWc5gozijFQpQx3Dx3D-7Csfl0x2FdL9vmkk7wFPYbagx3Dx3D; seqId=29017; xploreCookies=eyJpc01lbWJlciI6ImZhbHNlIiwiaXNJbnN0IjoidHJ1ZSIsImlzQ29udGFjdEVtYWlsRW5hYmxlZCI6ImZhbHNlIiwiY29udGFjdEZheCI6Ik5BIiwib3BlblVybFR4dCI6Ik5BIiwiY29udGFjdFBob25lIjoiTkEiLCJ1c2VySWRzIjoiMjkwMTciLCJlbnRlcnByaXNlTGljZW5zZUlkIjoiMCIsIm9wZW5VcmwiOiJodHRwOi8vbGluay5wZXJpb2RpY29zLmNhcGVzLmdvdi5ici9zZnhsY2w0MSIsImNvbnRhY3RFbWFpbCI6Ik5BIiwiaXNJcCI6InRydWUiLCJpc0NpdGVkQnlFbmFibGVkIjoidHJ1ZSIsInJvYW1pbmdUb2tlbiI6Imx0dVZzQTk3K1IvTWRWNWFOWW40aFUrMFRtZjNSSE9pZW9NNGFtTHZxOVE9IiwiaXNDaGFyZ2ViYWNrVXNlciI6ImZhbHNlIiwiaXNDb250YWN0UGhvbmVFbmFibGVkIjoiZmFsc2UiLCJzdGFuZGFyZHNMaWNlbnNlSWQiOiIwIiwib3BlblVybEltZ0xvYyI6Imh0dHA6Ly9saW5rLnBlcmlvZGljb3MuY2FwZXMuZ292LmJyL3NmeGxjbDQxL3NmeC5naWYiLCJpc0NvbnRhY3ROYW1lRW5hYmxlZCI6ImZhbHNlIiwiaW5zdE5hbWUiOiJVTklWRVJTSURBREUgRkVERVJBTCBERSBVQkVSTEFORElBIiwiaXNDb250YWN0RmF4RW5hYmxlZCI6ImZhbHNlIiwiZGVza3RvcFJlcG9ydGluZ1VybCI6Im51bGwiLCJwcm9kdWN0cyI6IklFTHxWREV8IiwiY3VzdG9tZXJTdXJ2ZXkiOiJOQSIsImlzRGVsZWdhdGVkQWRtaW4iOiJmYWxzZSIsImluc3RJbWFnZSI6IiIsIm9sZFNlc3Npb25LZXkiOiJhMlhlUXJIbnFKMWpDWGl4MkJSZEhNUWY5VURKOTcySkdMKmE5ckpKanh4R0JqVk1OWEpiTlpKVHlBeDNEeDNELTE4eDJkZnpsb1ZaYVk3MnJzb2l4MkJlZnJIWGVBeDNEeDNEbXNzcjVjRzMxcFZnZzRzak5QZ1ZFd3gzRHgzRC1QQU9qdDM5OVFNV2M1Z296aWpGUXBReDNEeDNELTdDc2ZsMHgyRmRMOXZta2s3d0ZQWWJhZ3gzRHgzRCIsImNvbnRhY3ROYW1lIjoiTkEiLCJzbWFsbEJ1c2luZXNzTGljZW5zZUlkIjoiMCJ9",
		concurrency: 15,
		query: ""
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
		puts "\nexemplo: --query \"(((fpga) AND reconfigurable) AND \"Publication Title\": reconfig)\" --concurrency 20 --cookie \"cookie\""
		exit!
	end
end