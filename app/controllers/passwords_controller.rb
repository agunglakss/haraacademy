class PasswordsController < Devise::PasswordsController

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    set_flash_message(:alert, :send_paranoid_instructions)
    new_user_password_path if is_navigational_format?
  end

end