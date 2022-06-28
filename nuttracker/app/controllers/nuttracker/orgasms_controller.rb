module Nuttracker
  class OrgasmsController < ApplicationController
    before_action :set_orgasm, only: %i[ show edit update destroy ]

    # GET /orgasms
    def index
      @orgasms = Orgasm.all
    end

    # GET /orgasms/1
    def show
    end

    # GET /orgasms/new
    def new
      @orgasm = Orgasm.new
    end

    # GET /orgasms/1/edit
    def edit
    end

    # POST /orgasms
    def create
      @orgasm = Orgasm.new(orgasm_params)

      if @orgasm.save
        redirect_to @orgasm, notice: "Orgasm was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /orgasms/1
    def update
      if @orgasm.update(orgasm_params)
        redirect_to @orgasm, notice: "Orgasm was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /orgasms/1
    def destroy
      @orgasm.destroy
      redirect_to orgasms_url, notice: "Orgasm was successfully destroyed."
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_orgasm
        @orgasm = Orgasm.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def orgasm_params
        params.require(:orgasm).permit(:user_id, :is_ruined, :rating)
      end
  end
end
