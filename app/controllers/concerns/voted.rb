module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_for, :vote_against, :unvote]
  end

  def vote_for
    @vote = current_user.vote(@votable, :for)
    vote_respond
  end

  def vote_against
    @vote = current_user.vote(@votable, :against)
    vote_respond
  end

  def unvote
    current_user.unvote(@votable)

    respond_to do |format|
      format.json { render json: { id: @votable.id, votable: @votable.class.name.underscore, rating: @votable.rating } }
    end
  end

  private

  def vote_respond
    respond_to do |format|
      if @vote.valid?
        format.json { render json: { id: @votable.id, votable: @votable.class.name.underscore, rating: @votable.rating } }
      else
        format.json { render json: {
            id: @votable.id,
            votable: @votable.class.name.underscore,
            errors: @vote.errors.full_messages,
            status: :unprocessable_entity
          }
        }
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
