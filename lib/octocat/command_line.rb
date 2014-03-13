require 'uri'

module Octocat
  class CommandLine
    COMMANDS = %w(open-branch new-pr open-pr compare-branch help)

    def initialize arguments
      @command = arguments.first
      @api = API.new
    end

    def run
      if command
        run_command
      else
        puts "Octocat Version #{VERSION}"
        help
      end
    end

    def run_command
      if command == "open-branch"
        api.open_branch(project, current_branch)
      elsif command == "new-pr"
        api.new_pr(project, current_branch)
      elsif command == "open-pr"
        api.open_pr(project, current_branch)
      elsif command == "compare-branch"
        api.compare_branch(project, current_branch)
      elsif command == "help"
        help
      else
        puts "Unknown Command. The known commands are:"
        help
      end
    end

    def help
      COMMANDS.each do |command|
        puts "- #{command}"
      end
      puts
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

    private

    attr_reader :api, :command

    def git_url
      @git_url ||= `git remote show -n origin | grep 'URL' | head -1`.chomp.split(": ", 2).last
    end

    def project
      @project ||= get_project
    end

    def get_project
      if git_url.include? "@"
        git_url.split(":", 2).last.gsub(/\.git$/, "")
      else
        URI(git_url).path[1..-1].gsub(/\.git$/, "")
      end
    end

  end
end
