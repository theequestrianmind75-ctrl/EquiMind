// The Equestrian Mind Brand Colors - Light Theme
export const theme = {
  // Primary Colors
  primary: '#2563eb', // Blue from chess piece logo
  primaryLight: '#60a5fa',
  primaryDark: '#1e40af',
  
  // Secondary Colors
  secondary: '#14b8a6', // Teal accent
  secondaryLight: '#5eead4',
  secondaryDark: '#0d9488',
  
  // Backgrounds
  background: '#ffffff', // White background
  backgroundSecondary: '#f8fafc', // Very light gray
  card: '#ffffff',
  cardBorder: '#e2e8f0',
  
  // Text Colors
  text: '#1e293b', // Dark slate for primary text
  textSecondary: '#64748b', // Medium slate for secondary text
  textLight: '#94a3b8', // Light slate for hints/captions
  
  // Status Colors
  success: '#10b981', // Green
  warning: '#f59e0b', // Amber
  error: '#ef4444', // Red
  info: '#3b82f6', // Blue
  
  // Category Colors (for Rider Tools)
  categories: {
    mindfulness: '#10b981', // Green
    breathing: '#3b82f6', // Blue
    emotional: '#f59e0b', // Amber
    grounding: '#06b6d4', // Cyan
    somatic: '#8b5cf6', // Purple
    tapping: '#ec4899', // Pink
    horseRider: '#14b8a6', // Teal
  },
  
  // Shadows
  shadow: {
    sm: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.05,
      shadowRadius: 2,
      elevation: 1,
    },
    md: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
      elevation: 2,
    },
    lg: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.15,
      shadowRadius: 8,
      elevation: 4,
    },
  },
};
