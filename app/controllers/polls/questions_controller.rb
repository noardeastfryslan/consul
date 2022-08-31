class Polls::QuestionsController < ApplicationController
  load_and_authorize_resource :poll
  load_and_authorize_resource :question, class: "Poll::Question"

  has_orders %w[most_voted newest oldest], only: :show

  def answer
    answer = @question.answers.find_or_initialize_by(author: current_user)

    answer.answer = params[:answer]
    answer.save_and_record_voter_participation

    respond_to do |format|
      format.html do
        redirect_to request.referer
      end
      format.js do
        render :answer
      end
    end
  end
end
