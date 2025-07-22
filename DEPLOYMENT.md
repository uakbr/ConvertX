# ConvertX Deployment Guide

This guide covers various deployment options for ConvertX using GitHub Actions.

## 🚀 Quick Start

ConvertX is a server-side application that requires system dependencies (FFmpeg, ImageMagick, etc.), so it cannot be deployed as a static site on GitHub Pages. Here are the recommended deployment options:

## 📦 Option 1: Deploy to Fly.io (Recommended for Easy Setup)

[Fly.io](https://fly.io) offers a generous free tier and easy deployment.

### Setup Steps:
1. Sign up at [fly.io](https://fly.io) and install the CLI
2. Run `fly auth login` locally
3. Run `fly launch` in your project directory (it will use the existing `fly.toml`)
4. Create a deploy token: `fly tokens create deploy -a convertx-spring-sound-7363`
5. Add the token to GitHub Secrets:
   - Go to Settings → Secrets → Actions
   - Add `FLY_API_TOKEN` with your token

### Deploy:
Push to `main` branch or trigger manually from Actions tab.

## 🚂 Option 2: Deploy to Railway

[Railway](https://railway.app) provides simple deployment with automatic builds.

### Setup Steps:
1. Sign up at [railway.app](https://railway.app)
2. Create a new project from GitHub
3. Get your Railway token from Account Settings
4. Add to GitHub Secrets as `RAILWAY_TOKEN`

### Deploy:
Push to `main` branch or trigger manually.

## 🐳 Option 3: Docker Registry + Any Cloud

The Docker workflow builds and pushes images to GitHub Container Registry (ghcr.io).

### Setup Steps:
No additional setup needed! The workflow uses the built-in `GITHUB_TOKEN`.

### Deploy:
1. Images are automatically built and pushed on every push to `main`
2. Pull and run on any Docker-compatible host:
   ```bash
   docker pull ghcr.io/uakbr/convertx:latest
   docker run -d -p 3000:3000 -v ./data:/app/data ghcr.io/uakbr/convertx:latest
   ```

## 🖥️ Option 4: Deploy to Your Own VPS

For full control, deploy to your own server.

### Setup Steps:
1. Set up a VPS (DigitalOcean, Linode, AWS EC2, etc.)
2. Install Docker and Docker Compose
3. Clone your repo on the server
4. Add these secrets to GitHub:
   - `VPS_HOST`: Your server IP/domain
   - `VPS_USER`: SSH username (usually `root` or `ubuntu`)
   - `VPS_SSH_KEY`: Your private SSH key

### Deploy:
Push to `main` branch. The workflow will SSH into your server and redeploy.

## 🔧 Configuration

### Environment Variables
Configure these in your deployment platform:

```env
ACCOUNT_REGISTRATION=true        # Allow new users to register
JWT_SECRET=your-secret-key      # Set a secure secret
HTTP_ALLOWED=false              # Keep false for production
ALLOW_UNAUTHENTICATED=false     # Require authentication
AUTO_DELETE_EVERY_N_HOURS=1     # Auto-cleanup old files
TZ=UTC                          # Your timezone
```

### Persistent Storage
ConvertX needs persistent storage for the `/app/data` directory:
- **Fly.io**: Configured in `fly.toml` with volumes
- **Railway**: Use Railway volumes
- **Docker**: Mount a local directory: `-v ./data:/app/data`
- **VPS**: Already configured in `compose.yaml`

## 🚦 GitHub Actions Workflows

### Available Workflows:
1. **docker-build-and-push.yml**: Builds and pushes Docker images
2. **deploy-fly-io.yml**: Deploys to Fly.io
3. **deploy-railway.yml**: Deploys to Railway
4. **deploy-vps.yml**: Deploys to your own server
5. **release.yml**: Creates GitHub releases with Docker images

### Manual Deployment:
All workflows support `workflow_dispatch` - trigger them manually from the Actions tab.

## 📝 Free Tier Limits

- **Fly.io**: 3 shared-cpu-1x VMs, 3GB persistent storage
- **Railway**: $5 free credit/month, ~500 hours of usage
- **GitHub Container Registry**: Free for public repos, 500MB storage for private

## 🎯 Recommended Setup

For most users, I recommend:
1. **Fly.io** for easy, free hosting with good performance
2. **GitHub Container Registry** for image storage
3. Keep the Docker workflow for flexibility

This gives you:
- Automatic deployments on push
- Free hosting with reasonable limits
- Easy migration to other platforms
- Professional CI/CD setup

## 🔒 Security Notes

1. Always use HTTPS in production (Fly.io and Railway handle this automatically)
2. Set a strong `JWT_SECRET`
3. Keep `HTTP_ALLOWED=false` in production
4. Consider using a reverse proxy (nginx/caddy) on VPS deployments
5. Regularly update dependencies and base images

## 🆘 Troubleshooting

### Common Issues:
1. **Build fails**: Check if all dependencies are in `package.json`
2. **App crashes**: Check logs in your deployment platform
3. **File uploads fail**: Ensure persistent storage is configured
4. **Authentication issues**: Verify `JWT_SECRET` is set

### Getting Logs:
- **Fly.io**: `fly logs`
- **Railway**: Check dashboard logs
- **Docker**: `docker logs <container-id>`
- **VPS**: `docker compose logs`

## 📚 Next Steps

1. Choose your deployment platform
2. Set up the required secrets in GitHub
3. Push to `main` or trigger a manual deployment
4. Access your app at the provided URL
5. Create your first user account

Happy converting! 🎉
