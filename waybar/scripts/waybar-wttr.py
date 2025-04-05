#!/usr/bin/env python3
import requests
import json
from datetime import datetime, timedelta, UTC
import sys

latitude = -6.8897849
longitude = -38.5570389

def get_temp_icon(temp):
    if temp <= 18:
        return "🥶"
    elif temp < 20:
        return "❄️"
    elif temp < 27:
        return "🌡️"
    else:
        return "🔥"

def icon_from_symbol(symbol):
    icons = {
        'clearsky_day': '',
        'clearsky_night': '',
        'cloudy': '',
        'fair_day': '',
        'fair_night': '󰖔',
        'fog': '󰖑',
        'heavyrain': '',
        'heavyrainandthunder': '󰙾',
        'heavysnow': '󰼶',
        'heavysnowandthunder': '❄️⚡',
        'lightrain': '󰙾',
        'lightrainandthunder': '󰙾',
        'lightsnow': '🌨️',
        'partlycloudy_day': '',
        'partlycloudy_night': '󰼱',
        'rain': '',
        'rainandthunder': '',
        'rainshowers_day': '',
        'rainshowers_night': '',
        'snow': '',
        'snowandthunder': '',
        'sleet': '',
    }
    for key in icons:
        if symbol.startswith(key):
            return icons[key]
    return '❓'

def extract_min_max(timeseries, target_date):
    temps = []
    for item in timeseries:
        time = datetime.fromisoformat(item['time'].replace("Z", "+00:00")).astimezone(UTC)
        if time.date() != target_date:
            continue
        temp = item['data'].get('instant', {}).get('details', {}).get('air_temperature')
        if temp is not None:
            temps.append(temp)
    return (min(temps), max(temps)) if temps else ("?", "?")

def get_weather():
    headers = {"User-Agent": "weather-script-example/1.0"}
    url = f"https://api.met.no/weatherapi/locationforecast/2.0/complete?lat={latitude}&lon={longitude}"
    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        data = response.json()
        now = datetime.now(UTC)
        timeseries = data['properties']['timeseries']

        current = timeseries[0]['data']['instant']['details']
        temp = current.get('air_temperature')
        humidity = current.get('relative_humidity')
        pressure = current.get('air_pressure_at_sea_level')
        wind_speed = current.get('wind_speed')
        wind_dir = current.get('wind_from_direction')

        current_symbol = timeseries[0]['data'].get('next_1_hours', {}).get('summary', {}).get('symbol_code', '')
        emoji = icon_from_symbol(current_symbol)

        summary = f"{emoji} {round(temp)}°C"

        tooltip_lines = [
            f"Now - {now.strftime('%Y-%m-%d %H:%M UTC')}",
            f"Temp: {temp}°C {get_temp_icon(temp)}",
            f"Humidity: {humidity}%",
            f"Wind: {wind_speed} m/s ({wind_dir}°)",
            f"Pressure: {pressure} hPa",
            ""
        ]

        today = now.date()
        tomorrow = today + timedelta(days=1)
        min_today, max_today = extract_min_max(timeseries, today)
        min_tomorrow, max_tomorrow = extract_min_max(timeseries, tomorrow)

        tooltip_lines.extend([
            f"📅 Today",
            f"Min: {min_today}°C  Max: {max_today}°C",
            "",
            f"📅 Tomorrow",
            f"Min: {min_tomorrow}°C  Max: {max_tomorrow}°C",
            "",
            f"🕐 Next hours:"
        ])

        hourly_data = []
        for item in timeseries[1:]:
            time = datetime.fromisoformat(item['time'].replace("Z", "+00:00")).astimezone(UTC)
            if time > now + timedelta(hours=8):
                break
            if time < now:
                continue
            hour = time.strftime('%Hh')
            instant = item['data'].get('instant', {}).get('details', {})
            next_temp = instant.get('air_temperature', '?')
            symbol = item['data'].get('next_1_hours', {}).get('summary', {}).get('symbol_code', '?')
            emoji = icon_from_symbol(symbol)
            tooltip_lines.append(f"{hour}: {emoji} {next_temp}°C")
            try:
                temp_value = float(next_temp)
            except:
                temp_value = None
            if temp_value is not None:
                hourly_data.append({"hour": hour, "temp": temp_value})

        result = {
            "text": summary,
            "tooltip": "\n".join(tooltip_lines),
            "hourly": hourly_data
        }
        print(json.dumps(result))
    except Exception as e:
        result = {"text": "⚠️", "tooltip": f"Weather error: {e}"}
        print(json.dumps(result))
        print(f"[Error] {e}", file=sys.stderr)

if __name__ == "__main__":
    get_weather()
