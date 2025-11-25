class ArticlesController < ApplicationController

  def index
    @chat = Chat.new
    if params[:category].present?
     @articles = Article.where(category: params[:category])
    else
      @articles = Article.all
    end
  end
end
