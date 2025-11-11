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

export default function HorseRiderConnection() {
  const router = useRouter();
  const [ridingLevel, setRidingLevel] = useState('');
  const [yearsRiding, setYearsRiding] = useState('');
  const [discipline, setDiscipline] = useState('');
  const [ridingGoals, setRidingGoals] = useState('');
  const [horseName, setHorseName] = useState('');
  const [horseAge, setHorseAge] = useState('');
  const [horseBreed, setHorseBreed] = useState('');
  const [timeWithHorse, setTimeWithHorse] = useState('');
  const [horsePersonality, setHorsePersonality] = useState('');
  const [connectionChallenges, setConnectionChallenges] = useState('');
  const [connectionStrengths, setConnectionStrengths] = useState('');

  const handleSave = () => {
    // Validate at least some fields are filled
    if (!ridingLevel && !horseName) {
      Alert.alert('Please fill in at least your riding level and horse name');
      return;
    }

    // Here you could save to backend if needed
    Alert.alert('Success', 'Your Horse-Rider Connection profile has been saved!', [
      { text: 'OK', onPress: () => router.back() },
    ]);
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1e293b" />
        </TouchableOpacity>
        <Text style={styles.title}>Horse-Rider Connection</Text>
        <View style={styles.placeholder} />
      </View>

      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.keyboardView}
      >
        <ScrollView style={styles.scrollView}>
          <View style={styles.introCard}>
            <Ionicons name="shield" size={32} color="#000000" />
            <Text style={styles.introTitle}>Build Your Partnership Profile</Text>
            <Text style={styles.introText}>
              Understanding your riding background and your horse's personality helps create a stronger bond and improves your communication.
            </Text>
          </View>

          <Text style={styles.sectionHeader}>About Your Riding</Text>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Your Riding Level *</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g., Beginner, Intermediate, Advanced"
              placeholderTextColor="#94a3b8"
              value={ridingLevel}
              onChangeText={setRidingLevel}
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Years of Riding Experience</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g., 5 years"
              placeholderTextColor="#94a3b8"
              value={yearsRiding}
              onChangeText={setYearsRiding}
              keyboardType="numeric"
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Primary Discipline</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g., Dressage, Jumping, Trail, Western"
              placeholderTextColor="#94a3b8"
              value={discipline}
              onChangeText={setDiscipline}
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Your Riding Goals</Text>
            <TextInput
              style={[styles.input, styles.textArea]}
              placeholder="What do you hope to achieve with your riding?"
              placeholderTextColor="#94a3b8"
              value={ridingGoals}
              onChangeText={setRidingGoals}
              multiline
              numberOfLines={4}
            />
          </View>

          <Text style={styles.sectionHeader}>About Your Horse</Text>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Horse's Name *</Text>
            <TextInput
              style={styles.input}
              placeholder="Your horse's name"
              placeholderTextColor="#94a3b8"
              value={horseName}
              onChangeText={setHorseName}
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Horse's Age</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g., 8 years old"
              placeholderTextColor="#94a3b8"
              value={horseAge}
              onChangeText={setHorseAge}
              keyboardType="numeric"
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Horse's Breed</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g., Thoroughbred, Quarter Horse, Warmblood"
              placeholderTextColor="#94a3b8"
              value={horseBreed}
              onChangeText={setHorseBreed}
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Time Together</Text>
            <TextInput
              style={styles.input}
              placeholder="How long have you been riding this horse?"
              placeholderTextColor="#94a3b8"
              value={timeWithHorse}
              onChangeText={setTimeWithHorse}
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Horse's Personality</Text>
            <TextInput
              style={[styles.input, styles.textArea]}
              placeholder="Describe your horse's temperament and personality traits"
              placeholderTextColor="#94a3b8"
              value={horsePersonality}
              onChangeText={setHorsePersonality}
              multiline
              numberOfLines={4}
            />
          </View>

          <Text style={styles.sectionHeader}>Your Partnership</Text>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Connection Challenges</Text>
            <TextInput
              style={[styles.input, styles.textArea]}
              placeholder="What challenges do you face in your partnership?"
              placeholderTextColor="#94a3b8"
              value={connectionChallenges}
              onChangeText={setConnectionChallenges}
              multiline
              numberOfLines={4}
            />
          </View>

          <View style={styles.questionCard}>
            <Text style={styles.questionLabel}>Connection Strengths</Text>
            <TextInput
              style={[styles.input, styles.textArea]}
              placeholder="What are the strengths of your partnership?"
              placeholderTextColor="#94a3b8"
              value={connectionStrengths}
              onChangeText={setConnectionStrengths}
              multiline
              numberOfLines={4}
            />
          </View>

          <TouchableOpacity style={styles.saveButton} onPress={handleSave}>
            <Ionicons name="checkmark-circle" size={24} color="#ffffff" />
            <Text style={styles.saveButtonText}>Save Profile</Text>
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
    color: '#000000',
    flex: 1,
    textAlign: 'center',
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
  introCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#375B50',
    alignItems: 'center',
  },
  introTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
    marginTop: 12,
    marginBottom: 8,
    textAlign: 'center',
  },
  introText: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
    textAlign: 'center',
  },
  sectionHeader: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 16,
    marginTop: 8,
  },
  questionCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  questionLabel: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 12,
  },
  input: {
    backgroundColor: '#f8fafc',
    borderWidth: 1,
    borderColor: '#cbd5e1',
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    color: '#000000',
  },
  textArea: {
    minHeight: 100,
    textAlignVertical: 'top',
  },
  saveButton: {
    flexDirection: 'row',
    backgroundColor: '#14b8a6',
    borderRadius: 12,
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 16,
    marginBottom: 32,
  },
  saveButtonText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#ffffff',
    marginLeft: 12,
  },
});
