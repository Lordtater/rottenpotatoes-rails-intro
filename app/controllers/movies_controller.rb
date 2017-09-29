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
    if params[:sort_type] == nil
      @movies = Movie.all
    elsif params[:sort_type] == "title"
      @movies = Movie.order("title")
      @highlight = "title"
    elsif params[:sort_type] == "date"
      @movies = Movie.order("release_date")
      @highlight = "date"
    end
    puts "TEST2"
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
