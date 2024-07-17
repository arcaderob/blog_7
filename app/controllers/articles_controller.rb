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
  
    def edit
      @article = Article.find(params[:id])
    end
  
    def update
        @article = Article.find(params[:id])
        respond_to do |format|
            if @article.update(article_params)
                handle_successful_save(format, 'Article was successfully updated.')
            else
                handle_failed_save(format)
            end
        end
    end
  
    def destroy
      @article = Article.find(params[:id])
      @article.destroy
      respond_to do |format|
        format.html { redirect_to articles_path, notice: 'Article was successfully deleted.' }
      end
    end
  
    def create
      @article = Article.new(article_params)
      respond_to do |format|
        if @article.save
            handle_successful_save(format, 'Article was successfully created.')
        else
            handle_failed_save(format)
        end
      end
    end
  
    private
  
    def article_params
      params.require(:article).permit(:title, :description)
    end

    def handle_successful_save(format, message)
        format.html { redirect_to @article, notice: message }
        format.turbo_stream { render 'shared/redirect', locals: { article: @article } }
    end
    
    def handle_failed_save(format)
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@article, :form), partial: "articles/form", locals: { article: @article }) }
    end
  end
  