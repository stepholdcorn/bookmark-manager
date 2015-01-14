
env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost:5432/bookmark_manager_#{env}")
DataMapper.finalize