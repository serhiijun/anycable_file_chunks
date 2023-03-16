class Ui::Bentries::HomeComponent::HomeComponent < ViewComponent::Base
  def css_class
    self.class.name.underscore.gsub('_', '-').gsub('/', '--').split('--')[0..-2].join('--')
  end
end
