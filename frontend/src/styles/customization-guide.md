# EquiMind Customization Guide

## 🎨 How to Change the Look & Feel

### 1. Colors & Branding

**Primary Colors** (in `/app/frontend/src/App.css`):
- **Emerald Theme** (current): `from-emerald-500 to-teal-600`
- **Blue Theme**: `from-blue-500 to-indigo-600`
- **Purple Theme**: `from-purple-500 to-pink-600`
- **Orange Theme**: `from-orange-500 to-red-600`

**To Change Colors:**
1. Open `/app/frontend/src/App.css`
2. Find `.gradient-bg` class and update:
```css
.gradient-bg {
  background: linear-gradient(135deg, #your-color-1 0%, #your-color-2 100%);
}
```

**Text Gradient:**
```css
.gradient-text {
  background: linear-gradient(135deg, #your-color-1 0%, #your-color-2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

### 2. Fonts

**Current Font**: Figtree (modern, friendly)

**To Change Font:**
1. Update the import in `/app/frontend/src/App.css`:
```css
@import url('https://fonts.googleapis.com/css2?family=YourFont:wght@300;400;500;600;700;800;900&display=swap');
```

2. Update the font-family:
```css
body {
  font-family: 'YourFont', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}
```

**Popular Font Options:**
- **Professional**: `Inter`, `Poppins`, `Roboto`
- **Elegant**: `Playfair Display`, `Crimson Text`, `Source Serif Pro`
- **Playful**: `Fredoka`, `Comfortaa`, `Nunito`
- **Technical**: `Source Code Pro`, `JetBrains Mono`

### 3. Background Patterns

**Current**: Gradient backgrounds
**Options to Add:**

```css
/* Subtle Pattern */
.pattern-bg {
  background-image: radial-gradient(circle at 1px 1px, rgba(255,255,255,0.15) 1px, transparent 0);
  background-size: 20px 20px;
}

/* Mesh Gradient */
.mesh-bg {
  background: linear-gradient(45deg, #ff6b6b, #4ecdc4, #45b7d1, #96ceb4, #ffeaa7);
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;
}
```

### 4. Component Styling

**Card Styles** (in components):
- **Glass**: `bg-white/80 backdrop-blur-sm`
- **Solid**: `bg-white shadow-lg`
- **Gradient**: `bg-gradient-to-br from-white to-gray-50`

**Button Styles:**
- **Primary**: `bg-gradient-to-r from-emerald-500 to-teal-600`
- **Outlined**: `border-2 border-emerald-500 text-emerald-600`
- **Ghost**: `hover:bg-emerald-50 text-emerald-600`

### 5. Logo & Branding

**Current Logo**: Heart icon in gradient circle

**To Change:**
1. Replace the Heart icon in components with your icon
2. Update the gradient colors to match your brand
3. Change "EquiMind" text in:
   - `LandingPage.js`
   - `AuthPage.js`
   - Navigation components

### 6. Images

**Hero Images**: Currently using Unsplash equestrian photos

**To Change:**
1. Replace image URLs in:
   - `LandingPage.js` (heroImages array)
   - `Dashboard.js` (heroImages array)
   - Other components as needed

2. Ensure images are high-resolution (1920x1080 or higher)
3. Use WebP format for better performance

### 7. Animation Preferences

**Current Animations:**
- Hover lift effects
- Breathing circle animation
- Gradient animations
- Fade-in effects

**To Disable Animations** (for accessibility):
Add to CSS:
```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### 8. Layout Options

**Current**: Modern, card-based layout with gradients

**Alternative Layouts:**
1. **Minimal**: Remove gradients, use more white space
2. **Corporate**: Darker colors, more structured
3. **Playful**: Brighter colors, rounded corners
4. **Medical**: Clean whites and blues, professional feel

### 9. Quick Color Schemes

**Scheme 1 - Professional Blue:**
```css
.gradient-bg { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); }
.gradient-text { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); }
```

**Scheme 2 - Warm Orange:**
```css
.gradient-bg { background: linear-gradient(135deg, #ea580c 0%, #dc2626 100%); }
.gradient-text { background: linear-gradient(135deg, #ea580c 0%, #dc2626 100%); }
```

**Scheme 3 - Royal Purple:**
```css
.gradient-bg { background: linear-gradient(135deg, #7c3aed 0%, #a855f7 100%); }
.gradient-text { background: linear-gradient(135deg, #7c3aed 0%, #a855f7 100%); }
```

### 10. Advanced Customization

**Custom CSS Variables** (add to App.css):
```css
:root {
  --primary-color: #10b981;
  --secondary-color: #0d9488;
  --accent-color: #06b6d4;
  --background-color: #f8fafc;
  --text-color: #1e293b;
  --border-radius: 12px;
  --shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}
```

Then use throughout components:
```css
.custom-button {
  background: var(--primary-color);
  border-radius: var(--border-radius);
  box-shadow: var(--shadow);
}
```

### 11. Dark Mode Support

Add dark mode styles:
```css
@media (prefers-color-scheme: dark) {
  :root {
    --background-color: #0f172a;
    --text-color: #f1f5f9;
  }
  
  body {
    background-color: var(--background-color);
    color: var(--text-color);
  }
}
```

## 📱 Responsive Design

The app is built mobile-first with Tailwind CSS. Breakpoints:
- `sm:` - 640px and up
- `md:` - 768px and up  
- `lg:` - 1024px and up
- `xl:` - 1280px and up

## 🚀 Performance Tips

1. **Optimize Images**: Use WebP format, proper sizing
2. **Lazy Loading**: Add `loading="lazy"` to images
3. **Font Loading**: Use `font-display: swap` in CSS
4. **Reduce Animations**: On lower-end devices

## 🎯 Brand Consistency

**Keep Consistent:**
- Color scheme across all components
- Typography hierarchy
- Spacing patterns (4px, 8px, 16px, 24px, 32px)
- Corner radius (8px, 12px, 16px, 24px)
- Shadow depths

**Files to Update for Full Rebrand:**
1. `/app/frontend/src/App.css` - Main styles
2. `/app/frontend/src/components/LandingPage.js` - Hero section
3. `/app/frontend/src/components/AuthPage.js` - Authentication
4. All component files for consistent icons/colors

This guide covers the main customization options. The design system is built to be flexible while maintaining consistency!