import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

const ADMIN_PASSWORD = 'equimind2025';
const API_URL = 'https://rider-tools.preview.emergentagent.com/api';

export default function TestAdmin() {
  const [tools, setTools] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchTools();
  }, []);

  const fetchTools = async () => {
    try {
      const response = await fetch(`${API_URL}/admin/mental-strategies`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: ADMIN_PASSWORD })
      });
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const data = await response.json();
      setTools(data);
      setError('');
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#375B50" />
        <Text style={styles.loadingText}>Loading tools...</Text>
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView style={styles.container}>
        <Text style={styles.errorText}>Error: {error}</Text>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>✅ Database Test - {tools.length} Tools Found</Text>
      <ScrollView style={styles.scrollView}>
        {tools.map((tool, index) => (
          <View key={tool.id} style={styles.toolCard}>
            <Text style={styles.toolNumber}>#{index + 1}</Text>
            <Text style={styles.toolName}>{tool.name}</Text>
            <Text style={styles.toolCategory}>{tool.category}</Text>
            <Text style={styles.toolInstructions}>
              {tool.instructions?.substring(0, 150)}...
            </Text>
          </View>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8fafc',
    padding: 16,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 16,
    textAlign: 'center',
  },
  loadingText: {
    marginTop: 16,
    color: '#64748b',
    textAlign: 'center',
  },
  errorText: {
    color: '#ef4444',
    fontSize: 16,
    textAlign: 'center',
  },
  scrollView: {
    flex: 1,
  },
  toolCard: {
    backgroundColor: '#ffffff',
    padding: 16,
    marginBottom: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  toolNumber: {
    fontSize: 12,
    color: '#94a3b8',
    marginBottom: 4,
  },
  toolName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 4,
  },
  toolCategory: {
    fontSize: 14,
    color: '#375B50',
    marginBottom: 8,
  },
  toolInstructions: {
    fontSize: 13,
    color: '#475569',
    lineHeight: 20,
  },
});
