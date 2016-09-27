get '/users/register' do
	erb :'users/register'
end

post '/users/register' do
	user = User.new(params[:user])
	if user.save
		session[:user_id] = user.id
		redirect "/users/#{user.id}"
	else
		@errors = user.errors.full_messages
		erb :'users/register'
	end
end

get '/users/login' do
	erb :'users/login'
end

post '/users/login' do
	user = User.find_by(email: params[:email])
	if user && user.authenticate(params[:password])
		session[:user_id] = user.id
		redirect '/'
	else
		@errors = ["incorrect username or password"]
		erb :'users/login'
	end
end

get '/users/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/users/:id' do
	@user_lists = current_user.lists
	@user_tasks = current_user.tasks
	@complete_tasks = current_user.complete_tasks
	@incomplete_tasks = current_user.incomplete_tasks
	erb :'users/show'
end