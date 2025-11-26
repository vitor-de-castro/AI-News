class ArticlesController < ApplicationController

  def index

    Article.all
    @articles = Article.where(category: params[:category])

    @chat = Chat.new
  end

  # def show
  #   @article = Article.find(params[:id])
  #   @latest_articles = Article.order(created_at: :desc).limit(10)
end
