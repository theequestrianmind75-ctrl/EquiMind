import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Linking } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';

export default function DownloadTools() {
  const handleDownload = (format: string) => {
    const url = format === 'json' 
      ? 'https://subscriptionapp.preview.emergentagent.com/tools_backup_working.json'
      : 'https://subscriptionapp.preview.emergentagent.com/tools_export.csv';
    
    Linking.openURL(url);
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Ionicons name="download" size={64} color="#375B50" />
        
        <Text style={styles.title}>Download Your Tools</Text>
        <Text style={styles.subtitle}>107 complete tools with full instructions</Text>
        
        <View style={styles.infoBox}>
          <Text style={styles.infoText}>
            ✅ All tools have been restored{'\n'}
            ✅ Complete instructions included{'\n'}
            ✅ 4 categories: Tapping, Somatic Reset, Mindfulness, Breathing
          </Text>
        </View>

        <TouchableOpacity 
          style={styles.downloadButton} 
          onPress={() => handleDownload('json')}
        >
          <Ionicons name="code-download" size={24} color="#ffffff" />
          <Text style={styles.downloadButtonText}>Download JSON (For Production)</Text>
        </TouchableOpacity>

        <TouchableOpacity 
          style={[styles.downloadButton, styles.csvButton]} 
          onPress={() => handleDownload('csv')}
        >
          <Ionicons name="document-text" size={24} color="#ffffff" />
          <Text style={styles.downloadButtonText}>Download CSV (For Editing)</Text>
        </TouchableOpacity>

        <View style={styles.instructionsBox}>
          <Text style={styles.instructionsTitle}>📋 To Restore in Production:</Text>
          <Text style={styles.instructionsText}>
            1. Download the JSON file above{'\n'}
            2. Copy it to your production backend folder{'\n'}
            3. Run the restore script: python3 restore_from_backup.py{'\n'}
            4. Restart your production services
          </Text>
        </View>

        <View style={styles.directLinks}>
          <Text style={styles.directLinksTitle}>Direct Links:</Text>
          <Text style={styles.linkText} selectable>
            JSON: https://subscriptionapp.preview.emergentagent.com/tools_backup_working.json
          </Text>
          <Text style={styles.linkText} selectable>
            CSV: https://subscriptionapp.preview.emergentagent.com/tools_export.csv
          </Text>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8fafc',
  },
  content: {
    flex: 1,
    padding: 24,
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#000000',
    marginTop: 16,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#64748b',
    marginBottom: 24,
  },
  infoBox: {
    backgroundColor: '#dcfce7',
    padding: 16,
    borderRadius: 8,
    marginBottom: 24,
    width: '100%',
  },
  infoText: {
    fontSize: 14,
    color: '#166534',
    lineHeight: 22,
  },
  downloadButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 8,
    alignItems: 'center',
    marginBottom: 12,
    width: '100%',
  },
  csvButton: {
    backgroundColor: '#10b981',
  },
  downloadButtonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 12,
  },
  instructionsBox: {
    backgroundColor: '#dbeafe',
    padding: 16,
    borderRadius: 8,
    marginTop: 24,
    width: '100%',
  },
  instructionsTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e40af',
    marginBottom: 8,
  },
  instructionsText: {
    fontSize: 14,
    color: '#1e40af',
    lineHeight: 22,
  },
  directLinks: {
    marginTop: 24,
    padding: 16,
    backgroundColor: '#f1f5f9',
    borderRadius: 8,
    width: '100%',
  },
  directLinksTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#475569',
    marginBottom: 8,
  },
  linkText: {
    fontSize: 11,
    color: '#3b82f6',
    marginBottom: 8,
    fontFamily: 'monospace',
  },
});
