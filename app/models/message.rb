class Message < ApplicationRecord
  belongs_to :chat
  MAX_USER_MESSAGES = 2
  private

system_prompt2 = "You're an expert in summarizing, your role is to summarrize all the past messages while keeping all the key informations to keep the conversation going, answer in few sentences, to have the most complete information "
  def summarize_historic
    if chat.messages.where(role: "user").count >= max_user_messages
      @ruby_llm_chat
      sum = @ruby_llm_chat.with_instructions(system_prompt2).ask(chat.messages.content)
      chat.message.destroy_all
      Message.create(role: "assistant", content: sum.content, chat: @chat)
      #Détruire les messages du chat
      #Recréer un message dans le chat ayant un role assisatnt et la valeur sum.content
  end
end
end
