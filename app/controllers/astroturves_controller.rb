class AstroturvesController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_astroturf, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, except: [:show, :index]

  def index
    @astroturves = Astroturf.all
  end

  def new
    @astroturf = Astroturf.new
    load_services
  end

  def create
    @astroturf = Astroturf.new(strong_params)

    if @astroturf.save
      flash[:success] =  'Halısaha başarılı bir şekilde oluşturuldu..'
      redirect_to astroturf_path(@astroturf)
    else
      flash[:danger] =  'Halısaha Oluşturulamadı'
      load_services
      render :new
    end
  end

  def show
    @comments = @astroturf.comments.order("created_at DESC")

    if current_user.present?
      if @astroturf.votes.where(user_id: current_user.id).any?
      		@vote = @astroturf.votes.where(user_id: current_user.id).first
  		else
    		@vote = @astroturf.votes.build
  		end

      if @astroturf.reservation.where(user_id: current_user.id).any?
        @reservation = @astroturf.reservation.where(user_id: current_user.id).first
      else
        @reservation = @astroturf.reservation.build
      end
    end

    @reservation = Reservation.new
  end

  def edit
    load_services
  end

  def update
    if @astroturf.update(strong_params)
      flash[:success] = 'Halısaha başarılı bir şekilde güncellendi..'
      redirect_to astroturf_path(@astroturf)
    else
      flash[:danger] = 'Halısaha Güncellenemedi.'
      load_services
      render :edit
    end
  end

  def destroy
      @astroturf.destroy
      flash[:success] = 'Halısaha başarılı bir şekilde silindi..'
      redirect_to astroturves_path
  end

  private

  def set_astroturf
    @astroturf = Astroturf.find(params[:id])
  end

  def strong_params
    params.require(:astroturf).permit(:name, :address, :city, :info, :phone, :map, :facebook, :twitter, :instagram,service_ids: [])
  end

  def load_services
    @services = Service.all
  end

  def authorize_user!
    redirect_to root_path, notice: "Bu sayfayı sadece yöneticiler görebilir." unless current_user.admin
  end
end
