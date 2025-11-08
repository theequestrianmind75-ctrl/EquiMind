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
        <ActivityIndicator size="large" color="#000000" />
        <Text style={styles.text}>Loading The Equestrian Mind...</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#A7D2BB',
  },
  backgroundImage: {
    position: 'absolute',
    width: '100%',
    height: '100%',
    opacity: 0.03,
    resizeMode: 'center',
  },
  overlay: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  logo: {
    width: 120,
    height: 120,
    marginBottom: 24,
    resizeMode: 'contain',
  },
  text: {
    marginTop: 16,
    color: '#1e293b',
    fontSize: 16,
    fontWeight: '600',
  },
});
