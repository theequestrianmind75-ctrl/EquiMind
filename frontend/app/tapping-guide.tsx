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

const TAPPING_POINTS = [
  {
    id: 1,
    name: 'Side of the Hand (Karate Chop – KC)',
    location: 'The Karate Chop point is found along the fleshy, narrow side of the hand on the side of the pinky finger. It is found on both the left and right hands, between the base of the pinky finger and the wrist.',
    meridian: 'Small intestine',
    benefit: 'Releases feeling stuck and promotes ease in moving forward, letting go, healing from grief, and becoming happy in the present moment.',
    tips: 'You can tap on either hand, using the opposite hand to do the tapping. Try using several fingers from the opposite hand to tap on this point. Use all four fingers to tap along the length of the side of your hand to stimulate the Karate Chop point.',
  },
  {
    id: 2,
    name: 'Eyebrow (EB)',
    location: 'This point is where your hair begins on the inner part of your eyebrow, right on the bone there. It is found on both sides of the body, on both the left and the right brow bone.',
    meridian: 'Bladder',
    benefit: 'Releases trauma, hurt, and sadness and promotes peace and emotional healing.',
    tips: 'You can tap on both sides at once, pick just one side of the body, or alternate sides as you go along. Try using just a few fingers, like the index and middle fingers, to tap on this point.',
  },
  {
    id: 3,
    name: 'Side of the Eye (SE)',
    location: 'From the Eyebrow point, follow that ridge of bone from your eyebrow down to the side of the eye to find this point. Note that the Side of the Eye point is not located in the indent that is your temple; you'll want to stay on top of the bone instead.',
    meridian: 'Gallbladder',
    benefit: 'Releases resentment and anger and promotes clarity and compassion.',
    tips: 'You can tap on both sides at once, pick just one side of the body, or alternate sides as you go along. Try using just a few fingers, like the index and middle fingers, to tap on this point.',
  },
  {
    id: 4,
    name: 'Under the Eye (UE)',
    location: 'From the Side of the Eye Tapping point, follow that ridge of bone once again to come under your eye. This point is found directly under the eye, on either side of the body.',
    meridian: 'Stomach',
    benefit: 'Releases fear and anxiety and promotes feelings of contentment, calmness, and safety.',
    tips: 'You can tap on both sides at once, pick just one side of the body, or alternate sides as you go along. Try using just a few fingers, like the index and middle fingers, to tap on this point.',
  },
  {
    id: 5,
    name: 'Under the Nose (UN)',
    location: 'This point is found in the space between your nose and upper lip.',
    meridian: 'Governing Vessel',
    benefit: 'Releases shame and powerlessness and promotes self-acceptance, self-empowerment, and compassion for self and others.',
    tips: 'As it is a small area, try using just a few fingers (like the index and middle fingers) to reach this point for Tapping.',
  },
  {
    id: 6,
    name: 'Under the Mouth (UM)',
    location: 'Also called the chin point (CP), this point is found in the crease between your chin and bottom lip.',
    meridian: 'Central',
    benefit: 'Releases confusion and uncertainty and promotes clarity, certainty, confidence, and self-acceptance.',
    tips: 'As it is a small area, try using just a few fingers (like the index and middle fingers) to reach this point for Tapping.',
  },
  {
    id: 7,
    name: 'Collarbone (CB)',
    location: 'Starting from where your collarbones meet in the center (at the base of that U-shape), go down one inch and out one inch to either side to get to the Collarbone point. This Tapping point is found on both the left and right sides of the body.',
    meridian: 'Kidney',
    benefit: 'Releases the feeling of being stuck, promotes ease in moving forward, and boosts confidence and clarity.',
    tips: 'You can tap with a few fingers on either side of the body to stimulate this point. Alternatively, try taking your whole hand and tapping the entire hand across the place where a bowtie would lie. That allows you to easily stimulate this point on both sides at once without having to worry about the exact location of the point.',
  },
  {
    id: 8,
    name: 'Under the Arm (UA)',
    location: 'This point is located on your side, about four inches (or one hand's width) below the armpit. That is about where a bra strap lies. It is found on both the left and right sides of the body.',
    meridian: 'Spleen',
    benefit: 'Releases guilt, worry, and obsessing and promotes clarity, confidence, relaxation, and compassion for self and others.',
    tips: 'The easiest way to stimulate this point is to use all your fingers, or your whole hand, to tap on the side of the body under your arm.',
  },
  {
    id: 9,
    name: 'Top of the Head (TH)',
    location: 'This point is right on the center of the top of your head, at the crown.',
    meridian: 'Crown Chakra & Multiple Meridians',
    benefit: 'Opens the crown chakra and promotes spiritual connection, while anchoring in the new balance and alignment from the tapping round that has just been completed.',
    tips: 'Simply tap your hand or your fingertips at the very top of your head to stimulate this Tapping point.',
  },
];

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
            Tapping, also known as EFT (Emotional Freedom Techniques), is a powerful technique that combines the principles of modern psychology and ancient Chinese acupressure.
            {'\n\n'}
            During a Tapping session, you focus on whatever may be causing you stress or discomfort while at the same time gently tapping with your fingers on a specific set of points on the body.
            {'\n\n'}
            Tapping on these points sends calming signals to the brain, letting it know that it is safe to relax. It helps to turn down the brain's stress response so that you can let go of your stress and find more balance, calm, and ease as you move forward.
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

        {TAPPING_POINTS.map((point, index) => (
          <View key={point.id} style={styles.pointCard}>
            <View style={styles.pointHeader}>
              <View style={styles.pointNumber}>
                <Text style={styles.pointNumberText}>{index + 1}</Text>
              </View>
              <Text style={styles.pointName}>{point.name}</Text>
            </View>

            <View style={styles.pointSection}>
              <Text style={styles.pointLabel}>Location:</Text>
              <Text style={styles.pointText}>{point.location}</Text>
            </View>

            <View style={styles.pointSection}>
              <Text style={styles.pointLabel}>Meridian:</Text>
              <Text style={styles.pointText}>{point.meridian}</Text>
            </View>

            <View style={styles.pointSection}>
              <Text style={styles.pointLabel}>Benefits:</Text>
              <Text style={styles.pointText}>{point.benefit}</Text>
            </View>

            <View style={styles.pointSection}>
              <Text style={styles.pointLabel}>Tapping Tips:</Text>
              <Text style={styles.pointText}>{point.tips}</Text>
            </View>
          </View>
        ))}

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
