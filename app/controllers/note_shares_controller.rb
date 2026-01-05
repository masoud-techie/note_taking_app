class NoteSharesController < ApplicationController
  before_action :authenticate_user!

  def create
    note = current_user.notes.find(params[:note_id])
    user = User.find_by(email: params[:email])

    if user.nil?
      redirect_to note, alert: "User not found."
    else
      note.note_shares.create!(user: user)
      redirect_to note, notice: "Note shared successfully."
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to note, alert: "Note already shared with this user."
  end

  def destroy
    share = current_user.note_shares.find(params[:id])
    share.destroy
    redirect_to notes_path, notice: "Access removed."
  end
end
