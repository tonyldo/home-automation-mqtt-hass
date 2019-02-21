#!/bin/ash
set -e

echo "Starting Home Assistant configuration..."

if ( [ -z "${FRESHINSTALL}" ] ); then
   echo "Not deleting previous configuration..."
else
   echo "Deleting previous configuration..."
   rm -rf /config/* 
fi

if [ ! -f /config/configuration.yaml ]; then
   echo "Creating new configurations files..."      
   cp /usr/src/app/homeassistant/scripts/ensure_config.py /usr/src/app/

   echo "if __name__ == '__main__':"  >> ensure_config.py
   echo "    run(None)" >> ensure_config.py

   python /usr/src/app/ensure_config.py --config /config --script ensure_config

   echo " " >> /config/configuration.yaml

   echo " " >> /config/configuration.yaml
   echo "telegram_bot:" >> /config/configuration.yaml 
   echo "  - platform: polling" >> /config/configuration.yaml
   echo "    api_key: 771704016:AAF3a2s_ZnrgXN7b4jTJH3ioIguRT8rTfsQ" >> /config/configuration.yaml
   echo "    allowed_chat_ids:" >> /config/configuration.yaml
   echo "      - -341894634" >> /config/configuration.yaml
   echo " " >> /config/configuration.yaml
   echo "notify:" >> /config/configuration.yaml
   echo "  - name: jarvis" >> /config/configuration.yaml
   echo "    platform: telegram" >> /config/configuration.yaml
   echo "    chat_id: -341894634" >> /config/configuration.yaml

   sed '1d' /config/automations.yaml > /config/automations.tmp; mv /config/automations.tmp /config/automations.yaml
   echo " "  >> /config/automations.yaml
   echo "  - alias: 'Rainy Day'" >> /config/automations.yaml 
   echo "    trigger:" >> /config/automations.yaml
   echo "      - platform: state" >> /config/automations.yaml
   echo "        entity_id: sensor.weather" >> /config/automations.yaml
   echo "        to: 'c'" >> /config/automations.yaml
   echo "    action:" >> /config/automations.yaml
   echo "      service: notify.jarvis" >> /config/automations.yaml
   echo "      data:" >> /config/automations.yaml
   echo "        title: 'Está chovendo'" >> /config/automations.yaml
   echo "        message: 'Verifique as janelas.'" >> /config/automations.yaml
fi

python -m homeassistant --config /config
exec "$@"

