module I18nHelper
  def translate_roles(*roles)
    roles.flatten.map do |role|
      t("simple_form.options.role.name.#{role}")
    end
  end
end
