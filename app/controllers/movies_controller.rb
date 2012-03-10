class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      @all_ratings = {'G'=>false,'PG'=>false,'PG-13'=>false,'R'=>false}
      if (params["ratings"])
        # have to parse ratings = {"G"=>"1","PG"=>"1"}
        # into where(:rating, ["G", "PG"])
        ratings = Array.new
        params["ratings"].each do |k, v| 
          if v == "1" 
            @all_ratings[k] = true
          end
          ratings.push(k)
        end
        @movies = Movie.where(:rating => ratings).order(params["sort"])
      else
        @movies = Movie.order(params["sort"])
        flash[:sort] = params["sort"]
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
