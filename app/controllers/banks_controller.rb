class BanksController < ApplicationController
  before_action :authenticate_admin_user!, only: [:new, :create, :edit, :show, :index]
  before_action :set_bank, only: %i[ show edit update destroy ]
  # GET /banks or /banks.json
  def index
    @banks = Bank.all
  end

  # GET /banks/1 or /banks/1.json
  def show
  end

  # GET /banks/new
  def new
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks or /banks.json
  def create
    @bank = Bank.new(bank_params)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to bank_url(@bank), notice: "Bank was successfully created." }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banks/1 or /banks/1.json
  def update
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to bank_url(@bank), notice: "Bank was successfully updated." }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1 or /banks/1.json
  def destroy
    @bank.destroy

    respond_to do |format|
      format.html { redirect_to banks_url, notice: "Bank was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bank
    @bank = Bank.eager_load(:accounts).find(params[:id])
    @bank1 = Bank.find(params[:id])
    @accounts = @bank1.accounts.includes(:user)
  end

  # Only allow a list of trusted parameters through.
  def bank_params
    params.require(:bank).permit(:bank_name, :bank_abbrv, :total_balance)
  end

  def authenticate_admin_user!
    puts current_user.inspect
    if !current_user.is_admin
      puts "?????authenticate_admin_user???if??????????"
      redirect_to root_path
    end
  end
end
