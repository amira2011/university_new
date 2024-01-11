class PagesController < ApplicationController

    def index



    end

    def github

        if params[:repo].present?

            @repos= Utils.get_git_repo(params[:repo])
             
     
         end

    end
end