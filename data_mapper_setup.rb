env = ENV['RACK_ENV'] || 'development'

url = ENV['DATABASE_URL'] || "postgres://localhost:5432/bookmark_manager_#{env}"

DataMapper.setup(:default, url)
DataMapper.finalize