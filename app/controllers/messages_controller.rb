class MessagesController < ApplicationController


  def create

    @category = params[:category]
    @articles = Article.where(category: params[:category])
    system_prompt = "You are a News Assistant, you are specialized, a great expert in #{@category}.\n\n I am somebody who wants to know more about a news category.\n\n Help me get the most relevant news of the chosen category and summarize it.\n\n Answer concisely in Markdown."
    @chat = current_user.chats.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    if @message.save!
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions(system_prompt,challenge_context(@articles))).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      redirect_to chat_path(@chat, params[:category])
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def challenge_context(articles)
    "Here are the articles you have access to #{ }"
  end

  def instructions(prompt, articles)
    [prompt, articles].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
