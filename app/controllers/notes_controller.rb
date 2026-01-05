class NotesController < ApplicationController
  # Devise helper: require login
  before_action :authenticate_user!

  # Only run set_note for actions that need an ID
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def authorize_owner!
    redirect_to notes_path, alert: "Not authorized." unless @note.user == current_user
  end


  # List all notes for current user
  def index
    owned_ids  = current_user.notes.select(:id)
    shared_ids = current_user.shared_notes.select(:id)

    @notes = Note.where(id: owned_ids)
                 .or(Note.where(id: shared_ids))
                 .order(updated_at: :desc)
  end

  # Show favorite notes only
  def favorites
    # This will never be nil; safe even if no favorites exist
    @notes = current_user.notes.where(favorite: true)
  end

  # Show single note
  def show
  end

  # New note form
  def new
    @note = current_user.notes.build
  end

  # Create note
  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      redirect_to notes_path, notice: "Note created successfully."
    else
      render :new
    end
  end

  # Edit note form
  def edit
  end

  # Update note
  def update
    if @note.update(note_params)
      redirect_to notes_path, notice: "Note updated successfully."
    else
      render :edit
    end
  end

  # Delete note
  def destroy
    @note.destroy
    redirect_to notes_path, notice: "Note deleted."
  end

  private

  # Only allow the current user's note
  def set_note
    @note = current_user.notes.find_by(id: params[:id]) ||
            current_user.shared_notes.find(params[:id])
  end

  # Strong params
  def note_params
    params.require(:note).permit(:title, :description, :favorite)
  end
end
