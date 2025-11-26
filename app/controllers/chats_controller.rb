class ChatsController < ApplicationController

  def create

    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.user = current_user

    @category = params[:category]

    if @chat.save
      redirect_to chat_path(@chat, @category)
    else
      render "articles/index"
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
    @category = params[:format]
  end

end
