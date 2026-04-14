#!/bin/sh

# 1. 目的のファイルパスを定義
TARGET_PATH="../UNCHILOG/Model/InAppPurchase/SecretProductIdKey.swift"

# 2. ディレクトリが存在しない場合は作成
mkdir -p "$(dirname "$TARGET_PATH")"

# 3. 環境変数の内容をファイルに書き出す
if [ -n "$SECRET_PRODUCT_ID_KEY_CONTENT" ]; then
    echo "$SECRET_PRODUCT_ID_KEY_CONTENT" > "$TARGET_PATH"
    echo "✅ SecretProductIdKey.swift has been created successfully."
else
    echo "❌ Error: SECRET_PRODUCT_ID_KEY_CONTENT is not set."
    exit 1
fi
