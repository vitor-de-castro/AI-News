class ChatsController < ApplicationController

  def create
    @chat = Chat.new(title: "New chat")
    @chat.user = current_user
    raise
    # if @chat.save
    #   redirect_to articles_path(category: params)

  end
end
