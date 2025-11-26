class ArticlesController < ApplicationController

  def index
    @chat = Chat.new
    if params[:category].present?
     @articles = Article.where(category: params[:category])
    else
      @articles = Article.all
    end
  end

  # def show
  #   @article = Article.find(params[:id])
  #   @latest_articles = Article.order(created_at: :desc).limit(10)
end
