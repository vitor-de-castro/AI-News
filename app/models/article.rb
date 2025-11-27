class Article < ApplicationRecord

  private

  def summarize_article
    #trouver l'article et son params,
    @article = Article.find(params[:article_id])

    @chat_summarize = Chat.new(title: "Resume")
    @chat_summarize = @article

    chat = .new

    #instancier un nouveau chat
    #Prompter

  end

  def build_summary_prompt
    PROMPT ="You are a specialist of making resume, you have to keep essentials informations only, and summarize it in 2 or 3 sentences: #{content}"
  end

end
