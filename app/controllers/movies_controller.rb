class MoviesController < ApplicationController
  
  def initialize
    @all_ratings = Movie.ratings
    @checked_ratings = @all_ratings
    super
  end
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.has_key?(:ratings) && params.has_key?(:refresh)
      @checked_ratings = params[:ratings].keys
      session[:ratings] = @checked_ratings
    else
      if session[:ratings]; @checked_ratings = session[:ratings]; end
    end
    ratings = @checked_ratings
    if !params.has_key?(:sort)
      sort = session[:sort]
    else
      sort = params[:sort]
      session[:sort] = sort
    end
    
    @movies = Movie.where(rating: ratings).order("#{sort}")
  end
  
  helper_method :show_rat, :hilite?
  
  def show_rat(rating)
    if @checked_ratings.include?(rating)
      return true
    end
  end
  
  helper_method :hilite
  
  def hilite?(tagname)
    if session[:sort] == tagname
      'hilite'
    else
      'th'
    end
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

end
