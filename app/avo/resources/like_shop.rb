class Avo::Resources::LikeShop < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :shop_id, as: :number
    field :user, as: :belongs_to
    field :shop, as: :belongs_to
  end
end
