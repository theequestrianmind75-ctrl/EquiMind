import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  ArrowLeft, 
  AlertTriangle, 
  Phone, 
  Wind, 
  Brain, 
  Heart,
  Eye,
  Ear,
  Hand,
  Play,
  Pause,
  CheckCircle,
  Clock,
  Shield,
  MessageSquare
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const EmergencySupport = ({ currentRider }) => {
  const navigate = useNavigate();
  const [activeExercise, setActiveExercise] = useState(null);
  const [breathingTimer, setBreathingTimer] = useState(0);
  const [isBreathingActive, setIsBreathingActive] = useState(false);
  const [groundingStep, setGroundingStep] = useState(0);
  const [emergencyTechniques, setEmergencyTechniques] = useState(null);
  const [sessionStartTime, setSessionStartTime] = useState(null);

  useEffect(() => {
    setSessionStartTime(new Date());
    fetchEmergencyTechniques();
  }, []);

  useEffect(() => {
    let interval;
    if (isBreathingActive && breathingTimer > 0) {
      interval = setInterval(() => {
        setBreathingTimer(prev => {
          if (prev <= 1) {
            setIsBreathingActive(false);
            toast.success('Breathing exercise completed!');
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isBreathingActive, breathingTimer]);

  const fetchEmergencyTechniques = async () => {
    try {
      const response = await axios.get(`${API}/emergency-techniques`);
      setEmergencyTechniques(response.data);
    } catch (error) {
      console.error('Error fetching emergency techniques:', error);
      // Mock data for demo
      setEmergencyTechniques({
        breathing_exercises: [
          {
            name: 'Emergency 4-7-8',
            description: 'Quick anxiety relief',
            steps: ['Inhale 4', 'Hold 7', 'Exhale 8', 'Repeat 4 times']
          }
        ],
        grounding_techniques: [
          {
            name: '5-4-3-2-1 Technique',
            description: 'Sensory grounding exercise',
            steps: [
              '5 things you can see',
              '4 things you can touch',
              '3 things you can hear',
              '2 things you can smell',
              '1 thing you can taste'
            ]
          }
        ],
        immediate_actions: [
          {
            name: 'Safe Dismount',
            description: 'If currently riding',
            steps: ['Stop your horse', 'Dismount safely', 'Move to safe area', 'Begin breathing exercise']
          }
        ]
      });
    }
  };

  const startEmergencyBreathing = () => {
    setActiveExercise('breathing');
    setIsBreathingActive(true);
    setBreathingTimer(120); // 2 minutes
    toast.info('Starting emergency breathing exercise...');
  };

  const stopBreathing = () => {
    setIsBreathingActive(false);
    setBreathingTimer(0);
    setActiveExercise(null);
  };

  const startGroundingExercise = () => {
    setActiveExercise('grounding');
    setGroundingStep(0);
    toast.info('Starting 5-4-3-2-1 grounding technique...');
  };

  const nextGroundingStep = () => {
    if (groundingStep < 4) {
      setGroundingStep(prev => prev + 1);
    } else {
      setActiveExercise(null);
      setGroundingStep(0);
      toast.success('Grounding exercise completed!');
    }
  };

  const logEmergencyEvent = async (interventionUsed) => {
    try {
      const eventData = {
        rider_id: currentRider.id,
        session_id: 'emergency-session-' + Date.now(),
        trigger_reason: 'User initiated emergency support',
        intervention_used: interventionUsed,
        resolution_time_minutes: sessionStartTime ? 
          Math.round((new Date() - sessionStartTime) / 60000) : 0
      };

      await axios.post(`${API}/emergency-events`, eventData);
    } catch (error) {
      console.error('Error logging emergency event:', error);
    }
  };

  const call911 = () => {
    logEmergencyEvent('911 call initiated');
    toast.success('Calling 911...');
    // Initiate actual 911 call
    window.location.href = 'tel:911';
  };

  const textSupport = () => {
    logEmergencyEvent('Support text initiated');
    toast.success('Opening text message...');
    // Initiate text message to support number
    window.location.href = 'sms:4358170812';
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const groundingSteps = [
    { icon: Eye, text: 'Name 5 things you can see around you', color: 'text-blue-600' },
    { icon: Hand, text: 'Name 4 things you can touch', color: 'text-green-600' },
    { icon: Ear, text: 'Name 3 things you can hear', color: 'text-purple-600' },
    { icon: Wind, text: 'Name 2 things you can smell', color: 'text-orange-600' },
    { icon: Heart, text: 'Name 1 thing you can taste', color: 'text-red-600' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-red-50 via-orange-50 to-yellow-50">
      {/* Emergency Header */}
      <div className="bg-red-500 text-white">
        <div className="max-w-4xl mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/dashboard')}
                className="p-2 hover:bg-red-600 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-6 h-6" />
              </button>
              <div className="flex items-center space-x-3">
                <div className="p-2 bg-red-600 rounded-lg">
                  <Shield className="w-6 h-6" />
                </div>
                <div>
                  <h1 className="text-2xl font-bold">Emergency Support</h1>
                  <p className="text-red-100">Immediate anxiety & fear management</p>
                </div>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <button
                onClick={call911}
                className="flex items-center space-x-2 bg-red-700 text-white px-6 py-3 rounded-lg font-bold hover:bg-red-800 transition-colors"
              >
                <Phone className="w-5 h-5" />
                <span>CALL 911</span>
              </button>
              
              <button
                onClick={textSupport}
                className="flex items-center space-x-2 bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
              >
                <Phone className="w-5 h-5" />
                <span>Text Support</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        
        {/* Emergency Alert */}
        <div className="bg-white border-l-4 border-red-500 rounded-lg p-6 shadow-lg">
          <div className="flex items-start space-x-4">
            <AlertTriangle className="w-8 h-8 text-red-500 flex-shrink-0 mt-1" />
            <div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">
                You're Safe - We're Here to Help
              </h2>
              <p className="text-gray-700 mb-4">
                If you're experiencing anxiety, panic, or fear while riding or preparing to ride, 
                these techniques can help you regain control and feel safe.
              </p>
              <div className="flex items-center space-x-4 text-sm text-gray-600">
                <span className="flex items-center">
                  <Clock className="w-4 h-4 mr-1" />
                  Session started: {sessionStartTime?.toLocaleTimeString() || 'Now'}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Immediate Safety Actions */}
        <div className="bg-white rounded-2xl p-8 shadow-lg">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">
            Immediate Safety Actions
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="p-6 bg-red-50 rounded-xl border border-red-200">
              <h3 className="font-bold text-red-800 mb-3">If Currently Riding</h3>
              <ol className="space-y-2 text-sm text-red-700">
                <li>1. Stop your horse calmly</li>
                <li>2. Dismount safely</li>
                <li>3. Move to a safe area</li>
                <li>4. Begin breathing exercise</li>
              </ol>
            </div>
            
            <div className="p-6 bg-orange-50 rounded-xl border border-orange-200">
              <h3 className="font-bold text-orange-800 mb-3">If Preparing to Ride</h3>
              <ol className="space-y-2 text-sm text-orange-700">
                <li>1. Step away from your horse</li>
                <li>2. Find a quiet space</li>
                <li>3. Start grounding technique</li>
                <li>4. Call for help if needed</li>
              </ol>
            </div>
            
            <div className="p-6 bg-yellow-50 rounded-xl border border-yellow-200">
              <h3 className="font-bold text-yellow-800 mb-3">General Panic</h3>
              <ol className="space-y-2 text-sm text-yellow-700">
                <li>1. Remind yourself you're safe</li>
                <li>2. Focus on your breathing</li>
                <li>3. Use grounding techniques</li>
                <li>4. Contact support team</li>
              </ol>
            </div>
          </div>
        </div>

        {/* Quick Relief Techniques */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Emergency Breathing */}
          <div className="bg-white rounded-2xl p-8 shadow-lg">
            <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Wind className="w-6 h-6 text-blue-600 mr-3" />
              Emergency Breathing
            </h2>
            
            {!activeExercise || activeExercise !== 'breathing' ? (
              <div className="space-y-4">
                <p className="text-gray-600">
                  Quick 4-7-8 breathing technique to immediately calm anxiety and panic.
                </p>
                <button
                  onClick={startEmergencyBreathing}
                  className="w-full bg-blue-500 hover:bg-blue-600 text-white py-4 px-6 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
                >
                  <Play className="w-5 h-5" />
                  <span>Start Emergency Breathing</span>
                </button>
              </div>
            ) : (
              <div className="text-center space-y-6">
                <div className="breathing-circle active w-32 h-32 bg-blue-500 rounded-full mx-auto flex items-center justify-center">
                  <Wind className="w-12 h-12 text-white" />
                </div>
                
                <div>
                  <h3 className="text-lg font-bold text-gray-900 mb-2">
                    Follow the Circle
                  </h3>
                  <p className="text-gray-600 mb-4">
                    Inhale 4 • Hold 7 • Exhale 8 • Repeat
                  </p>
                  <p className="text-2xl font-bold text-blue-600">
                    {formatTime(breathingTimer)}
                  </p>
                </div>
                
                <button
                  onClick={stopBreathing}
                  className="bg-red-500 hover:bg-red-600 text-white py-3 px-6 rounded-lg font-semibold transition-colors flex items-center space-x-2 mx-auto"
                >
                  <Pause className="w-4 h-4" />
                  <span>Stop</span>
                </button>
              </div>
            )}
          </div>

          {/* 5-4-3-2-1 Grounding */}
          <div className="bg-white rounded-2xl p-8 shadow-lg">
            <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Brain className="w-6 h-6 text-purple-600 mr-3" />
              5-4-3-2-1 Grounding
            </h2>
            
            {!activeExercise || activeExercise !== 'grounding' ? (
              <div className="space-y-4">
                <p className="text-gray-600">
                  Sensory grounding technique to reconnect with the present moment.
                </p>
                <button
                  onClick={startGroundingExercise}
                  className="w-full bg-purple-500 hover:bg-purple-600 text-white py-4 px-6 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
                >
                  <Play className="w-5 h-5" />
                  <span>Start Grounding Exercise</span>
                </button>
              </div>
            ) : (
              <div className="space-y-6">
                <div className="text-center">
                  <div className={`w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center ${
                    groundingStep === 0 ? 'bg-blue-100' : 
                    groundingStep === 1 ? 'bg-green-100' :
                    groundingStep === 2 ? 'bg-purple-100' :
                    groundingStep === 3 ? 'bg-orange-100' : 'bg-red-100'
                  }`}>
                    {React.createElement(groundingSteps[groundingStep].icon, {
                      className: `w-8 h-8 ${groundingSteps[groundingStep].color}`
                    })}
                  </div>
                  <h3 className="text-lg font-bold text-gray-900 mb-2">
                    Step {groundingStep + 1} of 5
                  </h3>
                  <p className="text-gray-700 text-lg mb-6">
                    {groundingSteps[groundingStep].text}
                  </p>
                </div>
                
                <button
                  onClick={nextGroundingStep}
                  className="w-full bg-emerald-500 hover:bg-emerald-600 text-white py-4 px-6 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
                >
                  {groundingStep < 4 ? (
                    <>
                      <CheckCircle className="w-5 h-5" />
                      <span>Next Step</span>
                    </>
                  ) : (
                    <>
                      <CheckCircle className="w-5 h-5" />
                      <span>Complete Exercise</span>
                    </>
                  )}
                </button>
              </div>
            )}
          </div>
        </div>

        {/* Recovery Actions */}
        <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-8">
          <h2 className="text-xl font-bold text-emerald-800 mb-4">
            When You Feel Better
          </h2>
          
          <div className="space-y-4">
            <p className="text-emerald-700">
              Once you feel calmer and more in control, consider these next steps:
            </p>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <button
                onClick={() => {
                  logEmergencyEvent('Returned to dashboard');
                  navigate('/dashboard');
                }}
                className="bg-emerald-500 hover:bg-emerald-600 text-white py-3 px-6 rounded-lg font-semibold transition-colors"
              >
                Return to Dashboard
              </button>
              
              <button
                onClick={() => {
                  logEmergencyEvent('Started pre-ride preparation');
                  navigate('/pre-ride');
                }}
                className="bg-blue-500 hover:bg-blue-600 text-white py-3 px-6 rounded-lg font-semibold transition-colors"
              >
                Start Gentle Preparation
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EmergencySupport;