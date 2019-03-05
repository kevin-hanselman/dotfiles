#!/usr/bin/env python
import sys

import requests
import pandas as pd

from ticker_config import API_KEY, SYMBOLS


def get_quote(symbol):
    base_url = 'https://www.alphavantage.co/query'
    if is_cryptocurrency(symbol):
        # The DIGITAL_CURRENCY_DAILY endpoint does not show prices for the
        # current day. We get the current price via the CURRENCY_EXCHANGE_RATE
        # endpoint.
        params = {'function': 'DIGITAL_CURRENCY_DAILY',
                  'market': 'USD',
                  'symbol': symbol,
                  'datatype': 'csv',
                  'apikey': API_KEY}
    else:
        params = {'function': 'TIME_SERIES_DAILY_ADJUSTED',
                  'symbol': symbol,
                  'datatype': 'csv',
                  'apikey': API_KEY}

    response = requests.get(base_url, params=params)

    quote_df = parse_csv_quote(response.text)

    if is_cryptocurrency(symbol):
        quote_df = quote_df.T.drop_duplicates().T  # remove duplicate columns
        yesterdays_price = quote_df.loc[0, 'close (USD)']
        current_price = float(
            requests.get(
                base_url,
                params={
                    'function': 'CURRENCY_EXCHANGE_RATE',
                    'from_currency': symbol,
                    'to_currency': 'USD',
                    'apikey': API_KEY
                }
            ).json()['Realtime Currency Exchange Rate']['5. Exchange Rate']
        )

    else:
        current_price = quote_df.loc[0, 'adjusted_close']
        yesterdays_price = quote_df.loc[1, 'adjusted_close']

    return current_price, current_price - yesterdays_price


def parse_csv_quote(response_text, max_rows=5):
    csv = [line.split(',')
           for line in response_text.splitlines()[:(max_rows + 1)]
           if line]
    return pd.DataFrame(csv[1:], columns=csv[0], dtype=float)


def format_ticker(symbol, current_price, price_diff):
    diff_pct = 100.0 * price_diff / current_price
    start_color, end_color = get_color_tags_for_percent(diff_pct)
    return f'{symbol}: {current_price:.2f} ({start_color}{diff_pct:+.1f}%{end_color})'


def is_cryptocurrency(symbol):
    return symbol in ['BTC', 'LTC', 'ETH']


def get_color_tags_for_percent(percent, style='lemonbar'):
    if percent > 1.0:
        color = '#33ff33'
    elif percent > 0:
        color = '#77aa77'
    elif percent > -1.0:
        color = '#dd5555'
    else:
        color = '#ff3333'

    if style == 'pango':
        return (f'<span color="{color}">', '</span>')
    elif style == 'lemonbar':
        return (f'%{{F{color}}}', '%{F-}')

    raise ValueError('Invalid style')


if __name__ == '__main__':
    symbols = sys.argv[1:] if sys.argv[1:] else SYMBOLS
    quotes = map(get_quote, symbols)
    tickers = [format_ticker(symbol, *quote)
               for symbol, quote in zip(symbols, quotes)]
    print(' | '.join(tickers))
