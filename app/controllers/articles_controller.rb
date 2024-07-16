class ArticlesController < ApplicationController
    include ActionView::RecordIdentifier
  
    def show
      @article = Article.find(params[:id])
    end
  
    def index
      @articles = Article.all
    end
  
    def new
      @article = Article.new
    end
  
    def create
      @article = Article.new(article_params)
      respond_to do |format|
        if @article.save
          format.html { redirect_to @article, notice: 'Article was successfully created.' } # don't know if we need the flash/notice here
          format.turbo_stream { redirect_to @article, notice: 'Article was successfully created.' }
        else
          format.html { render :new }
          format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@article, :form), partial: "articles/form", locals: { article: @article }) }
        end
      end
    end
  
    private
  
    def article_params
      params.require(:article).permit(:title, :description)
    end
  end
  