class MessagesController < ApplicationController
  def create
    # Content, user, chatroom
    @message = Message.new(message_params)
    @chatroom = Chatroom.find(params[:chatroom_id])
    @user = current_user
    @message.chatroom = @chatroom
    @message.user = @user

    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: {message: @message})
      )
      head :ok
    else
      render 'chatrooms/show', status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
