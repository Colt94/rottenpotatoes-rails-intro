class MoviesController < ApplicationController

  @@first_use = true
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.movie_ratings()
    
    if params[:ratings] != nil #if filters are submitted
      @movies = Movie.with_ratings(params[:ratings].keys)
      session[:ratings] = params[:ratings].keys
      @ratings_used = session[:ratings]
      
      @@first_use = false
    else
      
      if @@first_use == true #sets up initial default page
        session.delete(:sort)
        session[:ratings] = Movie.movie_ratings()
        @ratings_used = session[:ratings]
      else
        @ratings_used = session[:ratings]
      end
      
      @movies = Movie.with_ratings(@ratings_used)
    end
    
    if params[:sort] == 'title'
      @movies = Movie.order(:title).with_ratings(session[:ratings])
      session[:sort] = params[:sort]
      @title_header = 'hilite'
    elsif params[:sort] == 'release'
      @movies = Movie.order(:release_date).with_ratings(session[:ratings])
      session[:sort] = params[:sort]
      @release_date_header = 'hilite'
    end
    
    if session[:sort]
      if session[:sort] == 'title'
        @movies = Movie.order(:title).with_ratings(session[:ratings])
        @title_header = 'hilite'
      elsif session[:sort] == 'release'
        @movies = Movie.order(:release_date).with_ratings(session[:ratings])
        @release_date_header = 'hilite'
      end
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
