class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon
  has_many :vendors

  attributes :vendor_count do |object|
    object.vendors.count
  end
end
