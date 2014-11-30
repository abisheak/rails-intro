class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    params[:ratings] ? @selected_ratings = params[:ratings].keys : @selected_ratings = @all_ratings
    
    if params[:sort]
        @movieColor = params[:sort]
        if session[:ratings].nil?
            @movies = Movie.with_ratings(@selected_ratings).order(params[:sort])
        else
            @selected_ratings = session[:ratings]
            @movies = Movie.with_ratings(session[:ratings]).order(params[:sort])
        end
        if session[:sort].nil? || session[:sort] != params[:sort]
            session[:sort] = params[:sort]
        end
    elsif params[:ratings]
        @movies = Movie.with_ratings(@selected_ratings)
        if session[:ratings].nil? || session[:ratings] != params[:ratings].keys
            session[:ratings] = @selected_ratings
        end
    else
        unless params[:ratings] || params[:sort]
            @selected_ratings = session[:ratings]
            @movies = Movie.with_ratings(session[:ratings]) 
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
