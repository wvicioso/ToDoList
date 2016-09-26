get '/lists' do
  @lists = List.all
  erb :'lists/index'
end

get '/lists/new' do
  if request.xhr?
    erb :'lists/_new_list_form', layout: false
  else
    erb :'lists/new'
  end
end

post '/lists' do
  list = List.new(name: params[:name], user_id: current_user.id)
  if list.save
    if request.xhr?
      erb :'lists/_list_item', locals: {list: list}, layout: false
    else
      redirect '/lists'
    end
  else
    @errors = list.errors.full_messages
    if request.xhr?
      erb :'_errors', layout: false
    else
      erb :'lists/new'
    end
  end
end

get '/lists/:list_id/tasks' do
  @list = List.find(params[:list_id])
  @tasks = @list.tasks
  erb :'tasks/index'
end

get '/lists/:list_id/tasks/edit' do
  @list = List.find(params[:list_id])
  erb :'lists/edit'
end

put '/lists/:list_id/tasks' do
  @list = List.find(params[:list_id])
  if @list.update_attributes(params[:list])
    redirect "/lists/#{@list.id}/tasks"
  else
    @errors = @list.errors.full_messages
    erb :'lists/edit'
  end
end

get '/lists/:list_id/tasks/new' do
  erb :'tasks/new'
end

post '/lists/:list_id/tasks' do
  if params[:status] == "completed"
    status = true
  else
    status = false
  end
  task = Task.new(description: params[:description], status: status, list_id: params[:list_id])
  @list = task.list
  if task.save
    redirect "lists/#{@list.id}/tasks"
  else
    @errors = task.errors.full_messages
    erb :'tasks/new'
  end
end