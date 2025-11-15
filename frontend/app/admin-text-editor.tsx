import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
  ActivityIndicator,
  Modal,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';

const ADMIN_PASSWORD = 'equimind2025';

export default function AdminTextEditor() {
  const router = useRouter();
  const [strategies, setStrategies] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [authenticated, setAuthenticated] = useState(false);
  const [password, setPassword] = useState('');
  const [editedText, setEditedText] = useState('');
  
  useEffect(() => {
    if (authenticated) {
      fetchStrategies();
    }
  }, [authenticated]);

  const handleAuth = () => {
    if (password === ADMIN_PASSWORD) {
      setAuthenticated(true);
    } else {
      Alert.alert('Incorrect Password');
      setPassword('');
    }
  };

  const fetchStrategies = async () => {
    try {
      const response = await api.post('/admin/mental-strategies', {
        password: ADMIN_PASSWORD
      });
      setStrategies(response.data);
      
      // Convert to text format
      const text = response.data.map((s: any) => {
        return `========================================
TOOL: ${s.name} (ID: ${s.id})
Category: ${s.category} | Duration: ${s.duration_minutes} min
========================================
${s.instructions}

`;
      }).join('\n');
      
      setEditedText(text);
    } catch (error) {
      console.error('Error fetching strategies:', error);
      Alert.alert('Error', 'Failed to load tools');
    } finally {
      setLoading(false);
    }
  };

  const parseAndSave = async () => {
    setSaving(true);
    try {
      // Parse the edited text back into tools
      const toolBlocks = editedText.split('========================================');
      const updates: any[] = [];
      
      for (const block of toolBlocks) {
        if (!block.trim()) continue;
        
        // Extract ID
        const idMatch = block.match(/\(ID: ([^\)]+)\)/);
        if (!idMatch) continue;
        const id = idMatch[1];
        
        // Extract tool name
        const nameMatch = block.match(/TOOL: (.+?) \(ID:/);
        const name = nameMatch ? nameMatch[1].trim() : null;
        
        // Extract instructions (everything after the second line of ===)
        const lines = block.split('\n');
        let instructionsStart = -1;
        for (let i = 0; i < lines.length; i++) {
          if (lines[i].includes('Category:')) {
            instructionsStart = i + 2; // Skip category line and next ===
            break;
          }
        }
        
        if (instructionsStart > 0) {
          const instructions = lines.slice(instructionsStart).join('\n').trim();
          
          updates.push({
            id,
            name,
            instructions
          });
        }
      }
      
      // Send bulk update to backend using admin endpoint
      const response = await api.post('/admin/bulk-update', {
        password: ADMIN_PASSWORD,
        updates
      });
      
      console.log('Save response:', response.data);
      
      // Don't navigate away - just show success and reload data
      Alert.alert(
        'Success', 
        `Updated ${response.data.updated} tools! ${response.data.skipped ? `(${response.data.skipped} skipped)` : ''}`,
        [
          { 
            text: 'OK', 
            onPress: () => {
              // Reload the tools to show updated data
              setLoading(true);
              fetchStrategies();
            }
          }
        ]
      );
    } catch (error: any) {
      console.error('Save error:', error);
      Alert.alert('Error', error.response?.data?.detail || error.message || 'Failed to save changes');
    } finally {
      setSaving(false);
    }
  };

  if (!authenticated) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.authContainer}>
          <Ionicons name="lock-closed" size={64} color="#375B50" />
          <Text style={styles.authTitle}>Admin Text Editor</Text>
          <Text style={styles.authSubtitle}>Enter password to continue</Text>
          <TextInput
            style={styles.passwordInput}
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            placeholder="Password"
            placeholderTextColor="#94a3b8"
            autoFocus
          />
          <TouchableOpacity style={styles.authButton} onPress={handleAuth}>
            <Text style={styles.authButtonText}>Unlock</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.backLink} onPress={() => router.back()}>
            <Text style={styles.backLinkText}>← Back</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#375B50" />
          <Text style={styles.loadingText}>Loading all tools...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1e293b" />
        </TouchableOpacity>
        <Text style={styles.title}>Text Editor - All Tools</Text>
        <TouchableOpacity
          style={[styles.saveButton, saving && styles.saveButtonDisabled]}
          onPress={parseAndSave}
          disabled={saving}
        >
          <Ionicons name="save" size={20} color="#ffffff" />
          <Text style={styles.saveButtonText}>{saving ? 'Saving...' : 'Save All'}</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.infoBar}>
        <Ionicons name="information-circle" size={20} color="#3b82f6" />
        <Text style={styles.infoText}>
          [v2 - FIXED] Edit any text below. Use Ctrl+F to find/replace. Click Save All when done.
        </Text>
      </View>

      <ScrollView style={styles.scrollView}>
        <TextInput
          style={styles.textEditor}
          value={editedText}
          onChangeText={setEditedText}
          multiline
          numberOfLines={100}
          textAlignVertical="top"
          placeholder="Loading tools..."
          placeholderTextColor="#94a3b8"
        />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8fafc',
  },
  authContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  authTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#000000',
    marginTop: 20,
  },
  authSubtitle: {
    fontSize: 14,
    color: '#64748b',
    marginTop: 8,
    marginBottom: 32,
  },
  passwordInput: {
    width: '100%',
    maxWidth: 400,
    backgroundColor: '#ffffff',
    borderWidth: 1,
    borderColor: '#cbd5e1',
    borderRadius: 8,
    padding: 16,
    fontSize: 16,
    color: '#000000',
    marginBottom: 16,
  },
  authButton: {
    backgroundColor: '#375B50',
    paddingVertical: 14,
    paddingHorizontal: 40,
    borderRadius: 8,
  },
  authButtonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '600',
  },
  backLink: {
    marginTop: 24,
  },
  backLinkText: {
    color: '#3b82f6',
    fontSize: 14,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 16,
    color: '#64748b',
    fontSize: 16,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    backgroundColor: '#ffffff',
    borderBottomWidth: 1,
    borderBottomColor: '#e2e8f0',
  },
  backButton: {
    padding: 8,
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    color: '#000000',
    flex: 1,
    marginLeft: 12,
  },
  saveButton: {
    flexDirection: 'row',
    backgroundColor: '#10b981',
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
  },
  saveButtonDisabled: {
    opacity: 0.6,
  },
  saveButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  infoBar: {
    flexDirection: 'row',
    backgroundColor: '#dbeafe',
    padding: 12,
    alignItems: 'center',
  },
  infoText: {
    fontSize: 13,
    color: '#1e40af',
    marginLeft: 8,
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  textEditor: {
    flex: 1,
    backgroundColor: '#ffffff',
    padding: 20,
    fontSize: 14,
    fontFamily: 'monospace',
    color: '#000000',
    lineHeight: 22,
    minHeight: 2000,
  },
});
