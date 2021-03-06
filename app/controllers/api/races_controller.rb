module Api
  class RacesController < ApplicationController
    before_action :set_race, only: [:show, :edit, :update, :destroy]
    protect_from_forgery with: :null_session
    respond_to :json, :xml

    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
    end

    def index
      if !request.accept || request.accept == "*/*"
        query_params = request.query_parameters.to_hash if request.query_parameters
        if !params[:race_id]
          result = ""
          query_params.keys.map { |item| result << ", #{item}=[#{query_params[item]}]" } if query_params
          if !result.empty?
            render plain: "/api/races" + "/"+ result
          else
            render plain: "/api/races"
          end
        else
          render plain: "/api/races/#{params[:race_id]}/results"
        end
      else
        if !params[:race_id]
          respond_with Race.all
        else
          @race=Race.find(params[:race_id])
          @entrants=@race.entrants

          if stale?(@entrants, last_modified: @entrants.max(:updated_at))
            return render :partial => "api/results/index", :object => @entrants, :status => :ok
          end

          # @entrants.each { |entrant| fresh_when(entrant) } if @entrants
          # return render :partial => "api/results/index", :object => @entrants, :status => :ok
        end
      end
    end

    def show
      if @race.nil?
        @error = Hash.new
        @error[:msg] = "woops: cannot find race[#{params[:id]}]"
        if request.accept == "application/xml"
          return render 'api/error_msg', formats: [:xml], status: :not_found
        end
        if request.accept == "application/json"
          return render 'api/error_msg', formats: [:json], status: :not_found
        end
      end
      if !request.accept || request.accept == "*/*"
        if !params[:race_id]
          return render plain: "/api/races/#{params[:id]}"
        else
          return render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
        end
      else
        if !params[:race_id]
          if request.accept == "application/xml"
            return render 'api/show', formats: [:xml]
          end
          if request.accept == "application/json"
            return render 'api/show', formats: [:json]
          end
        else
          @result=Race.find(params[:race_id]).entrants.where(:id => params[:id]).first
          return render :partial => "api/result", :object => @result, :status => :ok
        end
        # respond_with @race
      end
      if !request.accept || request.accept == "text/plain"
        return render plain: "woops: we do not support that content-type[text/plain]", status: 415
      end
    end

    def create
      if !request.accept || request.accept == "*/*"
        if params[:race] and params[:race][:name]
          render plain: params[:race][:name], content_type: "text/plain", status: :ok
        else
          render plain: :nothing, status: :ok
        end
      else
        # respond_with Race.create(params)
        @race = Race.create(params[:race].to_hash)
        render plain: @race.name, content_type: "text/plain", status: :created
      end

    end

    def update
      # respond_with @race.update(params)
      if @race.nil?
        return render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
      end
      if params[:race_id]
        entrant=Race.find(params[:race_id]).entrants.where(:id => params[:id]).first
        parameters = params[:result].to_hash

        if parameters
          if parameters["swim"]
            entrant.swim=entrant.race.race.swim
            entrant.swim_secs = parameters["swim"].to_f
          end
          if !parameters["t1"].nil?
            entrant.t1=entrant.race.race.t1
            entrant.t1_secs = parameters["t1"].to_f
          end
          if !parameters["bike"].nil?
            entrant.bike=entrant.race.race.bike
            entrant.bike_secs = parameters["bike"].to_f
          end
          if !parameters["t2"].nil?
            entrant.t2=entrant.race.race.t2
            entrant.t2_secs = parameters["t2"].to_f
          end
          if parameters["run"]
            entrant.run=entrant.race.race.run
            entrant.run_secs = parameters["run"].to_f
          end
        end
        entrant.save
        return render :partial => "api/result", :object => entrant, :status => :ok
      end
      if params[:race]
        @race.update(params[:race].to_hash)
        render json: @race, content_type: "application/json", status: :ok
      end
    end

    def destroy
      respond_with @race.destroy
    end

    private
    def set_race
      if !params[:race_id]
        @race = Race.find(params[:id])
      else
        @race = Race.find(params[:race_id])
      end
    rescue Mongoid::Errors::DocumentNotFound => e
    end

    def race_params
      params.require(:race).permit(:name, :date, :city, :state, :swim_distance, :swim_units, :bike_distance, :bike_units, :run_distance, :run_units, :race_id, :swim, :t1, :bike, :t2, :run, :result)
    end

  end

end
