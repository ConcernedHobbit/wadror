class Place < OpenStruct
  def self.rendered_fields
    [:id, :name, :status, :street, :city, :zip, :country, :overall]
  end

  def address
    "#{street}, #{zip} #{city}, #{country}"
  end
end
