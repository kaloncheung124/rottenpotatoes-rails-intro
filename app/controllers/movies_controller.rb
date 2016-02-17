class MoviesController < ApplicationController
  
  def initialize
    @all_ratings = Movie.ratings
    @checked_ratings = @all_ratings
    @sort
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
    if !session.has_key? :ratings; session[:ratings] = @all_ratings; end
    if !session.has_key? :sort; session[:sort] = nil; end
    redir = false
    
    if params.has_key?(:ratings) || params.has_key?(:ratings_keys)
      params[:ratings_keys] ||= params[:ratings].keys
      session[:ratings] = params[:ratings_keys]
    else
      redir = true
    end
    @checked_ratings = session[:ratings]
    
    if params.has_key?(:sort)
      session[:sort] = params[:sort]
    else
      redir = true
    end
    @sort = session[:sort]
    
    if redir && !params[:redir]
      redir_hash = {ratings_keys: @checked_ratings, sort: @sort, redir: true}
      flash.keep
      redirect_to movies_path(redir_hash)
    end
    
    @movies = Movie.where(rating: @checked_ratings).order("#{@sort}")
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
