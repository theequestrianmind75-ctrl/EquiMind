import { useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Image } from 'react-native';
import { useRouter } from 'expo-router';
import { useAuthStore } from '../lib/store';

export default function Index() {
  const router = useRouter();
  const { user, loading } = useAuthStore();

  useEffect(() => {
    if (!loading) {
      if (user) {
        router.replace('/(tabs)/home');
      } else {
        router.replace('/(auth)/login');
      }
    }
  }, [user, loading]);

  return (
    <View style={styles.container}>
      <Image
        source={require('../assets/images/horse-head-logo.png')}
        style={styles.backgroundImage}
      />
      <View style={styles.overlay}>
        <Image
          source={require('../assets/images/horse-head-logo.png')}
          style={styles.logo}
        />
        <ActivityIndicator size="large" color="#3b82f6" />
        <Text style={styles.text}>Loading The Equestrian Mind...</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a',
  },
  backgroundImage: {
    position: 'absolute',
    width: '100%',
    height: '100%',
    opacity: 0.3,
  },
  overlay: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    marginTop: 16,
    color: '#f1f5f9',
    fontSize: 16,
    fontWeight: '600',
  },
});
