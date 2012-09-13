set :username, "admin"
set :password, "password"
set :userhash, "73eff6386ce2091b5ca702fc007e1da9"

helpers do
  def is_admin? 
    request.cookies[settings.username] == settings.userhash 
  end
  
  def rot_13 str
    str.tr 'a-zA-Z', 'n-za-mN-ZA-M'
  end

  def verify_auth!
    unless is_admin?
      halt 401, 'Not Authorized!' 
      redirect '/'
    end
  end
end

get '/' do
  @posts = Post.load_files
  erb :home, :locals => { :posts => @posts }
end

get '/login' do
  erb :login_form
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    response.set_cookie(settings.username, settings.userhash) 
    redirect '/'
  else
    'Bad Credentials!'
  end
end

get '/logout' do
  response.set_cookie(settings.username, false)
  redirect '/'
end

post '/post/comment/create' do
  comment_data = params[:comment]
  comment = Comment.new(comment_data)
  comment.create
  redirect "/post/#{comment.post_id}"
end

post '/post/create' do
  post_data = params[:post]
  post = Post.new(post_data)
  post.create
  redirect "/post/#{post.id}"
end

get '/post/new' do
  verify_auth!
  erb :post_form
end

get '/post/:id' do
  id = params[:id]
  post = Post.load_file(id)
  comments = Comment.load_file(id)
  erb :post, :locals => { :post => post, :comments => comments }
end
