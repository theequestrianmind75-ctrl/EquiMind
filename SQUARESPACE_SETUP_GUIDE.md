# EquiMind Admin Dashboard - Squarespace Setup Guide

## What You Have
A complete, production-ready admin dashboard that includes:
- ✅ Tool Management (Create, Edit, Delete tools)
- ✅ Session Tracking (View all user sessions and details)
- ✅ User Management (View and manage users)
- ✅ Analytics (Usage statistics, popular tools, category distribution)
- ✅ Secure login with your existing admin password: `equimind2025`
- ✅ Mobile-responsive design
- ✅ Real-time data from your production database

## How to Add to Your Squarespace Website (www.equimind.net)

### Option 1: Embed as a Full Page (Recommended)

1. **Log into your Squarespace account** at www.squarespace.com

2. **Create a new page:**
   - Go to Pages → Click the "+" button
   - Select "Blank Page"
   - Name it "Admin Dashboard" or similar

3. **Add a Code Block:**
   - Click "+ Add Section"
   - Select "Code"
   - Paste the ENTIRE contents of `/app/admin-dashboard.html` into the code block

4. **Make the page password-protected (Optional but recommended):**
   - Click the gear icon next to the page name
   - Go to "Advanced" → "Page Password"
   - Set a password (different from your admin password)
   - This adds an extra layer of security

5. **Publish your changes**

6. **Access your dashboard:**
   - Visit: `https://www.equimind.net/admin-dashboard` (or whatever you named the page)
   - Enter the admin password: `equimind2025`

### Option 2: Embed in an Existing Page Section

1. **Edit any existing page** where you want the dashboard

2. **Add a Code Block:**
   - Click where you want to add it
   - Select "Code" from the block options
   - Paste the contents of `/app/admin-dashboard.html`

3. **Save and publish**

## Important Notes

### Security Recommendations:
1. **Keep your admin password secure** - It's currently `equimind2025`
2. **Consider password-protecting the Squarespace page** that hosts the dashboard
3. **Don't share the admin dashboard URL publicly**
4. **Only access from trusted devices**

### Current Admin Password:
- **Password:** `equimind2025`
- **Where it's stored:** `/app/backend/.env` file (ADMIN_PASSWORD variable)
- **To change it:** You'll need to update the backend .env file and redeploy

### What You Can Do:

#### Tool Management:
- View all 205 tools
- Edit tool names, categories, instructions, and durations
- Create new tools
- Delete tools
- Search and filter by category
- Bulk operations supported

#### Session Tracking:
- View all user sessions (currently 40 sessions)
- See which tools were used in each session
- View anxiety/confidence levels
- Check ride details and notes
- Search and filter sessions

#### User Management:
- View all users (currently 17 users)
- See registration dates
- Delete users (with confirmation)
- Search users by email or name

#### Analytics:
- Total users, tools, and sessions
- Recent activity (30-day view)
- Most used tools
- Category distribution
- Visual statistics

## Troubleshooting

### Dashboard won't load:
- Check that you copied the ENTIRE HTML file
- Ensure your Squarespace plan supports custom code (Business plan or higher required)
- Try refreshing the page

### Login fails:
- Verify you're using password: `equimind2025`
- Check browser console for errors (F12)
- Ensure your production API is running at: https://equimind-ride.emergent.host

### Data not showing:
- Confirm you're logged in with the correct password
- Check your internet connection
- Verify the API endpoint is accessible

### CORS errors:
- Your backend already has CORS configured to allow all origins
- If you see CORS errors, contact support

## Technical Details

### API Endpoints Used:
- `POST /api/admin/mental-strategies` - Get all tools
- `POST /api/admin/bulk-update` - Update tools
- `POST /api/admin/tools/create` - Create new tool
- `POST /api/admin/tools/delete` - Delete tool
- `POST /api/admin/users` - Get all users
- `POST /api/admin/user/delete` - Delete user
- `POST /api/admin/sessions/all` - Get all sessions
- `POST /api/admin/analytics` - Get analytics data

All endpoints require the admin password for authentication.

### Backend API URL:
`https://equimind-ride.emergent.host/api`

### Dashboard File Location:
`/app/admin-dashboard.html`

## Need Help?

If you encounter any issues:
1. Check the browser console (F12) for error messages
2. Verify your API is accessible at https://equimind-ride.emergent.host/api/
3. Ensure you're using the correct admin password
4. Contact your development team with specific error messages

---

**Created:** December 2025
**Version:** 1.0.0
**Status:** Production Ready ✅
