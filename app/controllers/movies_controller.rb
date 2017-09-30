class MoviesController < ApplicationController 
  
  

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] == nil or params[:sort_type] == nil and session[:sort_type]
      if params[:ratings] == nil then @rat = session[:ratings] else @rat = params[:ratings] end
      if params[:sort_type] == nil and session[:sort_type] then @sort = session[:sort_type] else @sort = params[:sort_type] end
      flash.keep
      redirect_to movies_path({:sort_type => @sort, :ratings => @rat})
    end
    if params[:sort_type] == nil and params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys)
    elsif params[:sort_type] != nil and params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_type])
    elsif params[:sort_type] != nil
      @movies = Movie.order(params[:sort_type])
    else
      @movies = Movie.all
    end
    @highlight = params[:sort_type] if params[:sort_type] != nil
    @all_ratings = @movies.get_ratings
    @checked_ratings = params[:ratings]  
    session[:ratings] = if params[:ratings] != nil and params[:ratings].keys.size > 0 then params[:ratings] else session[:ratings] end
    session[:sort_type] = if params[:sort_type] != nil then params[:sort_type] else nil end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def movies_title
    @movies = Movie.order(:title) #need to get index to use this instead of .all
    redirect_to sort_movies_title_path
  end
  

end
