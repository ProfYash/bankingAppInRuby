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

  def deposit
    ActiveRecord::Base.transaction do
      if user_signed_in?
        @account = current_user.accounts.find_by(id: params[:id])
        deposit_amount = params[:deposit_amount].to_f
        if @account
          @account.balance += deposit_amount
          if @account.save
            @account.bank.update(total_balance: @account.bank.accounts.sum(:balance))
            current_user.update(total_balance: @account.user.accounts.sum(:balance))
            redirect_to account_url(@account), notice: "Deposit was successfully created."
          else
            render :new, status: :unprocessable_entity
          end
        else
          redirect_to root_path, notice: "Account not found"
        end
      else
        redirect_to new_user_session_path, notice: "Sign In Or Sign Up"
      end
    end
  end

  def withdraw
    ActiveRecord::Base.transaction do
      if user_signed_in?
        @account = current_user.accounts.find_by(id: params[:id])
        withdraw_amount = params[:withdraw_amount].to_f
        if @account
          if @account.balance >= withdraw_amount
            @account.balance -= withdraw_amount
            if @account.save
              @account.bank.update(total_balance: @account.bank.accounts.sum(:balance))
              current_user.update(total_balance: @account.user.accounts.sum(:balance))
              redirect_to account_url(@account), notice: "Deposit was successfully created."
            else
              render :new, status: :unprocessable_entity
            end
          else
            redirect_to account_url(@account), notice: "Insufficient Balance."
          end
        else
          redirect_to root_path, notice: "Account not found"
        end
      else
        redirect_to new_user_session_path, notice: "Sign In Or Sign Up"
      end
    end
  end

  def transfer
    ActiveRecord::Base.transaction do
      puts "222222222222222222transfer222222222222222222"
      if user_signed_in?
        @account = current_user.accounts.find_by(id: params[:id])
        withdraw_amount = params[:withdraw_amount].to_f
        account_nick_name = params[:account_nick_name]
        puts "2222222222222222222account_nick_name2222222222222222222"
        puts account_nick_name
        if @account
          if @account.balance >= withdraw_amount
            @account.balance -= withdraw_amount
            @credit_account = Account.find_by(account_nick_name: account_nick_name)
            if @credit_account
              puts "22222222222222222@credit_account22222222222222222222222"
              puts @credit_account.attributes
              #add amount to credit account
              @credit_account.balance += withdraw_amount

              if @account.save && @credit_account.save
                @account.bank.update(total_balance: @account.bank.accounts.sum(:balance))
                current_user.update(total_balance: @account.user.accounts.sum(:balance))
                @credit_account.user.update(total_balance: @account.user.accounts.sum(:balance))
                redirect_to account_url(@account), notice: "Deposit was successfully created."
              else
                render :new, status: :unprocessable_entity
              end
            else
              redirect_to account_url(@account), notice: "Credit Account Not Found"
            end
          else
            redirect_to account_url(@account), notice: "Insufficient Balance."
          end
        else
          redirect_to root_path, notice: "Account not found"
        end
      else
        redirect_to new_user_session_path, notice: "Sign In Or Sign Up"
      end
    end
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
