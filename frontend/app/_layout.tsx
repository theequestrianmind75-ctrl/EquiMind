import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { useAuthStore } from '../lib/store';
import { useFonts, Arimo_400Regular, Arimo_700Bold } from '@expo-google-fonts/arimo';
import { PlayfairDisplay_400Regular, PlayfairDisplay_700Bold } from '@expo-google-fonts/playfair-display';

export default function RootLayout() {
  const loadUser = useAuthStore((state) => state.loadUser);
  
  const [fontsLoaded] = useFonts({
    Arimo_400Regular,
    Arimo_700Bold,
    PlayfairDisplay_400Regular,
    PlayfairDisplay_700Bold,
  });

  useEffect(() => {
    loadUser();
  }, []);

  if (!fontsLoaded) {
    return null;
  }

  return (
    <Stack screenOptions={{ headerShown: false }}>
      <Stack.Screen name="index" />
      <Stack.Screen name="(auth)" />
      <Stack.Screen name="(tabs)" />
      <Stack.Screen name="pre-ride" />
      <Stack.Screen name="during-ride" />
      <Stack.Screen name="post-ride" />
      <Stack.Screen name="strategy-detail" />
    </Stack>
  );
}
