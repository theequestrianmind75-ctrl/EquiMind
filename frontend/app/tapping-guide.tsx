import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';

export default function TappingGuide() {
  const router = useRouter();

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000000" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>EFT Tapping Guide</Text>
      </View>

      <ScrollView style={styles.scrollView} contentContainerStyle={styles.contentContainer}>
        <View style={styles.introCard}>
          <Text style={styles.introTitle}>The 9-Point EFT Tapping Sequence</Text>
          <Text style={styles.introText}>
            Tap each point 5-7 times while focusing on your specific concern. Use 2-3 fingers with gentle but firm pressure.
          </Text>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>1</Text>
            </View>
            <Text style={styles.pointName}>Karate Chop Point (KC)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>The fleshy outer edge of the hand, below the pinkie finger.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases feeling stuck and promotes ease in moving forward and letting go.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>2</Text>
            </View>
            <Text style={styles.pointName}>Beginning of the Eyebrow (EB)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>The inner edge of the eyebrow, just above the bridge of the nose.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases trauma, hurt, and sadness and promotes peace and emotional healing.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>3</Text>
            </View>
            <Text style={styles.pointName}>Side of the Eye (SE)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>Follow the ridge of bone from your eyebrow down to the side of the eye.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases resentment and anger and promotes clarity and compassion.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>4</Text>
            </View>
            <Text style={styles.pointName}>Under the Eye (UE)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>Directly under the eye, on the ridge of bone.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases fear and anxiety and promotes contentment, calmness, and safety.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>5</Text>
            </View>
            <Text style={styles.pointName}>Under the Nose (UN)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>In the space between your nose and upper lip.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases shame and powerlessness and promotes self-acceptance and empowerment.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>6</Text>
            </View>
            <Text style={styles.pointName}>Chin Point (CP)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>In the crease between your lower lip and chin.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases confusion and uncertainty and promotes clarity and confidence in decisions.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>7</Text>
            </View>
            <Text style={styles.pointName}>Collarbone Point (CB)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>About 1 inch down and 1 inch out from the U-shaped notch at the base of your throat.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases feeling stuck and stress and promotes moving forward with ease and clarity.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>8</Text>
            </View>
            <Text style={styles.pointName}>Under the Arm (UA)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>On the side of your body, about 4 inches below the armpit (at bra line for women).</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases worry, insecurity, and guilt and promotes confidence and clarity.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>9</Text>
            </View>
            <Text style={styles.pointName}>Top of Head (TH)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>The crown of the head, directly at the center top.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases limited thinking and promotes connection to intuition, wisdom, and spiritual connection.</Text>
          </View>
        </View>

        <View style={styles.usageCard}>
          <Text style={styles.usageTitle}>When to Use EFT Tapping</Text>
          <Text style={styles.usageText}>
            <Text style={styles.bold}>Before Riding:</Text> Calm pre-ride nerves and set positive intentions.
            {'\n\n'}
            <Text style={styles.bold}>During Riding:</Text> If you feel stressed or overwhelmed, pause. Tapping would be recommended before continuing.
            {'\n\n'}
            <Text style={styles.bold}>After Riding:</Text> Process emotions and release tension from your session.
            {'\n\n'}
            Tap each point 5-7 times while focusing on your stress or concern. Move through all 9 points in sequence.
          </Text>
        </View>
      </ScrollView>
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
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: '#ffffff',
    borderBottomWidth: 1,
    borderBottomColor: '#e5e7eb',
  },
  backButton: {
    padding: 8,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
    marginLeft: 16,
  },
  scrollView: {
    flex: 1,
  },
  contentContainer: {
    padding: 16,
  },
  introCard: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 20,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  introTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 12,
  },
  introText: {
    fontSize: 15,
    color: '#1e293b',
    lineHeight: 22,
  },
  pointCard: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  pointHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
    paddingBottom: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#e5e7eb',
  },
  pointNumber: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: '#375B50',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  pointNumberText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#ffffff',
  },
  pointName: {
    fontSize: 17,
    fontWeight: '600',
    color: '#000000',
    flex: 1,
  },
  pointSection: {
    marginBottom: 12,
  },
  pointLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#375B50',
    marginBottom: 4,
  },
  pointText: {
    fontSize: 14,
    color: '#1e293b',
    lineHeight: 20,
  },
  usageCard: {
    backgroundColor: '#fffbeb',
    borderRadius: 12,
    padding: 20,
    marginBottom: 16,
    borderWidth: 2,
    borderColor: '#f59e0b',
  },
  usageTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 12,
  },
  usageText: {
    fontSize: 15,
    color: '#1e293b',
    lineHeight: 24,
  },
  bold: {
    fontWeight: '600',
    color: '#1e293b',
  },
});
