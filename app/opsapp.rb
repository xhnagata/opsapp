require 'activerecord-sqlserver-adapter'
require 'sinatra'
require 'sinatra/activerecord'
require './app/models/health'

before do
  now = Time.now
  # おおよそ10リクエストに1回の頻度で、標準エラー出力を行う
  if now.nsec.to_s.delete('0')[-1] == '1'
    STDERR.puts "STDERR #{now}"
  end
rescue => e
  STDERR.puts "STDERR RESCUE #{e.message} #{Time.now}"
end

get '/health' do
  content_type 'text/plain'
  '200 OK'
end

get '/health/readable' do
  content_type 'text/plain'
  Health.find_by(path: 'readable')
  '200 OK'
rescue
  status 500
  '500 Internal Server Error'
end

get '/health/writable' do
  content_type 'text/plain'

  begin
    records = Health.where(path: 'writable')
    if records.size > 0
      records.destroy_all
    end
    Health.create!(path: 'writable')
    '200 OK'
  rescue => e
    status 500
    '500 Internal Server Error'
  end
end

get '/health/toggle' do
  content_type 'text/plain'
  if Health.find_by(path: 'toggle')
    '200 OK'
  else
    status 503
    '503 Service Unavailable'
  end
end

post '/health/toggle' do
  content_type 'text/plain'

  records = Health.where(path: 'toggle')
  if records.size > 0
    records.destroy_all
  else
    Health.create!(path: 'toggle')
  end

  status 201
  '201 Created'
rescue
  status 500
  '500 Internal Server Error'
end

not_found do
  content_type 'text/plain'
  '404 not found'
end
