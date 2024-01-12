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
                @forks_count =repo["forks_count"]

                url = "https://api.github.com/repos/#{@userName}/#{@repo_name}/languages"
                  


                
                puts "languages #{url} username =#{@userName} reponame = #{@repo_name} "
 
                @languages =  Utils.get_languages(url)
                puts "languages #{  @languages}"
                


            end

              
           
        end
        

    end
end