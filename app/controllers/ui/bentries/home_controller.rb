class Ui::Bentries::HomeController < ApplicationController
  layout "ui/bentries/home/index"
  def index
    render Ui::Bentries::HomeComponent::HomeComponent.new()
  end
end
