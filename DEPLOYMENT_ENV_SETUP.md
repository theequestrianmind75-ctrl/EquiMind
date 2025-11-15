# Production Environment Variables Required

When deploying to Emergent, you need to set these environment variables in the deployment platform:

## Required Environment Variables:

### MongoDB (Provided by Emergent):
```
MONGO_URL=<your-atlas-mongodb-connection-string>
DB_NAME=equimind
```

### Application Secrets:
```
JWT_SECRET_KEY=<generate-a-secure-random-string>
ADMIN_PASSWORD=equimind2025
```

## How to Set in Emergent:

1. Go to your deployment settings
2. Find "Environment Variables" section
3. Add the variables above
4. Redeploy the application

## Notes:
- The `.env` file in the repo is for LOCAL DEVELOPMENT ONLY
- Production uses environment variables set in the deployment platform
- `load_dotenv()` will NOT override existing environment variables
- Our code uses `os.environ.get()` with fallbacks for local dev

## Current Status:
- ✅ Code is ready for environment variables
- ⚠️  Need to set MONGO_URL in production deployment
- ⚠️  Need to set DB_NAME=equimind in production
