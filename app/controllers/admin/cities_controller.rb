class Admin::CitiesController < Admin::BaseController
  load_and_authorize_resource

  has_scope :visible
  has_scope :un_visible

end
