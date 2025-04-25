#!/bin/bash

# Herramienta casera mejorada para investigar URLs .onion en Kali

read -p "Introduce la URL .onion (ejemplo: http://xxxxxx.onion): " onion

echo ""
echo "=============================="
echo " Empezando análisis de $onion"
echo "=============================="
echo ""

# Probar conexión
echo "[+] Probando conexión..."
torsocks curl --socks5-hostname 127.0.0.1:9050 --silent --connect-timeout 20 "$onion" > /tmp/onion_source.txt

# Comprobar si respondió
if grep -q "<html" /tmp/onion_source.txt; then
    echo "[+] La web responde correctamente."
else
    echo "[-] No se pudo conectar o la web no responde."
    rm /tmp/onion_source.txt
    exit 1
fi

# Buscar correos electrónicos
echo ""
echo "[+] Buscando posibles correos electrónicos..."
grep -Eio '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}' /tmp/onion_source.txt | sort -u || echo "No encontrados."

# Buscar enlaces internos .onion
echo ""
echo "[+] Buscando enlaces internos .onion..."
grep -Eo '(http|https)://[a-zA-Z0-9]{16,56}\.onion' /tmp/onion_source.txt | sort -u || echo "No encontrados."

# Buscar palabras clave (admin, login, etc)
echo ""
echo "[+] Buscando palabras sensibles (admin, login, register)..."
grep -Ei 'admin|login|register|signup|signin|password' /tmp/onion_source.txt | sort -u || echo "No encontrados."
