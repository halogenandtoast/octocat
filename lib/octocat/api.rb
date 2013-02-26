require 'json'
require 'open-uri'

module Octocat
  class API
    API_ROOT_URL = 'https://api.github.com/'

    def self.pull_requests(project)
      password = `/usr/bin/security find-internet-password -g -a halogenandtoast -s github.com -w`.chomp
      connection = open("#{API_ROOT_URL}repos/#{project}/pulls", http_basic_authentication: ["halogenandtoast", password])
      JSON.parse(connection.read)
    end

    def self.pull_request_url_for_branch(project, branch)
      current_pull_requests = pull_requests(project)
      pull_request = current_pull_requests.detect { |pr| pr["head"]["ref"] == branch }
      pull_request["html_url"]
    end
  end
end
