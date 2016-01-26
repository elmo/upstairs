class Manage::ManageController < ApplicationController
  before_action :authenticate_user!
end
