#!/bin/sh

# 1. 目的のファイルパスを定義
SECRET_PATH="../UNCHILOG/Model/InAppPurchase/SecretProductIdKey.swift"
ADS_KEY_PATH="../UNCHILOG/Model/Key/AdMobAdsKey.swift"
FIREBASE_PATH="../GoogleService-Info.plist"

# 2. ディレクトリが存在しない場合は作成
mkdir -p "$(dirname "$SECRET_PATH")"
mkdir -p "$(dirname "$ADS_KEY_PATH")"
mkdir -p "$(dirname "$FIREBASE_PATH")"

# 3. SecretProductIdKey の復元
if [ -n "$SECRET_PRODUCT_ID_KEY_CONTENT" ]; then
    echo "$SECRET_PRODUCT_ID_KEY_CONTENT" | base64 -d > "$SECRET_PATH"
    echo "✅ SecretProductIdKey.swift has been created from environment variable."
else
    echo "❌ Error: SECRET_PRODUCT_ID_KEY_CONTENT is not set in Xcode Cloud."
    exit 1
fi

# 3. AdMobAdsKey.swift の復元
if [ -n "$SECRET_ADMOB_ADS_KEY" ]; then
    echo "$SECRET_ADMOB_ADS_KEY" | base64 -d > "$ADS_KEY_PATH"
    echo "✅ AdMobAdsKey.swift restored."
else
    echo "❌ Error: SECRET_ADMOB_ADS_KEY is not set in Xcode Cloud."
    exit 1
fi

# GoogleService-Info.plist の復元
if [ -n "$GOOGLE_SERVICE_INFO" ]; then
    echo "$GOOGLE_SERVICE_INFO" | base64 -d > "$FIREBASE_PATH"
    echo "✅ GoogleService-Info.plist restored."
else
    echo "❌ Error: GOOGLE_SERVICE_INFO is not set in Xcode Cloud."
    exit 1
fi
