#!/bin/bash

# ConvertX Fly.io Deployment Setup Script

echo "🚀 ConvertX Fly.io Deployment Setup"
echo "==================================="
echo ""

# Check if fly CLI is installed
if ! command -v fly &> /dev/null; then
    echo "❌ Fly CLI not found. Please install it first:"
    echo "   curl -L https://fly.io/install.sh | sh"
    exit 1
fi

echo "✅ Fly CLI found"
echo ""

# Check if logged in
if ! fly auth whoami &> /dev/null; then
    echo "🔐 Please log in to Fly.io:"
    fly auth login
fi

echo "✅ Logged in to Fly.io"
echo ""

APP_NAME="convertx-spring-sound-7363"

# Create volume if it doesn't exist
echo "📦 Ensuring persistent storage volume exists..."
if ! fly volumes list -a $APP_NAME | grep -q "convertx_data"; then
    fly volumes create convertx_data --size 1 -a $APP_NAME --region dfw
else
    echo "✅ Volume 'convertx_data' already exists"
fi

echo ""
echo "🔑 Creating deploy token for GitHub Actions..."
echo "Run this command and copy the token:"
echo ""
echo "   fly tokens create deploy -a $APP_NAME"
echo ""
echo "Then add it to your GitHub repository:"
echo "1. Go to: https://github.com/uakbr/ConvertX/settings/secrets/actions"
echo "2. Click 'New repository secret'"
echo "3. Name: FLY_API_TOKEN"
echo "4. Value: [paste the token]"
echo ""
echo "📝 Next steps:"
echo "1. Create the deploy token (command above)"
echo "2. Add it to GitHub Secrets"
echo "3. Commit and push your changes"
echo "4. The GitHub Action will deploy automatically"
echo ""
echo "Your app will be available at: https://$APP_NAME.fly.dev"
