class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.with_ratings
    @selected_ratings = @all_ratings unless params[:ratings]
    @movieColor = params[:sort]
    @movies = Movie.order(params[:sort])
    if params[:sort]
        session[:sort] = @movies
    end
    
    if params[:ratings]
        @selected_ratings = params[:ratings].keys
        unless @selected_ratings.empty?
            @movies = @movies.where('rating IN (:ratings)', :ratings => @selected_ratings).order(params[:sort])
        end
        session[:ratings] = params[:ratings]
    else
        if session[:ratings]
            redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
        end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
    
  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def url
    if params[:ratings]
        session[:url] = params[:ratings].keys 
        @remember_me = session[:url]
        @remember_me
    end
  end
end
