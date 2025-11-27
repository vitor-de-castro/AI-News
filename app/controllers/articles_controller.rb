class ArticlesController < ApplicationController

  def index
    @chat = Chat.new
    if params[:category].present?
      @articles = Article.where(category: params[:category])
    else
      @articles = Article.all
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  PROMPT ="You are a specialist of making resume, you have to keep essentials informations only, and summarize it in 100 characters"

  def summarize_article
    @article = Article.find(params[:id])
    @chat_summarize = RubyLLM.chat
    @response = @chat_summarize.with_instructions(PROMPT).ask(@article.content)
    @article.update(summary: @response.content)
    redirect_to articles_path(category: @article.category)
    rescue => e
      puts e.class
      puts e.message
      puts e.backtrace.first(5)
    end

end
