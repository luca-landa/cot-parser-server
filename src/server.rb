# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'report_generator'
require_relative 'cot_symbols'

report_generator = ReportGenerator.new

before '*' do
  authenticate_request!
end

get '/' do
  'Up and running!'
end

get '/symbols' do
  format(COTSymbols.all_symbols)
end

get '/reports/latest' do
  report = report_generator.latest 
  halt 404, 'Latest report not found' unless report

  format(report)
end

get '/reports/by_date' do
  date = params['date']
  report = report_generator.by_date(date: date) 
  halt 404, "Report not found for date '#{date}'. Please use the format 'dd/mm/YYYY' and pick a valid (Tuesday) date." unless report

  format(report)
end

def authenticate_request!
  api_key = ENV.fetch('API_KEY', nil)
  return unless api_key
  return if request.env['HTTP_API_KEY'] == api_key

  halt 401, 'Unauthorized'
end

def format(report_obj)
  JSON.pretty_generate(report_obj)
end
