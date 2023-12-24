class Avo::Resources::Product < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :description, as: :textarea
    field :price, as: :number
    field :onsale, as: :boolean
    field :deleted_at, as: :date_time
    field :position, as: :number
    field :publish_date, as: :date_time
    field :service_min, as: :number
    field :shop_id, as: :number
    field :cover, as: :file
    field :shop, as: :belongs_to
  end
end
