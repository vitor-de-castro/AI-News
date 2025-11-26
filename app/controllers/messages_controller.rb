class MessagesController < ApplicationController


  def create

    @category = params[:category]

    @articles = Article.where(category: params[:category]).first(5)
    system_prompt = "You are a News Assistant that is working for the website AI-News, you are specialized, a great expert in #{@category}.\n\n I am somebody who wants to know more about a news category.\n\n Help me get the most relevant news of the chosen category and summarize it.\n\n Answer concisely in Markdown."
    @chat = current_user.chats.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    if @message.save!
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions(system_prompt,challenge_context(@articles))).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      @chat.generate_title_from_first_message
      redirect_to chat_path(@chat, params[:category])
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private
  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def challenge_context(articles)
    c = ""
    articles.map do |article|
      c += "#{article.title}: #{article.content} \n\n"
    end
    "And here are the articles, the user have access to on this website #{c}, you can also use your own knowledge answer the user question and explain to him."
  end

  def instructions(prompt, articles)
    [prompt, articles].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
