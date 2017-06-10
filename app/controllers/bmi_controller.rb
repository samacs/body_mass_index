class BmiController < ApplicationController
  before_action :require_user

  def new; end

  def calculate
    bmi = BMI.new(bmi_params)
    bmi.calculate

    @category = bmi.category
    @bmi      = bmi.bmi
  rescue ArgumentError => e
    flash.now[:error] = e.message
  ensure
    @height   = bmi_params[:height]
    @weight   = bmi_params[:weight]
    @imperial = bmi_params[:imperial]
    render :new
  end

  private

  def bmi_params
    params.permit(:weight, :height, :imperial)
  end
end
