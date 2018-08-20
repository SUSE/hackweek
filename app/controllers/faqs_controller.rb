class FaqsController < ApplicationController
  load_and_authorize_resource params_method: :faq_params
  skip_before_action :authenticate_user!, only: [ :index ]


  # GET /faqs | /faq
  def index
    @faqs = Faq.all
  end

  # GET /faqs/new
  def new
    @faq = Faq.new
  end

  # GET /faqs/1/edit
  def edit
  end

  # POST /faqs
  def create
    @faq = Faq.new(faq_params)

    if @faq.save
      redirect_to faqs_url, notice: 'Faq was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /faqs/1
  def update
    if @faq.update(faq_params)
      redirect_to faqs_url, notice: 'Faq was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /faqs/1
  def destroy
    @faq.destroy
    redirect_to faqs_url, notice: 'Faq was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find!(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def faq_params
      params.require(:faq).permit(:question, :answer)
    end
end
