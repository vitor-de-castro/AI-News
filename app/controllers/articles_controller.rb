class ArticlesController < ApplicationController

  def index
    @articles = Article.where(category: params[:category])
    @chat = Chat.new
  end
end
