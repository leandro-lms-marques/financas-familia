#!/bin/bash
# Atualiza regras do Firebase Realtime Database
# Execute este script no terminal do seu Mac

PROJECT="jornada-da-fe-marques"
RULES='{
  "rules": {
    ".read": false,
    ".write": false,
    "families": {
      "$code": {
        ".read": true,
        ".write": true,
        "profiles": { ".indexOn": ["name"] }
      }
    },
    "financas": {
      ".read": true,
      ".write": true
    }
  }
}'

echo "Fazendo login no Firebase..."
firebase login --no-localhost

echo ""
echo "Selecionando projeto..."
firebase use "$PROJECT"

echo "$RULES" > /tmp/firebase-rules.json

echo "Publicando regras..."
firebase database:rules:set /tmp/firebase-rules.json --project "$PROJECT"

echo ""
echo "✅ Pronto! Testando..."
curl -s "https://${PROJECT}-default-rtdb.firebaseio.com/financas/.json" -X PUT -d '"ok"' && echo "Funcionando!" && curl -s -X DELETE "https://${PROJECT}-default-rtdb.firebaseio.com/financas/.json"
