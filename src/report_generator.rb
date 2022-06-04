# frozen_string_literal: true

require 'date'
require_relative 'cot_symbols'
require_relative 'http_client'

class ReportGenerator
  attr_reader :client
  
  REPORT_URL = 'https://www.cftc.gov/dea/futures/deacmesf.htm'

  DATE_REGEX = /\d{2}\/\d{2}\/\d{2,4}/

  def initialize
    @http_client = HttpClient.new
  end

  def latest(symbols: nil)
    validate_symbols(symbols) if symbols
    report_symbols = symbols || COTSymbols.all_symbols

    create_report(url: REPORT_URL, symbols: report_symbols)
  end

  def by_date(date:, symbols: nil)
    parsed_date = parse_date(date)
    report_symbols = symbols || COTSymbols.all_symbols

    year_long = parsed_date.strftime('%Y')
    daytime_short = parsed_date.strftime('%m%d%y')
    url = "https://www.cftc.gov/sites/default/files/files/dea/cotarchives/#{year_long}/futures/deacmesf#{daytime_short}.htm"

    create_report(url: url, symbols: report_symbols)
  end

  private

  attr_reader :http_client

  def create_report(url:, symbols:)
    report_string = http_client.fetch(url: url)
    return unless report_string

    parse_report(report_string, symbols: symbols)
  end

  def parse_report(report_string, symbols:)
    result = {
      found_symbols: [],
      not_found_symbols: [],
      symbols_data: {}
    }
    lines = report_string.lines.map(&:chomp)

    symbols.each do |symbol|
      cot_symbol = COTSymbols.name(symbol)
      starting_line_index = lines.index { |line| line.start_with?(cot_symbol) }
      if starting_line_index.nil?
        result[:not_found_symbols] << symbol
        next
      end

      result[:found_symbols] << symbol

      date = extract_date(lines, starting_line_index)
      open_interest = extract_open_interest(lines, starting_line_index)
      change_in_open_interest = extract_change_in_open_interest(lines, starting_line_index)
      commitments = extract_commitments(lines, starting_line_index)
      changes = extract_changes(lines, starting_line_index)
      percent_of_interest_values = extract_percent_of_interest_values(lines, starting_line_index)
      result[:symbols_data][symbol] = {
        symbol: symbol,
        name: cot_symbol,
        date: date,
        current: commitments.slice(:non_commercial, :commercial),
        changes: changes.slice(:non_commercial, :commercial),
        open_interest: {
          current: open_interest,
          change: change_in_open_interest,
          percentages: percent_of_interest_values.slice(:non_commercial, :commercial)
        }
      }
    end

    result
  end

  def extract_date(lines, starting_index)
    lines[starting_index + 1].match(DATE_REGEX)[0]
  end

  def extract_open_interest(lines, starting_index)
    lines[starting_index + 7]
      .split(/\s+/)
      .last
      .tr(',', '')
      .to_f
  end

  def extract_change_in_open_interest(lines, starting_index)
    lines[starting_index + 11]
      .split(/\s+/)
      .last
      .tr(',)', '')
      .to_f
  end

  def extract_commitments(lines, starting_index)
    extract_row_values(lines[starting_index + 9])
  end

  def extract_changes(lines, starting_index)
    extract_row_values(lines[starting_index + 12])
  end

  def extract_percent_of_interest_values(lines, starting_index)
    extract_row_values(lines[starting_index + 15])
  end

  def extract_row_values(line)
    values = line
              .strip
              .tr(',', '')
              .split(/\s+/)
              .map(&:to_f)

    {
      non_commercial: {
        long: values[0],
        short: values[1],
        spreads: values[2]
      },
      commercial: {
        long: values[3],
        short: values[4]
      },
      total: {
        long: values[5],
        short: values[6]
      },
      non_reportable: {
        long: values[7],
        short: values[8]
      }
    }
  end

  def validate_symbols(symbols)
    return unless symbols

    invalid_symbols = symbols.filter do |symbol|
      !COTSymbols.valid_symbol?(symbol)
    end
    return if invalid_symbols.empty?

    raise "Invalid symbols provided: #{invalid_symbols.join(',')}"
  end

  def parse_date(date)
    Date.parse(date)
  rescue ArgumentError
    raise "invalid date #{date}"
  end
end
