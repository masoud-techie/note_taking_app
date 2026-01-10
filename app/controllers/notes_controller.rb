class NotesController < ApplicationController
  # Devise helper: require login
  before_action :authenticate_user!

  # Only run set_note for actions that need an ID
  before_action :set_note, only: [:show, :edit, :update, :destroy, :toggle_favorite]

  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def authorize_owner!
    redirect_to notes_path, alert: "Not authorized." unless @note.user == current_user
  end


  # List all notes for current user
  def index
    owned_ids  = current_user.notes.select(:id)
    shared_ids = current_user.shared_notes.select(:id)

    @notes = Note
               .left_joins(:note_shares)
               .where("notes.user_id = :user_id OR note_shares.user_id = :user_id",
                      user_id: current_user.id)
               .distinct
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
    note = current_user.notes.find(params[:id])
    note.destroy
    redirect_to notes_path, notice: "Note deleted."
  end


  def note_params
    params.require(:note).permit(:title, :description, :favorite)
  end

  def toggle_favorite
    @note = current_user.notes.find(params[:id])
    @note.update(favorite: !@note.favorite)

    redirect_back fallback_location: notes_path
  end


  private

  # Only allow the current user's note
  def set_note
    @note = current_user.notes.find_by(id: params[:id]) ||
            current_user.shared_notes.find(params[:id])
  end

  # Strong params


end
