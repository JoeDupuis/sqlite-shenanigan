class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  SHARDS = [:shard_one, :shard_two, :shard_three, :shard_four, :shard_five, :shard_six, :shard_seven, :shard_eight, :shard_eight, :shard_one]

  # GET /requests or /requests.json
  def index
    @requests = Request.all
  end

  # GET /requests/1 or /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests or /requests.json
  def create
    @request = Request.new(
      uid: request.uuid,
      ip: request.remote_ip,
      method: request.method,
      url: request.original_url,
      parameters: request.request_parameters,
    )


    ActiveRecord::Base.connected_to(role: :writing, shard: SHARDS[(Time.now.to_i % 10)]) do
      @request.save! unless ENV["skip_save"] || params[:skip_save]
    end
    head :no_content
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: "Request was successfully updated." }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @request.destroy!

    respond_to do |format|
      format.html { redirect_to requests_path, status: :see_other, notice: "Request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.expect(request: [ :uid, :ip, :method, :url, :parameters ])
    end
end
