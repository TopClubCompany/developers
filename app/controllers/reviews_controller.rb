class ReviewsController < ApplicationController
  before_filter :authenticate_user!

  def create
    review = Review.new(params[:review])
    review.user = current_user
    if review.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def vote
    vote_type = params[:useful]
    review = Review.find_by_id(params[:id])
    if current_user.votes.pluck(:review_id).include? review.id
      render :json => {error: "already used vote"}
    else
      if %w(helpful unhelpful).include? vote_type
        current_user.votes << Vote.new(review_id: review.id, vote_type_id: VoteType.find_by_title(vote_type).try(:id))
        render :json => {success: "review successfully added"}
      else
        render :json => {error: "wrong vote type"}
      end
    end
  end

end
