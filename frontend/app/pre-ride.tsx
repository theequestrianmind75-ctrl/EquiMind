import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';

export default function PreRide() {
  const router = useRouter();
  const [rideType, setRideType] = useState('training');
  const [anxietyLevel, setAnxietyLevel] = useState(5);
  const [confidenceLevel, setConfidenceLevel] = useState(5);
  const [notes, setNotes] = useState('');
  // Horse information
  const [horseEnergyLevel, setHorseEnergyLevel] = useState(5);
  const [horseNotes, setHorseNotes] = useState('');
  const [riderEnergyLevel, setRiderEnergyLevel] = useState(5);
  const [loading, setLoading] = useState(false);

  const rideTypes = [
    { id: 'training', label: 'Training', icon: 'school' },
    { id: 'competition', label: 'Competition', icon: 'trophy' },
    { id: 'trail', label: 'Trail', icon: 'trail-sign' },
    { id: 'lesson', label: 'Lesson', icon: 'book' },
  ];

  const handleStartSession = async () => {
    setLoading(true);
    try {
      await api.post('/sessions', {
        session_type: 'pre-ride',
        ride_type: rideType,
        anxiety_level: anxietyLevel,
        confidence_level: confidenceLevel,
        notes: notes || null,
        horse_energy_level: horseEnergyLevel,
        horse_focus_level: horseFocusLevel,
        horse_responsiveness: horseResponsiveness,
        horse_notes: horseNotes || null,
      });
      Alert.alert('Success', 'Pre-ride session created for you and your horse!', [
        { text: 'OK', onPress: () => router.back() },
      ]);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to create session');
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
        </TouchableOpacity>
        <Text style={styles.title}>Pre-Ride Preparation</Text>
        <View style={styles.placeholder} />
      </View>

      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.keyboardView}
      >
        <ScrollView style={styles.scrollView}>
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Ride Type</Text>
            <View style={styles.rideTypeGrid}>
              {rideTypes.map((type) => (
                <TouchableOpacity
                  key={type.id}
                  style={[
                    styles.rideTypeButton,
                    rideType === type.id && styles.rideTypeButtonActive,
                  ]}
                  onPress={() => setRideType(type.id)}
                >
                  <Ionicons
                    name={type.icon as any}
                    size={28}
                    color={rideType === type.id ? "#ffffff" : "#000000"}
                  />
                  <Text
                    style={[
                      styles.rideTypeLabel,
                      rideType === type.id && styles.rideTypeLabelActive,
                    ]}
                  >
                    {type.label}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Anxiety Level: {anxietyLevel}/10</Text>
            <View style={styles.sliderContainer}>
              <View style={styles.scaleButtons}>
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                  <TouchableOpacity
                    key={level}
                    style={[
                      styles.scaleButton,
                      anxietyLevel === level && styles.scaleButtonActive,
                    ]}
                    onPress={() => setAnxietyLevel(level)}
                  >
                    <Text
                      style={[
                        styles.scaleButtonText,
                        anxietyLevel === level && styles.scaleButtonTextActive,
                      ]}
                    >
                      {level}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
              <View style={styles.scaleLabels}>
                <Text style={styles.scaleLabel}>Low</Text>
                <Text style={styles.scaleLabel}>High</Text>
              </View>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Confidence Level: {confidenceLevel}/10</Text>
            <View style={styles.sliderContainer}>
              <View style={styles.scaleButtons}>
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                  <TouchableOpacity
                    key={level}
                    style={[
                      styles.scaleButton,
                      confidenceLevel === level && styles.scaleButtonActive,
                    ]}
                    onPress={() => setConfidenceLevel(level)}
                  >
                    <Text
                      style={[
                        styles.scaleButtonText,
                        confidenceLevel === level && styles.scaleButtonTextActive,
                      ]}
                    >
                      {level}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
              <View style={styles.scaleLabels}>
                <Text style={styles.scaleLabel}>Low</Text>
                <Text style={styles.scaleLabel}>High</Text>
              </View>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Your Energy Level: {riderEnergyLevel}/10</Text>
            <View style={styles.sliderContainer}>
              <View style={styles.scaleButtons}>
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                  <TouchableOpacity
                    key={level}
                    style={[
                      styles.scaleButton,
                      riderEnergyLevel === level && styles.scaleButtonActive,
                    ]}
                    onPress={() => setRiderEnergyLevel(level)}
                  >
                    <Text
                      style={[
                        styles.scaleButtonText,
                        riderEnergyLevel === level && styles.scaleButtonTextActive,
                      ]}
                    >
                      {level}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
              <View style={styles.scaleLabels}>
                <Text style={styles.scaleLabel}>Low</Text>
                <Text style={styles.scaleLabel}>High</Text>
              </View>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Rider Notes (Optional)</Text>
            <TextInput
              style={styles.notesInput}
              placeholder="Set your intention, goals, or any thoughts..."
              placeholderTextColor="#000000"
              value={notes}
              onChangeText={setNotes}
              multiline
              numberOfLines={4}
            />
          </View>

          <View style={styles.divider} />
          <Text style={styles.sectionHeader}>YOUR HORSE</Text>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Horse Energy Level: {horseEnergyLevel}/10</Text>
            <View style={styles.sliderContainer}>
              <View style={styles.scaleButtons}>
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                  <TouchableOpacity
                    key={level}
                    style={[
                      styles.scaleButton,
                      horseEnergyLevel === level && styles.scaleButtonActive,
                    ]}
                    onPress={() => setHorseEnergyLevel(level)}
                  >
                    <Text
                      style={[
                        styles.scaleButtonText,
                        horseEnergyLevel === level && styles.scaleButtonTextActive,
                      ]}
                    >
                      {level}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
              <View style={styles.scaleLabels}>
                <Text style={styles.scaleLabel}>Low</Text>
                <Text style={styles.scaleLabel}>High</Text>
              </View>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Horse Focus Level: {horseFocusLevel}/10</Text>
            <View style={styles.sliderContainer}>
              <View style={styles.scaleButtons}>
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                  <TouchableOpacity
                    key={level}
                    style={[
                      styles.scaleButton,
                      horseFocusLevel === level && styles.scaleButtonActive,
                    ]}
                    onPress={() => setHorseFocusLevel(level)}
                  >
                    <Text
                      style={[
                        styles.scaleButtonText,
                        horseFocusLevel === level && styles.scaleButtonTextActive,
                      ]}
                    >
                      {level}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
              <View style={styles.scaleLabels}>
                <Text style={styles.scaleLabel}>Distracted</Text>
                <Text style={styles.scaleLabel}>Focused</Text>
              </View>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Horse Responsiveness: {horseResponsiveness}/10</Text>
            <View style={styles.sliderContainer}>
              <View style={styles.scaleButtons}>
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                  <TouchableOpacity
                    key={level}
                    style={[
                      styles.scaleButton,
                      horseResponsiveness === level && styles.scaleButtonActive,
                    ]}
                    onPress={() => setHorseResponsiveness(level)}
                  >
                    <Text
                      style={[
                        styles.scaleButtonText,
                        horseResponsiveness === level && styles.scaleButtonTextActive,
                      ]}
                    >
                      {level}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
              <View style={styles.scaleLabels}>
                <Text style={styles.scaleLabel}>Low</Text>
                <Text style={styles.scaleLabel}>Responsive</Text>
              </View>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Horse Notes (Optional)</Text>
            <TextInput
              style={styles.notesInput}
              placeholder="How is your horse feeling today? Any observations..."
              placeholderTextColor="#000000"
              value={horseNotes}
              onChangeText={setHorseNotes}
              multiline
              numberOfLines={4}
            />
          </View>

          <TouchableOpacity
            style={[styles.startButton, loading && styles.startButtonDisabled]}
            onPress={handleStartSession}
            disabled={loading}
          >
            <Ionicons name="checkmark-circle" size={24} color="#ffffff" />
            <Text style={styles.startButtonText}>
              {loading ? 'Creating Session...' : 'Start Pre-Ride Session'}
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#A7D2BB',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    paddingTop: 8,
  },
  backButton: {
    padding: 8,
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1e293b',
  },
  placeholder: {
    width: 40,
  },
  keyboardView: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
    padding: 24,
  },
  divider: {
    height: 1,
    backgroundColor: '#334155',
    marginVertical: 32,
  },
  sectionHeader: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 24,
    textAlign: 'center',
  },
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e293b',
    marginBottom: 16,
  },
  rideTypeGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginHorizontal: -6,
  },
  rideTypeButton: {
    width: '48%',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    margin: '1%',
    borderWidth: 2,
    borderColor: '#375B50',
  },
  rideTypeButtonActive: {
    borderColor: '#375B50',
    backgroundColor: '#375B50',
  },
  rideTypeLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000000',
    marginTop: 8,
  },
  rideTypeLabelActive: {
    color: '#ffffff',
  },
  sliderContainer: {
    marginTop: 8,
  },
  scaleButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  scaleButton: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#ffffff',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: '#375B50',
  },
  scaleButtonActive: {
    backgroundColor: '#375B50',
    borderColor: '#000000',
  },
  scaleButtonText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#000000',
  },
  scaleButtonTextActive: {
    color: '#ffffff',
  },
  scaleLabels: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  scaleLabel: {
    fontSize: 12,
    color: '#000000',
  },
  notesInput: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 16,
    color: '#1e293b',
    fontSize: 14,
    minHeight: 120,
    textAlignVertical: 'top',
    borderWidth: 1,
    borderColor: '#375B50',
  },
  startButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    borderRadius: 12,
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 16,
    marginBottom: 32,
  },
  startButtonDisabled: {
    opacity: 0.6,
  },
  startButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 8,
  },
});
