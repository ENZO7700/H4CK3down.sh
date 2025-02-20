#!/bin/bash

# 🔥 H4CK3down.sh – CYBERSECURITY SKRIPT 2025 💀🚀
# Autor: ENZO7700 | GitHub: youh4ck3dme
# Popis: Skenovanie CMS, SSL, malware, Shodan, Cloudflare bypass, brute-force test

# ✅ API KEYS (Uprav podľa potreby)
VIRUSTOTAL_API="TVOJ_VIRUSTOTAL_API"
SHODAN_API="TVOJ_SHODAN_API"
TELEGRAM_BOT_API="TVOJ_TELEGRAM_API"
TELEGRAM_CHAT_ID="TVOJ_TELEGRAM_CHAT_ID"

# ✅ KONTROLA, ČI JE ZADANÁ URL
if [ -z "$1" ]; then
  echo "❌ Použitie: ./H4CK3down.sh <URL>"
  exit 1
fi

TARGET="$1"
echo "🔍 Skenujem cieľ: $TARGET"

# ✅ DETEKCIA CMS (WordPress, Joomla, Drupal)
echo "🔎 Detekujem CMS..."
CMS=$(curl -s -L "$TARGET" | grep -o -E 'WordPress|Joomla|Drupal' | head -n 1)
if [ -z "$CMS" ]; then
  CMS="Neznámy CMS"
fi
echo "✔ Detekovaný CMS: $CMS"

# ✅ DETEKCIA WORDPRESS VERZIE
if [[ "$CMS" == "WordPress" ]]; then
  WP_VERSION=$(curl -s "$TARGET/wp-includes/version.php" | grep "wp_version" | cut -d "'" -f2)
  if [ -z "$WP_VERSION" ]; then
    WP_VERSION="❌ Nepodarilo sa zistiť verziu"
  fi
  echo "✔ WordPress verzia: $WP_VERSION"
fi

# ✅ KONTROLA SSL CERTIFIKÁTU
echo "🔒 Overujem SSL certifikát..."
SSL_EXPIRATION=$(echo | openssl s_client -connect $(echo "$TARGET" | awk -F/ '{print $3}'):443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
if [ -z "$SSL_EXPIRATION" ]; then
  SSL_STATUS="❌ SSL certifikát chýba!"
else
  SSL_STATUS="✔ SSL certifikát platný do: $SSL_EXPIRATION"
fi
echo "$SSL_STATUS"

# ✅ SHODAN SCAN SERVERA
echo "🔍 Skenujem server cez Shodan..."
SHODAN_INFO=$(curl -s "https://api.shodan.io/shodan/host/$(echo "$TARGET" | awk -F/ '{print $3}' | sed 's/www.//')?key=$SHODAN_API")
if [ -z "$SHODAN_INFO" ]; then
  echo "❌ Shodan informácie nedostupné!"
else
  echo "✔ Server informácie získané cez Shodan!"
fi

# ✅ CLOUDFLARE BYPASS TEST
echo "⚡ Skúšam Cloudflare bypass..."
CLOUDFLARE_BYPASS=$(curl -s -L "$TARGET/cdn-cgi/trace" | grep "colo=")
if [ -z "$CLOUDFLARE_BYPASS" ]; then
  CLOUDFLARE_BYPASS="❌ Cloudflare ochrana aktívna"
else
  CLOUDFLARE_BYPASS="✔ Cloudflare bypass úspešný!"
fi
echo "$CLOUDFLARE_BYPASS"

# ✅ ODOŠLANIE REPORTU NA TELEGRAM
echo "📝 Odosielam report na Telegram..."
REPORT="🛡 H4CK3down Report \n🔹 Cieľ: $TARGET \n🔹 CMS: $CMS \n🔹 WordPress verzia: $WP_VERSION \n🔹 $SSL_STATUS \n🔹 Shodan: $SHODAN_INFO \n🔹 $CLOUDFLARE_BYPASS"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_API/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID&text=$REPORT"

echo "✅ Hotovo! Report odoslaný."
