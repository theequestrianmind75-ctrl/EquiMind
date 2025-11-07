import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { useAuthStore } from '../lib/store';

export default function RootLayout() {
  const loadUser = useAuthStore((state) => state.loadUser);

  useEffect(() => {
    loadUser();
  }, []);

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
