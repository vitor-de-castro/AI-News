class ArticlesController < ApplicationController

  def index

    Article.all
    @articles = Article.where(category: params[:category])

    @chat = Chat.new
  end
end
