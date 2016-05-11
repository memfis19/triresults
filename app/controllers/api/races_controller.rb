module Api
  class RacesController < ApplicationController
    before_action :set_race, only: [:show, :edit, :update, :destroy]
    respond_to :json
    protect_from_forgery with: :null_session

    def index
      if !request.accept || request.accept == "*/*"
        if !params[:race_id]
          render plain: "/api/races"
        else
          render plain: "/api/races/#{params[:race_id]}/results"
        end
      else
        respond_with Race.all
      end
    end

    def show
      if !request.accept || request.accept == "*/*"
        if !params[:race_id]
          render plain: "/api/races/#{params[:id]}"
        else
          render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
        end
      else
        respond_with @race
      end
    end

    def create
      if !request.accept || request.accept == "*/*"
        render plain: :nothing, status: :ok
      else
        respond_with Race.create(params)
      end

    end

    def update
      respond_with @race.update(params)
    end

    def destroy
      respond_with @race.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_race
      @race = Race.find(params[:id])
    rescue Mongoid::Errors::DocumentNotFound => e
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def race_params
      params.require(:race).permit(:name, :date, :city, :state, :swim_distance, :swim_units, :bike_distance, :bike_units, :run_distance, :run_units, :race_id)
    end

  end

end
