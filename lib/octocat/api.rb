require 'json'
require 'open-uri'

module Octocat
  class API
    API_ROOT_URL = 'https://api.github.com/'

    def pull_requests(project)
      password = `/usr/bin/security find-internet-password -g -a halogenandtoast -s github.com -w`.chomp
      connection = open("#{API_ROOT_URL}repos/#{project}/pulls", http_basic_authentication: ["halogenandtoast", password])
      JSON.parse(connection.read)
    end

    def new_pr(project, current_branch)
      `open #{pr_url_for(project, current_branch)}`
    end

    def open_pr(project, current_branch)
      `open #{pull_request_url_for_branch(project, current_branch)}`
    end

    def open_branch(project, current_branch)
      `open #{branch_url_for(project, current_branch)}`
    end

    def compare_branch(project, current_branch)
      `open #{compare_url_for_branch(project, current_branch)}`
    end

    private

    def pull_request_url_for_branch(project, branch)
      current_pull_requests = pull_requests(project)
      pull_request = current_pull_requests.detect { |pr| pr["head"]["ref"] == branch }
      if pull_request
        pull_request["html_url"]
      else
        print "No pull request for #{branch}. Create one now? [Y/n]"
        response = $stdin.gets.chomp
        unless response.downcase == "n"
          new_pr(project, branch)
        end
      end
    end

    def base_url
      "https://github.com"
    end

    def pr_url_for(project, branch)
      "#{base_url}/#{project}/pull/new/#{branch}"
    end

    def branch_url_for(project, branch)
      "#{base_url}/#{project}/tree/#{branch}"
    end


    def compare_url_for_branch(project, branch)
      "#{base_url}/#{project}/compare/master...#{branch}"
    end
  end
end
