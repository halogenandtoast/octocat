module Octocat
  class CommandLine
    def initialize arguments
      @command = arguments.first
    end

    def run
      git_url = `git remote show -n origin | grep 'URL' | head -1`.chomp.split(": ", 2).last
      project = git_url.split(":", 2).last.gsub(/\.git$/, "")
      if @command == "open-branch"
        `open #{branch_url_for(project, current_branch)}`
      elsif @command == "new-pr"
        `open #{pr_url_for(project, current_branch)}`
      elsif @command == "open-pr"
        `open #{API.pull_request_url_for_branch(project, current_branch)}`
      end
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

    def branch_url_for(project, current_branch)
      "https://github.com/#{project}/tree/#{current_branch}"
    end

    def pr_url_for(project, branch)
      "https://github.com/#{project}/pull/new/#{current_branch}"
    end
  end
end
