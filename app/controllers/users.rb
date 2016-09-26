post '/users' do
  user = User.new(params[:user])
  if user.save
    session[:user_id] = user.id
    redirect  '/'
  else
    @errors = user.errors.full_messages
    erb :index
  end
end