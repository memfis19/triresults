module Api
  class RacersController < ApplicationController
    before_action :set_racer, only: [:show, :edit, :update, :destroy]
    respond_to :json

    def index
      if !request.accept || request.accept == "*/*"
        if !params[:racer_id]
          render plain: "/api/racers"
        else
          render plain: "/api/racers/#{params[:racer_id]}/entries"
        end
      else
        respond_with Racer.all
      end
    end

    def show
      if !request.accept || request.accept == "*/*"
        if !params[:racer_id]
          render plain: "/api/racers/#{params[:id]}"
        else
          render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}"
        end
      else
        respond_with @racer
      end

    end

    def create
      respond_with Racer.create(racer_params)
    end

    def update
      respond_with @racer.update(racer_params)
    end

    def destroy
      respond_with @racer.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_racer
      @racer = Racer.find(params[:id])

    rescue Mongoid::Errors::DocumentNotFound => e
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def racer_params
      params.require(:racer).permit(:first_name, :last_name, :gender, :birth_year, :city, :state, :racer_id)
    end
  end
end