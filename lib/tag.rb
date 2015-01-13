class Tag
  include DataMapper::Resource

  has n, :links, :through => Resource
  # belongs_to :link

  property :id, Serial
  property :text, String
end