class PagesController < ApplicationController

    $repos = nil
    def index

    end

    def github
        if params[:repo].present?
            @repos = Utils.get_git_repo(params[:repo])
            $repos = @repos
        end
    end

    def show
        @id=  params[:id].to_i
        @repos = $repos
        @repos.each do |repo| 
        if repo["id"] == @id
            @repo_name = repo["name"]
            @userName = repo["owner"]["login"]
            @stargazers_count = repo["stargazers_count"]
            @description = repo["description"]
            @watchers_count = repo["watchers_count"]
            @forks_count = repo["forks_count"]
            lang = "https://api.github.com/repos/#{@userName}/#{@repo_name}/languages"
            #@languages =  Utils.get_languages(lang)  
            @languages =  Utils.get_uri_data(lang)  
            prClosedUri = "https://api.github.com/repos/#{@userName}/#{@repo_name}/pulls?state=closed";
            puts "pre closed uri  #{prClosedUri} "
            @prClosedUri = Utils.get_uri_data(prClosedUri)
            prOpenUri = "https://api.github.com/repos/#{@userName}/#{@repo_name}/pulls?state=open"
            issuesOpenUri = "https://api.github.com/repos/#{@userName}/#{@repo_name}/issues?state=open"
            issuesClosedUri = "https://api.github.com/repos/#{@userName}/#{@repo_name}/issues?state=closed"
            @prOpenUri = Utils.get_uri_data(prOpenUri)
            @issuesOpenUri = Utils.get_uri_data(issuesOpenUri)
            @pissuesClosedUri = Utils.get_uri_data(issuesClosedUri)
        end
        end
        

    end
end