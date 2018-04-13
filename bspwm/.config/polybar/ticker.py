#!/usr/bin/env python
import sys

import requests
import pandas as pd

from ticker_config import API_KEY, SYMBOLS


def get_quote(symbol, max_rows=None):
    if is_cryptocurrency(symbol):
        # The DIGITAL_CURRENCY_DAILY endpoint does not show prices for the
        # current day.  INTRADAY reports every 5 minutes, so we collect enough
        # samples to get us the "closing" price from yesterday.
        # (24 * 60 / 5 = 288, rounded to an even 300.)
        max_rows = 300 if max_rows is None else max_rows
        params = {'function': 'DIGITAL_CURRENCY_INTRADAY',
                  'market': 'USD',
                  'symbol': symbol,
                  'datatype': 'csv',
                  'apikey': API_KEY}
    else:
        max_rows = 5 if max_rows is None else max_rows
        params = {'function': 'TIME_SERIES_DAILY_ADJUSTED',
                  'symbol': symbol,
                  'datatype': 'csv',
                  'apikey': API_KEY}

    response = requests.get('https://www.alphavantage.co/query', params=params)

    csv = [line.split(',')
           for line in response.text.splitlines()[:max_rows]
           if line]

    df = pd.DataFrame(csv[1:], columns=csv[0], dtype=float)

    if is_cryptocurrency(symbol):
        # Find yesterday's final record and create a new DataFrame with
        # just that record and the latest one.
        df.timestamp = pd.to_datetime(df.timestamp)
        yesterday = pd.datetime.now().day - 1
        yesterday_last_idx = df[df.timestamp.dt.day == yesterday].iloc[0].name
        df = df.iloc[[0, yesterday_last_idx]].reset_index()
        # The API seems to return duplicate OHLC columns. While the values
        # appear to be duplicates, we'll average the two columns to be safe.
        # We'll name the resulting column the same as the column used for
        # stocks.
        df['adjusted_close'] = df['price (USD)'].mean(axis=1)

    return df


def calculate_movement(quote_df):
    current_price = quote_df.loc[0, 'adjusted_close']
    yesterdays_price = quote_df.loc[1, 'adjusted_close']
    return current_price, current_price - yesterdays_price


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
    movements = map(calculate_movement, quotes)
    tickers = [format_ticker(symbol, *movement)
               for symbol, movement in zip(symbols, movements)]
    print(' | '.join(tickers))
