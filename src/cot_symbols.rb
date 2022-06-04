# frozen_string_literal: true

class COTSymbols
  SYMBOLS_NAME_MAP = {
    butter_cash_settled: 'BUTTER (CASH SETTLED)',
    milk_class_iii: 'MILK, Class III',
    non_fat_dry_milk: 'NON FAT DRY MILK',
    cme_milk_iv: 'CME MILK IV',
    lean_hogs: 'LEAN HOGS',
    live_cattle: 'LIVE CATTLE',
    random_length_lumber: 'RANDOM LENGTH LUMBER',
    feeder_cattle: 'FEEDER CATTLE',
    dry_whey: 'DRY WHEY',
    cheese_cash_settled: 'CHEESE (CASH-SETTLED)',
    russian_ruble: 'RUSSIAN RUBLE',
    canadian_dollar: 'CANADIAN DOLLAR',
    swiss_franc: 'SWISS FRANC',
    mexican_peso: 'MEXICAN PESO',
    british_pound_sterling: 'BRITISH POUND STERLING',
    japanese_yen: 'JAPANESE YEN',
    euro_fx: 'EURO FX',
    euro_fx_british_pound_xrate: 'EURO FX/BRITISH POUND XRATE',
    euro_fx_japanese_yen_xrate: 'EURO FX/JAPANESE YEN XRATE',
    brazilian_real: 'BRAZILIAN REAL',
    new_zealand_dollar: 'NEW ZEALAND DOLLAR',
    south_african_rand: 'SOUTH AFRICAN RAND',
    iii_month_eurodollars: '3-MONTH EURODOLLARS',
    bitcoin: 'BITCOIN',
    iii_month_sofr: '3-MONTH SOFR',
    i_month_sofr: '1-MONTH SOFR',
    s_p_500_consolidated: 'S&P 500 Consolidated',
    e_mini_s_p_500_stock_index: 'E-MINI S&P 500 STOCK INDEX',
    e_mini_s_p_financial_index: 'E-MINI S&P FINANCIAL INDEX',
    e_mini_s_p_utilities_index: 'E-MINI S&P UTILITIES INDEX',
    e_mini_s_p_400_stock_index: 'E-MINI S&P 400 STOCK INDEX',
    nasdaq_100_consolidated: 'NASDAQ-100 Consolidated',
    nasdaq_100_stock_index_mini: 'NASDAQ-100 STOCK INDEX (MINI)',
    australian_dollar: 'AUSTRALIAN DOLLAR',
    e_mini_russell_2000_index: 'E-MINI RUSSELL 2000 INDEX',
    nikkei_stock_average: 'NIKKEI STOCK AVERAGE',
    nikkei_stock_average_yen_denom: 'NIKKEI STOCK AVERAGE YEN DENOM',
    s_p_500_annual_dividend_index: 'S&P 500 ANNUAL DIVIDEND INDEX',
  }.freeze

  def self.all_symbols
    SYMBOLS_NAME_MAP.keys
  end

  def self.name(symbol)
    SYMBOLS_NAME_MAP[symbol]
  end

  def self.valid_symbol?(symbol)
    all.key?(symbol)
  end
end
