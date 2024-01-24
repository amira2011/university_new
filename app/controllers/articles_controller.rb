class ArticlesController <  ApplicationController

    before_action :set_article, only: [:edit, :show, :update, :destroy]

    http_basic_authenticate_with name: "abid", password: "password", except: [:index, :show]
    
    def index
        @articles = Article.all
    end

    def show

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @article }
      end
      
    end

    def new
        @article = Article.new
      end
    
      def create
        @article = Article.new(article_params)
    
        if @article.save
          redirect_to articles_path , notice: 'Article was successfully created.'
        else
          render :new, status: :unprocessable_entity
        end
      end

    def edit
     end
    
    def update
     
        if @article.update(article_params)
          redirect_to articles_path 
        else
          render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
         @article.destroy
    
        redirect_to articles_path, status: :see_other
      end

    

    private 
    def article_params
        params.require(:article).permit(:title, :body , :status)
    end

    def set_article
      begin
      @article = Article.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to articles_path, notice: 'Article does not exist.'
      end
    end

end