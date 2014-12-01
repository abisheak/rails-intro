class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def prev_state
    if params[:sort]
        @movieColor = params[:sort]
        if session[:ratings].nil?
            @movies = Movie.with_ratings(@selected_ratings.keys).order(params[:sort])
        else
            @selected_ratings = session[:ratings].keys
            @movies = Movie.with_ratings(@selected_ratings).order(params[:sort])
        end
        if session[:sort].nil? || session[:sort] != params[:sort]
            session[:sort] = params[:sort]
        end
    elsif params[:ratings]
        @movies = Movie.with_ratings(@selected_ratings.keys)
        if session[:ratings].nil? || session[:ratings] != params[:ratings].keys
            session[:ratings] = @selected_ratings
        end
        if session[:sort]
            session[:sort] = nil
        end
    else
        if session[:ratings] || session[:sort]
             redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
        else
            @movies = Movie.all 
        end
    end
  end
end
