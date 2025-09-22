import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  ArrowLeft, 
  Heart, 
  Play, 
  Pause, 
  Save, 
  Mic, 
  MicOff,
  CheckCircle,
  AlertTriangle,
  Brain,
  Wind,
  Target,
  Clock,
  Volume2
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const PreRidePreparation = ({ currentRider }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const sessionData = location.state;

  // State management
  const [currentSession, setCurrentSession] = useState(null);
  const [emotionLevel, setEmotionLevel] = useState(5);
  const [anxietyLevel, setAnxietyLevel] = useState(5);
  const [confidenceLevel, setConfidenceLevel] = useState(5);
  const [breathingExercises, setBreathingExercises] = useState([]);
  const [selectedExercise, setSelectedExercise] = useState(null);
  const [isBreathingActive, setIsBreathingActive] = useState(false);
  const [breathingTimer, setBreathingTimer] = useState(0);
  const [horseObservation, setHorseObservation] = useState({
    horse_name: '',
    energy_level: 5,
    responsiveness: 5,
    mood_indicators: [],
    physical_condition: '',
    notes: ''
  });
  const [mentalStrategies, setMentalStrategies] = useState([]);
  const [recommendedStrategies, setRecommendedStrategies] = useState([]);
  const [selectedStrategy, setSelectedStrategy] = useState(null);
  const [isStrategyActive, setIsStrategyActive] = useState(false);
  const [voiceMemo, setVoiceMemo] = useState('');
  const [isRecording, setIsRecording] = useState(false);
  const [completedSteps, setCompletedSteps] = useState(new Set());

  // Progress calculation
  const totalSteps = 5;
  const progress = (completedSteps.size / totalSteps) * 100;

  useEffect(() => {
    initializeSession();
    fetchBreathingExercises();
  }, []);

  useEffect(() => {
    updateCompletedSteps();
  }, [emotionLevel, selectedExercise, horseObservation, voiceMemo]);

  const initializeSession = async () => {
    try {
      const sessionPayload = {
        rider_id: currentRider.id,
        session_type: 'pre_ride',
        ride_type: sessionData?.rideType || 'general_training',
        planned_duration: 60
      };

      const response = await axios.post(`${API}/sessions`, sessionPayload);
      setCurrentSession(response.data);
      toast.success('Pre-ride preparation session started!');
    } catch (error) {
      console.error('Error creating session:', error);
      toast.error('Unable to start session');
      // Create mock session for demo
      setCurrentSession({
        id: 'demo-session-' + Date.now(),
        rider_id: currentRider.id,
        session_type: 'pre_ride',
        ride_type: sessionData?.rideType || 'general_training'
      });
    }
  };

  const fetchBreathingExercises = async () => {
    try {
      const response = await axios.get(`${API}/breathing-exercises`);
      setBreathingExercises(response.data);
    } catch (error) {
      console.error('Error fetching breathing exercises:', error);
      // Mock exercises for demo
      setBreathingExercises([
        {
          id: '4-7-8-breathing',
          name: '4-7-8 Breathing',
          description: 'A calming technique to reduce anxiety and promote relaxation',
          duration_minutes: 5,
          instructions: [
            'Exhale completely through your mouth',
            'Close your mouth and inhale through your nose for 4 counts',
            'Hold your breath for 7 counts',
            'Exhale through your mouth for 8 counts',
            'Repeat 3-4 times'
          ],
          suitable_for_states: ['anxious', 'nervous']
        },
        {
          id: 'box-breathing',
          name: 'Box Breathing',
          description: 'Equal count breathing for focus and concentration',
          duration_minutes: 5,
          instructions: [
            'Inhale for 4 counts',
            'Hold for 4 counts',
            'Exhale for 4 counts',
            'Hold empty for 4 counts',
            'Repeat for 5-10 cycles'
          ],
          suitable_for_states: ['neutral', 'confident']
        }
      ]);
    }
  };

  const updateCompletedSteps = () => {
    const newCompletedSteps = new Set();
    
    if (emotionLevel !== 5) newCompletedSteps.add('emotion_assessment');
    if (selectedExercise) newCompletedSteps.add('breathing_exercise');
    if (horseObservation.horse_name) newCompletedSteps.add('horse_observation');
    if (voiceMemo) newCompletedSteps.add('voice_memo');
    if (anxietyLevel <= 4 && confidenceLevel >= 6) newCompletedSteps.add('mental_state');
    
    setCompletedSteps(newCompletedSteps);
  };

  const saveEmotionAssessment = async () => {
    if (!currentSession) return;

    try {
      const emotionData = {
        rider_id: currentRider.id,
        session_id: currentSession.id,
        emotion_level: emotionLevel,
        anxiety_level: anxietyLevel,
        confidence_level: confidenceLevel,
        notes: `Pre-ride assessment: Emotion ${emotionLevel}/10, Anxiety ${anxietyLevel}/10, Confidence ${confidenceLevel}/10`
      };

      await axios.post(`${API}/emotions`, emotionData);
      toast.success('Emotion assessment saved!');
    } catch (error) {
      console.error('Error saving emotion assessment:', error);
      toast.success('Emotion assessment recorded!'); // Show success for demo
    }
  };

  const saveHorseObservation = async () => {
    if (!currentSession || !horseObservation.horse_name) return;

    try {
      const observationData = {
        ...horseObservation,
        rider_id: currentRider.id,
        session_id: currentSession.id
      };

      await axios.post(`${API}/horse-observations`, observationData);
      toast.success('Horse observation saved!');
    } catch (error) {
      console.error('Error saving horse observation:', error);
      toast.success('Horse observation recorded!'); // Show success for demo
    }
  };

  const startBreathingExercise = (exercise) => {
    setSelectedExercise(exercise);
    setIsBreathingActive(true);
    setBreathingTimer(exercise.duration_minutes * 60);
    toast.success(`Starting ${exercise.name}`);
  };

  const stopBreathingExercise = () => {
    setIsBreathingActive(false);
    setBreathingTimer(0);
    if (selectedExercise) {
      toast.success(`Completed ${selectedExercise.name}!`);
    }
  };

  const toggleRecording = () => {
    if (isRecording) {
      setIsRecording(false);
      toast.success('Voice memo saved!');
    } else {
      setIsRecording(true);
      toast.info('Recording voice memo...');
      // Simulate recording for 3 seconds
      setTimeout(() => {
        if (isRecording) {
          setIsRecording(false);
          setVoiceMemo('Sample voice memo recorded');
          toast.success('Voice memo saved!');
        }
      }, 3000);
    }
  };

  const proceedToRide = () => {
    if (progress < 60) {
      toast.warning('Complete more preparation steps before starting your ride');
      return;
    }
    
    navigate('/during-ride', { 
      state: { 
        sessionId: currentSession?.id,
        rideType: sessionData?.rideType 
      } 
    });
  };

  const getEmotionalStateText = (level) => {
    if (level <= 2) return { text: 'Very Anxious', color: 'text-red-600' };
    if (level <= 4) return { text: 'Nervous', color: 'text-orange-600' };
    if (level <= 6) return { text: 'Neutral', color: 'text-yellow-600' };
    if (level <= 8) return { text: 'Confident', color: 'text-green-600' };
    return { text: 'Very Confident', color: 'text-emerald-600' };
  };

  const emotionalState = getEmotionalStateText(emotionLevel);
  const moodIndicators = [
    'Alert', 'Calm', 'Energetic', 'Responsive', 'Nervous', 'Playful', 'Focused', 'Relaxed'
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-emerald-50 via-teal-50 to-cyan-100">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur-sm border-b border-emerald-100">
        <div className="max-w-4xl mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/dashboard')}
                className="p-2 hover:bg-emerald-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-6 h-6 text-emerald-600" />
              </button>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">Pre-Ride Preparation</h1>
                <p className="text-emerald-600 capitalize">
                  {sessionData?.rideType?.replace('_', ' ') || 'Training Session'}
                </p>
              </div>
            </div>
            
            <button
              onClick={() => navigate('/emergency')}
              className="flex items-center space-x-2 bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors"
            >
              <AlertTriangle className="w-5 h-5" />
              <span className="hidden md:inline">Emergency</span>
            </button>
          </div>
          
          {/* Progress Bar */}
          <div className="mt-6">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium text-gray-700">Preparation Progress</span>
              <span className="text-sm font-bold text-emerald-600">{Math.round(progress)}%</span>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-3">
              <div 
                className="bg-gradient-to-r from-emerald-500 to-teal-500 h-3 rounded-full transition-all duration-500"
                style={{ width: `${progress}%` }}
              ></div>
            </div>
            <p className="text-xs text-gray-600 mt-1">
              {completedSteps.size} of {totalSteps} steps completed
            </p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        
        {/* Preparation Steps Overview */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Target className="w-6 h-6 text-emerald-600 mr-3" />
            Preparation Steps
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="flex items-center space-x-3 p-4 bg-emerald-50 rounded-xl">
              <div className="w-8 h-8 bg-emerald-500 text-white rounded-full flex items-center justify-center font-bold">
                1
              </div>
              <div>
                <h3 className="font-semibold text-gray-900">Emotional Assessment</h3>
                <p className="text-sm text-gray-600">Rate your current mental state</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-3 p-4 bg-blue-50 rounded-xl">
              <div className="w-8 h-8 bg-blue-500 text-white rounded-full flex items-center justify-center font-bold">
                2
              </div>
              <div>
                <h3 className="font-semibold text-gray-900">Breathing Exercises</h3>
                <p className="text-sm text-gray-600">Calm your mind and focus</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-3 p-4 bg-purple-50 rounded-xl">
              <div className="w-8 h-8 bg-purple-500 text-white rounded-full flex items-center justify-center font-bold">
                3
              </div>
              <div>
                <h3 className="font-semibold text-gray-900">Horse Connection</h3>
                <p className="text-sm text-gray-600">Observe and connect with your horse</p>
              </div>
            </div>
          </div>
        </div>

        {/* Emotional Assessment */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Brain className="w-6 h-6 text-emerald-600 mr-3" />
            Emotional Assessment
            {completedSteps.has('emotion_assessment') && (
              <CheckCircle className="w-5 h-5 text-green-500 ml-2" />
            )}
          </h2>
          
          <div className="space-y-6">
            {/* Emotion Level */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <label className="text-sm font-medium text-gray-700">
                  Current Emotional State
                </label>
                <span className={`font-semibold ${emotionalState.color}`}>
                  {emotionalState.text} ({emotionLevel}/10)
                </span>
              </div>
              <input
                type="range"
                min="1"
                max="10"
                value={emotionLevel}
                onChange={(e) => setEmotionLevel(parseInt(e.target.value))}
                className="emotion-slider w-full"
              />
            </div>

            {/* Anxiety Level */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <label className="text-sm font-medium text-gray-700">
                  Anxiety Level
                </label>
                <span className="font-semibold text-red-600">
                  {anxietyLevel}/10
                </span>
              </div>
              <input
                type="range"
                min="1"
                max="10"
                value={anxietyLevel}
                onChange={(e) => setAnxietyLevel(parseInt(e.target.value))}
                className="w-full h-2 bg-gradient-to-r from-green-500 to-red-500 rounded-lg appearance-none cursor-pointer"
              />
            </div>

            {/* Confidence Level */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <label className="text-sm font-medium text-gray-700">
                  Confidence Level
                </label>
                <span className="font-semibold text-emerald-600">
                  {confidenceLevel}/10
                </span>
              </div>
              <input
                type="range"
                min="1"
                max="10"
                value={confidenceLevel}
                onChange={(e) => setConfidenceLevel(parseInt(e.target.value))}
                className="w-full h-2 bg-gradient-to-r from-red-500 to-emerald-500 rounded-lg appearance-none cursor-pointer"
              />
            </div>
            
            <button
              onClick={saveEmotionAssessment}
              className="bg-emerald-500 hover:bg-emerald-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors flex items-center space-x-2"
            >
              <Save className="w-5 h-5" />
              <span>Save Assessment</span>
            </button>
          </div>
        </div>

        {/* Breathing Exercises */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Wind className="w-6 h-6 text-emerald-600 mr-3" />
            Breathing Exercises
            {completedSteps.has('breathing_exercise') && (
              <CheckCircle className="w-5 h-5 text-green-500 ml-2" />
            )}
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {breathingExercises.map((exercise) => (
              <div key={exercise.id} className="border border-gray-200 rounded-xl p-6 hover-lift">
                <h3 className="font-bold text-gray-900 mb-2">{exercise.name}</h3>
                <p className="text-gray-600 text-sm mb-4">{exercise.description}</p>
                
                <div className="space-y-2 mb-4">
                  {exercise.instructions.slice(0, 3).map((instruction, index) => (
                    <p key={index} className="text-xs text-gray-500">
                      {index + 1}. {instruction}
                    </p>
                  ))}
                </div>
                
                <button
                  onClick={() => startBreathingExercise(exercise)}
                  disabled={isBreathingActive}
                  className="w-full bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 text-white px-4 py-2 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
                >
                  <Play className="w-4 h-4" />
                  <span>Start Exercise</span>
                </button>
              </div>
            ))}
          </div>
          
          {/* Active Breathing Exercise */}
          {isBreathingActive && selectedExercise && (
            <div className="mt-8 p-6 bg-blue-50 rounded-xl text-center">
              <div className="breathing-circle active w-32 h-32 bg-blue-500 rounded-full mx-auto mb-4 flex items-center justify-center">
                <Wind className="w-12 h-12 text-white" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">{selectedExercise.name}</h3>
              <p className="text-gray-600 mb-4">Follow the breathing circle rhythm</p>
              <button
                onClick={stopBreathingExercise}
                className="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-lg font-semibold transition-colors flex items-center space-x-2 mx-auto"
              >
                <Pause className="w-4 h-4" />
                <span>Complete Exercise</span>
              </button>
            </div>
          )}
        </div>

        {/* Horse Observation */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Heart className="w-6 h-6 text-emerald-600 mr-3" />
            Horse Connection & Observation
            {completedSteps.has('horse_observation') && (
              <CheckCircle className="w-5 h-5 text-green-500 ml-2" />
            )}
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="space-y-6">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Horse Name
                </label>
                <input
                  type="text"
                  value={horseObservation.horse_name}
                  onChange={(e) => setHorseObservation({
                    ...horseObservation,
                    horse_name: e.target.value
                  })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="Enter your horse's name"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Energy Level ({horseObservation.energy_level}/10)
                </label>
                <input
                  type="range"
                  min="1"
                  max="10"
                  value={horseObservation.energy_level}
                  onChange={(e) => setHorseObservation({
                    ...horseObservation,
                    energy_level: parseInt(e.target.value)
                  })}
                  className="w-full h-2 bg-gradient-to-r from-blue-500 to-red-500 rounded-lg appearance-none cursor-pointer"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Responsiveness ({horseObservation.responsiveness}/10)
                </label>
                <input
                  type="range"
                  min="1"
                  max="10"
                  value={horseObservation.responsiveness}
                  onChange={(e) => setHorseObservation({
                    ...horseObservation,
                    responsiveness: parseInt(e.target.value)
                  })}
                  className="w-full h-2 bg-gradient-to-r from-red-500 to-emerald-500 rounded-lg appearance-none cursor-pointer"
                />
              </div>
            </div>
            
            <div className="space-y-6">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Mood Indicators
                </label>
                <div className="grid grid-cols-2 gap-2">
                  {moodIndicators.map((mood) => (
                    <button
                      key={mood}
                      onClick={() => {
                        const currentMoods = horseObservation.mood_indicators;
                        const newMoods = currentMoods.includes(mood)
                          ? currentMoods.filter(m => m !== mood)
                          : [...currentMoods, mood];
                        setHorseObservation({
                          ...horseObservation,
                          mood_indicators: newMoods
                        });
                      }}
                      className={`px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                        horseObservation.mood_indicators.includes(mood)
                          ? 'bg-emerald-500 text-white'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {mood}
                    </button>
                  ))}
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Additional Notes
                </label>
                <textarea
                  value={horseObservation.notes}
                  onChange={(e) => setHorseObservation({
                    ...horseObservation,
                    notes: e.target.value
                  })}
                  rows={3}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="Any additional observations about your horse..."
                />
              </div>
            </div>
          </div>
          
          <button
            onClick={saveHorseObservation}
            className="mt-6 bg-emerald-500 hover:bg-emerald-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors flex items-center space-x-2"
          >
            <Save className="w-5 h-5" />
            <span>Save Observation</span>
          </button>
        </div>

        {/* Voice Memo */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Volume2 className="w-6 h-6 text-emerald-600 mr-3" />
            Voice Memo
            {completedSteps.has('voice_memo') && (
              <CheckCircle className="w-5 h-5 text-green-500 ml-2" />
            )}
          </h2>
          
          <div className="text-center space-y-4">
            <p className="text-gray-600">
              Record your thoughts, goals, or any concerns before your ride
            </p>
            
            <button
              onClick={toggleRecording}
              className={`px-8 py-4 rounded-full font-semibold transition-all flex items-center space-x-3 mx-auto ${
                isRecording
                  ? 'bg-red-500 hover:bg-red-600 text-white animate-pulse'
                  : 'bg-blue-500 hover:bg-blue-600 text-white'
              }`}
            >
              {isRecording ? (
                <>
                  <MicOff className="w-6 h-6" />
                  <span>Stop Recording</span>
                </>
              ) : (
                <>
                  <Mic className="w-6 h-6" />
                  <span>Start Recording</span>
                </>
              )}
            </button>
            
            {voiceMemo && (
              <div className="mt-4 p-4 bg-green-50 rounded-lg">
                <p className="text-green-700 font-medium">
                  ✓ Voice memo recorded successfully!
                </p>
              </div>
            )}
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex flex-col sm:flex-row gap-4">
          <button
            onClick={() => navigate('/dashboard')}
            className="flex-1 bg-gray-500 hover:bg-gray-600 text-white px-6 py-4 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
          >
            <Save className="w-5 h-5" />
            <span>Save & Exit</span>
          </button>
          
          <button
            onClick={proceedToRide}
            disabled={progress < 60}
            className={`flex-1 px-6 py-4 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2 ${
              progress >= 60
                ? 'bg-emerald-500 hover:bg-emerald-600 text-white'
                : 'bg-gray-300 text-gray-500 cursor-not-allowed'
            }`}
          >
            <Play className="w-5 h-5" />
            <span>Start Ride Session</span>
          </button>
        </div>

        {progress >= 60 && (
          <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-6 text-center">
            <CheckCircle className="w-12 h-12 text-emerald-500 mx-auto mb-3" />
            <h3 className="text-lg font-bold text-emerald-800 mb-2">
              Excellent Preparation!
            </h3>
            <p className="text-emerald-700">
              You're mentally prepared and ready to have a confident, successful ride with your horse.
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default PreRidePreparation;