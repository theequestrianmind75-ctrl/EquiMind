import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';

export default function TappingGuide() {
  const router = useRouter();

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
        </TouchableOpacity>
        <Text style={styles.title}>Tapping (EFT) Guide</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.scrollView}>
        <View style={styles.introCard}>
          <Text style={styles.introTitle}>What is EFT Tapping?</Text>
          <Text style={styles.introText}>
            Tapping, also known as EFT (Emotional Freedom Techniques), is a powerful technique that combines modern psychology and ancient Chinese acupressure.
            {'\n\n'}
            During a Tapping session, you focus on whatever may be causing you stress while gently tapping with your fingers on specific points on the body.
            {'\n\n'}
            Tapping on these points sends calming signals to the brain, letting it know that it is safe to relax.
          </Text>
        </View>

        <View style={styles.diagramCard}>
          <Text style={styles.sectionTitle}>EFT Tapping Points Chart</Text>
          <Image
            source={{ uri: 'https://www.thrivingnow.com/wp-content/uploads/2023/02/EFT-Tapping-Points-GenderNeutral.png' }}
            style={styles.diagram}
            resizeMode="contain"
          />
          <Text style={styles.imageCaption}>
            The 9 main EFT tapping points used for stress relief
          </Text>
        </View>

        <Text style={styles.sectionHeader}>The 9 Tapping Points</Text>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>1</Text>
            </View>
            <Text style={styles.pointName}>Side of the Hand (Karate Chop)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>Along the fleshy side of the hand between the base of the pinky finger and the wrist.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Small intestine</Text>
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
            <Text style={styles.pointName}>Eyebrow (EB)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>Where your hair begins on the inner part of your eyebrow, right on the bone.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Bladder</Text>
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
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Gallbladder</Text>
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
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Stomach</Text>
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
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Governing Vessel</Text>
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
            <Text style={styles.pointName}>Under the Mouth (UM)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>In the crease between your chin and bottom lip.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Central</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases confusion and uncertainty and promotes clarity, certainty, and confidence.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>7</Text>
            </View>
            <Text style={styles.pointName}>Collarbone (CB)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>One inch down and one inch out from where your collarbones meet in the center.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Kidney</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases feeling stuck and promotes ease in moving forward and boosts confidence.</Text>
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
            <Text style={styles.pointText}>About four inches below the armpit on your side.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Spleen</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Releases guilt, worry, and obsessing and promotes clarity, confidence, and relaxation.</Text>
          </View>
        </View>

        <View style={styles.pointCard}>
          <View style={styles.pointHeader}>
            <View style={styles.pointNumber}>
              <Text style={styles.pointNumberText}>9</Text>
            </View>
            <Text style={styles.pointName}>Top of the Head (TH)</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Location:</Text>
            <Text style={styles.pointText}>Right on the center of the top of your head, at the crown.</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Meridian:</Text>
            <Text style={styles.pointText}>Crown Chakra and Multiple Meridians</Text>
          </View>
          <View style={styles.pointSection}>
            <Text style={styles.pointLabel}>Benefits:</Text>
            <Text style={styles.pointText}>Opens the crown chakra and promotes spiritual connection while anchoring balance.</Text>
          </View>
        </View>

        <View style={styles.usageCard}>
          <Ionicons name="information-circle" size={32} color="#ec4899" />
          <Text style={styles.usageTitle}>How to Use EFT Tapping</Text>
          <Text style={styles.usageText}>
            <Text style={styles.bold}>Before Riding:</Text> Use tapping to calm pre-ride anxiety and set a positive intention.
            {'\n\n'}
            <Text style={styles.bold}>During Challenges:</Text> If you feel stressed or overwhelmed, pause and tap through the sequence.
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
    backgroundColor: '#0f172a',
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
    color: '#f1f5f9',
  },
  placeholder: {
    width: 40,
  },
  scrollView: {
    flex: 1,
    padding: 24,
  },
  introCard: {
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#334155',
  },
  introTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#ec4899',
    marginBottom: 12,
  },
  introText: {
    fontSize: 14,
    color: '#94a3b8',
    lineHeight: 22,
  },
  diagramCard: {
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#334155',
    alignItems: 'center',
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginBottom: 16,
  },
  diagram: {
    width: '100%',
    height: 400,
    marginBottom: 12,
  },
  imageCaption: {
    fontSize: 12,
    color: '#64748b',
    fontStyle: 'italic',
    textAlign: 'center',
  },
  sectionHeader: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#ec4899',
    marginBottom: 16,
    marginTop: 8,
  },
  pointCard: {
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#334155',
  },
  pointHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  pointNumber: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: '#ec4899',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  pointNumberText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#ffffff',
  },
  pointName: {
    flex: 1,
    fontSize: 16,
    fontWeight: '600',
    color: '#f1f5f9',
  },
  pointSection: {
    marginBottom: 12,
  },
  pointLabel: {
    fontSize: 13,
    fontWeight: '600',
    color: '#ec4899',
    marginBottom: 4,
  },
  pointText: {
    fontSize: 14,
    color: '#94a3b8',
    lineHeight: 20,
  },
  usageCard: {
    backgroundColor: '#1e293b',
    padding: 24,
    borderRadius: 12,
    marginBottom: 32,
    borderWidth: 1,
    borderColor: '#334155',
    alignItems: 'center',
  },
  usageTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginTop: 12,
    marginBottom: 16,
  },
  usageText: {
    fontSize: 14,
    color: '#94a3b8',
    lineHeight: 22,
    textAlign: 'left',
    width: '100%',
  },
  bold: {
    fontWeight: '600',
    color: '#f1f5f9',
  },
});
