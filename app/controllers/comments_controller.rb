class CommentsController < ApplicationController

    def create
        puts params.inspect
        @article = Article.find(params[:article_id])
        @comment = @article.comments.create(comment_params)
        redirect_to article_path(@article)
      end

      def destroy
        puts params.inspect

        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        @comment.destroy
        redirect_to article_path(@article), status: :see_other
      end


      private
      def comment_params
        params.require(:comment).permit(:commenter, :body, :status)
      end
end
