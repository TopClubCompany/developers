class ReviewsController < ApplicationController

  def create
    review = Review.new(params[:review])
    if review.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def set_usefulness
    vote_type = params[:vote_type]
    review = Review.find_by_id(params[:review_id])
    redirect_to :back, flash: { error: 'already used vote' } and return if current_user.votes.pluck(:review_id).include? review.id
    if %w(helpful unhelpful).include? vote_type
      current_user.votes << Vote.new(review_id: review.id, vote_type_id: VoteType.find_by_title(vote_type).try(:id))
      redirect_to :back, flash: { success: 'review successfully added' }
    else
      redirect_to :back, flash: { error: 'wrong vote type' }
    end
  end

end
