# frozen_string_literal: true

# Handles CRUD for Users
class UsersController < ResourceController
  # Custom create action to set temp password and send email
  def create
    @user = User.new(permitted_resource_params)
    @user.password = Devise.friendly_token.first(8)
    if @user.save
      # Send reset password instructions to allow the user to set their own password
      @user.send_reset_password_instructions
      flash[:success] = "Successfully created #{object_name.humanize}"
      redirect_to send("#{object_name.pluralize}_path", @user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render 'new'
    end
  end

  ##
  # Permitted params for user. We also remove the password param if it's empty
  # so as to not try and set the user's password to nothing
  #
  def permitted_resource_params
    params.require(:user).permit(:email, :password).delete_if do |key, value|
      key == 'password' && value.empty?
    end
  end
end
