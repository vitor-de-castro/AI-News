class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a News Assistant, specialized in 6 different categories: Sport, Tech, Science, Health, Leisure and Finance.\n\n I am somebody who wants to know more about a news category.\n\n Help me get the most relevant news of the chosen category and summarize it.\n\n Answer concisely in Markdown."

  def create
  @chat = current_user.chats.find(params[:chat_id])
  @articles = Article.where(category: params[:format])

  @message = Message.new(message_params)
  @message.chat = @chat
  @message.role = "user"

    if @message.save
    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
    Message.create(role: "assistant", content: response.content, chat: @chat)

   redirect_to chat_messages_path(@chat)
 else
  render "chats/show", status: :unprocessable_entity
  end

  def message_params
  params.require(:message).permit(:content)
  end

end
