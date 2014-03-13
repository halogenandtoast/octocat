module Octocat
  class CommandLine
    COMMANDS = %w(open-branch new-pr open-pr compare-branch help)

    def initialize arguments
      @command = arguments.first
      @api = API.new
    end

    def run
      git_url = `git remote show -n origin | grep 'URL' | head -1`.chomp.split(": ", 2).last
      project = git_url.split(":", 2).last.gsub(/\.git$/, "")
      if @command == "open-branch"
        api.open_branch(project, current_branch)
      elsif @command == "new-pr"
        api.new_pr(project, current_branch)
      elsif @command == "open-pr"
        api.open_pr(project, current_branch)
      elsif @command == "compare-branch"
        api.compare_branch(project, current_branch)
      elsif @command == "help"
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

    attr_reader :api
  end
end
