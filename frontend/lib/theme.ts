// The Equestrian Mind Brand Colors - Official Brand Theme
export const theme = {
  // Brand Colors
  sage: '#A7D2BB', // Light sage for cards
  darkSage: '#BCCEC8', // Dark sage for alternating cards
  hunter: '#375B50', // Hunter green for accents
  
  // Primary Colors
  primary: '#375B50', // Hunter green
  primaryLight: '#5A8571',
  primaryDark: '#2A463C',
  
  // Backgrounds
  background: '#A7D2BB', // Sage green background
  card: '#ffffff', // White for primary cards/buttons
  cardSecondary: '#BCCEC8', // Dark sage for secondary cards
  cardBorder: '#375B50', // Hunter green borders
  
  // Text Colors
  text: '#1e293b', // Dark slate for primary text
  textSecondary: '#375B50', // Hunter green for secondary text
  textLight: '#64748b', // Gray for hints/captions
  textWhite: '#ffffff', // White text for dark backgrounds
  
  // Logo Color
  logoColor: '#000000', // Black chess piece
  
  // Status Colors
  success: '#375B50', // Hunter green
  warning: '#f59e0b', // Amber
  error: '#dc2626', // Red
  info: '#375B50', // Hunter green
  
  // Category Colors (for Rider Tools)
  categories: {
    mindfulness: '#5A8571', // Light hunter
    breathing: '#375B50', // Hunter green
    emotional: '#8B9D93', // Muted sage
    grounding: '#BCCEC8', // Dark sage
    somatic: '#7FA892', // Mid sage
    tapping: '#6B8679', // Sage-gray
    horseRider: '#375B50', // Hunter green
  },
  
  // Typography
  fonts: {
    heading: 'Playfair Display', // For headings
    body: 'Arimo', // For body text
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
