class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts or /accounts.json
  def index
    if user_signed_in?
      @accounts = current_user.accounts.includes(:bank)
    else
      redirect_to new_user_session_path, notice: "Sign In Or Sign Up"
    end
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    if user_signed_in?
      @account = current_user.accounts.build
    else
      redirect_to new_user_session_path, notice: "Sign In Or Sign Up"
    end
  end

  def correct_user
    @account = current_user.accounts.find_by(id: params[:id])
    redirect_to accounts_path, notice: "Not Authorized To Edit This account" if @account.nil?
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts or /accounts.json
  def create
    @account = current_user.accounts.build(account_params)

    respond_to do |format|
      if @account.save
        @account.bank.update(total_balance: @account.bank.accounts.sum(:balance))
        current_user.update(total_balance: @account.user.accounts.sum(:balance))
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:account_nick_name, :balance, :bank_id, :user_id)
  end
end
