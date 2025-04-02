#!/usr/bin/env python

import json
import requests
import sys
from datetime import datetime
from time import sleep

location = "-6.8897849,-38.5570389"

WEATHER_CODES = {
    '113': '☀️',   # Clear
    '116': '⛅',    # Partly cloudy
    '119': '☁️',    # Cloudy
    '122': '☁️',    # Overcast
    '143': '🌫️',    # Fog
    '176': '🌦️',    # Patchy rain
    '179': '🌨️',    # Patchy snow
    '182': '🌧️',    # Patchy sleet
    '185': '🌧️',    # Patchy freezing drizzle
    '200': '⛈️',     # Thundery outbreaks
    '227': '🌨️',    # Blowing snow
    '230': '❄️',     # Blizzard
    '248': '🌫️',     # Fog
    '260': '🌫️',     # Freezing fog
    '263': '🌦️',     # Patchy light drizzle
    '266': '🌦️',     # Light drizzle
    '281': '🌧️',     # Freezing drizzle
    '284': '🌧️',     # Heavy freezing drizzle
    '293': '🌦️',     # Patchy light rain
    '296': '🌦️',     # Light rain
    '299': '🌧️',     # Moderate rain
    '302': '🌧️',     # Heavy rain
    '305': '🌧️',     # Heavy rain
    '308': '🌧️',     # Heavy rain
    '311': '🌧️',     # Light freezing rain
    '314': '🌧️',     # Moderate/Heavy freezing rain
    '317': '🌧️',     # Light sleet
    '320': '🌨️',     # Moderate/Heavy sleet
    '323': '🌨️',     # Patchy light snow
    '326': '🌨️',     # Light snow
    '329': '❄️',      # Patchy moderate snow
    '332': '❄️',      # Moderate snow
    '335': '❄️',      # Patchy heavy snow
    '338': '❄️',      # Heavy snow
    '350': '🌧️',      # Ice pellets
    '353': '🌦️',      # Light rain shower
    '356': '🌧️',      # Moderate/Heavy rain shower
    '359': '🌧️',      # Torrential rain shower
    '362': '🌨️',      # Light sleet showers
    '365': '🌨️',      # Moderate/Heavy sleet showers
    '368': '🌨️',      # Light snow showers
    '371': '❄️',      # Moderate/Heavy snow showers
    '374': '🌨️',      # Light showers of ice pellets
    '377': '🌨️',      # Moderate/Heavy showers of ice pellets
    '386': '⛈️',      # Patchy light rain with thunder
    '389': '⛈️',      # Moderate/Heavy rain with thunder
    '392': '⛈️',      # Patchy light snow with thunder
    '395': '⛈️'       # Moderate/Heavy snow with thunder
}

def format_time(time_str):
    """Convert API time format (like '300' or '1430') to 12h format"""
    try:
        time_obj = datetime.strptime(time_str.zfill(4), "%H%M")
        return time_obj.strftime("%-I%p").lower()
    except ValueError:
        return time_str

def get_weather():
    """Fetch and validate weather data with retries"""
    url = "https://wttr.in/#{location}"
    headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0",
        "Accept": "application/json"
    }
    
    for attempt in range(3):
        try:
            response = requests.get(
                url,
                params={"format": "j1", "lang": "en"},
                headers=headers,
                timeout=10
            )
            response.raise_for_status()
            
            weather = response.json()
            
            # Validate response structure
            required_keys = ['current_condition', 'weather']
            if not all(key in weather for key in required_keys):
                raise ValueError("Invalid API response structure")
                
            return weather
            
        except (requests.RequestException, json.JSONDecodeError) as e:
            if attempt == 2:
                raise
            sleep(2 ** attempt)
    
    raise Exception("Failed after 3 attempts")

def build_tooltip(weather):
    """Construct detailed tooltip text"""
    current = weather['current_condition'][0]
    tooltip = [
        f"<b>{current['weatherDesc'][0]['value']} {current['temp_C']}°C</b>",
        f"Feels like: {current['FeelsLikeC']}°C",
        f"Wind: {current['windspeedKmph']} km/h ({current['winddir16Point']})",
        f"Humidity: {current['humidity']}%",
        f"Pressure: {current['pressure']} hPa"
    ]
    
    for i, day in enumerate(weather['weather'][:2]):
        date = datetime.strptime(day['date'], "%Y-%m-%d").strftime("%a %-d %b")
        title = "Today" if i == 0 else "Tomorrow"
        
        tooltip.extend([
            f"\n<b>{title} - {date}</b>",
            f"⬆️ {day['maxtempC']}°C ⬇️ {day['mintempC']}°C",
            f"🌅 {day['astronomy'][0]['sunrise']} 🌇 {day['astronomy'][0]['sunset']}"
        ])
        
        for hour in day['hourly']:
            if i == 0 and int(hour['time']) < datetime.now().hour - 1:
                continue
            tooltip.append(
                f"{format_time(hour['time'])} "
                f"{WEATHER_CODES.get(hour['weatherCode'], '?')} "
                f"{hour['tempC']}°C "
                f"({format_chances(hour)})"
            )
    
    return "\n".join(tooltip)

def format_chances(hour):
    """Format precipitation chances with icons"""
    chances = {
        "chanceofrain": "🌧️",
        "chanceofsnow": "❄️",
        "chanceofsunshine": "☀️",
        "chanceofthunder": "⚡"
    }
    return " ".join(
        f"{emoji}{hour[key]}%"
        for key, emoji in chances.items()
        if int(hour.get(key, 0)) > 0
    )

def main():
    data = {"text": "⚠️", "tooltip": "Weather data unavailable"}
    
    try:
        weather = get_weather()
        current = weather['current_condition'][0]
        
        data['text'] = (
            f"{WEATHER_CODES.get(current['weatherCode'], '?')} "
            f"{current['temp_C']}°C"
        )
        
        data['tooltip'] = build_tooltip(weather)
        
    except Exception as e:
        data['tooltip'] = f"Weather error: {str(e)}"
        print(f"Weather module error: {e}", file=sys.stderr)
    
    print(json.dumps(data))

if __name__ == "__main__":
    main()