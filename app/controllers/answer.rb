post '/answers/:id/comments/new' do
  if current_user
    answer = Answer.find(params[:id])
    question_id = answer.question.id
    answer.comments.create(text: params[:text], user_id: current_user)
    redirect "/questions/#{question_id}"
  else
    redirect '/users/login'
  end
end

get '/answers/:id/upvote' do
  if current_user
    answer = Answer.find(params[:id])
    question_id = answer.question.id
    answer.votes.create(user_id: current_user, value: 1)
    redirect "/questions/#{question_id}"
  else
    redirect '/users/login'
  end
end

get '/answers/:id/downvote' do
  if current_user
    answer = Answer.find(params[:id])
    question_id = answer.question.id
    answer.votes.create(user_id: current_user, value: -1)
    redirect "/questions/#{question_id}"
  else
    redirect '/users/login'
  end
end

get '/answers/:id/best' do
  answer = Answer.find(params[:id])
  question = answer.question(answer)
  question.answers.where(best: true).update_all(best: false)
    answer.best = true
    answer.save
  if request.xhr?
    "<p>Best answer:</p>"
  else
    redirect "questions/#{question.id}"
  end
end

get '/answers/:id/edit' do
  @answer = Answer.find(params[:id])
  erb :"/answers/edit"
end

put '/answers/:id/edit' do
  @answer = Answer.find(params[:id])
  question_id = @answer.question.id
  @answer.update(params[:answer])
  if @answer.save
    redirect "/questions/#{question_id}"
  else
    @errors = answers.errors.full_messages
    erb :"/answers/edit"
  end
end

delete '/answers/:id' do
  answer = Answer.find(params[:id])
  question_id = answer.question.id
  answer.destroy
  redirect "/questions/#{question_id}"
end
