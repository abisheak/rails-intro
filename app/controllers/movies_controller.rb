class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @movies = Movie.all
    params[:ratings] ? @selected_ratings = params[:ratings].keys : @selected_ratings = @all_ratings
    
    
    if params[:sort] && params[:ratings]
        @movies = Movie.with_ratings(params[:ratings].keys).order(params[:sort])
    elsif params[:ratings]
        unless @selected_ratings.empty?
            @movies = Movie.with_ratings(@selected_ratings)
        end
        session[:ratings] = params[:ratings]
    elsif params[:sort]
        @movieColor = params[:sort]
        @movies = Movie.order(params[:sort])
        session[:sort] = @movieColor
    else
        unless params[:sort] || params[:ratings]
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
end
