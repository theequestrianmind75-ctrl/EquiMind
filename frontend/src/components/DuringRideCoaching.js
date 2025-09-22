import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { toast } from 'sonner';
import { 
  ArrowLeft, 
  Mic, 
  MicOff, 
  Pause,
  Play,
  Square,
  Brain,
  Heart,
  Wind,
  AlertTriangle,
  CheckCircle,
  Activity
} from 'lucide-react';

const DuringRideCoaching = ({ currentRider }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const sessionData = location.state;
  
  const [isActive, setIsActive] = useState(false);
  const [duration, setDuration] = useState(0);
  const [isListening, setIsListening] = useState(false);
  const [currentPhase, setCurrentPhase] = useState('warm-up');
  const [aiCoaching, setAiCoaching] = useState([]);
  const [heartRate, setHeartRate] = useState(72);
  const [stressLevel, setStressLevel] = useState(3);

  useEffect(() => {
    let interval;
    if (isActive) {
      interval = setInterval(() => {
        setDuration(prev => prev + 1);
        // Simulate heart rate changes
        setHeartRate(prev => prev + Math.floor(Math.random() * 6) - 3);
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isActive]);

  useEffect(() => {
    // Simulate AI coaching messages
    if (isActive) {
      const coachingInterval = setInterval(() => {
        const messages = [
          "Great posture! Keep your shoulders relaxed.",
          "Focus on your breathing - deep and steady.",
          "Your horse is responding well to your calm energy.",
          "Remember to look ahead, not down at your horse.",
          "Excellent rhythm in your posting trot!"
        ];
        
        const randomMessage = messages[Math.floor(Math.random() * messages.length)];
        setAiCoaching(prev => [...prev.slice(-4), {
          id: Date.now(),
          message: randomMessage,
          timestamp: new Date(),
          type: 'coaching'
        }]);
      }, 15000);
      
      return () => clearInterval(coachingInterval);
    }
  }, [isActive]);

  const startRideSession = () => {
    setIsActive(true);
    setDuration(0);
    toast.success('Ride session started - AI coaching activated!');
    
    // Initial coaching message
    setAiCoaching([{
      id: Date.now(),
      message: "Welcome to your ride! I'll be here to provide real-time guidance. Stay relaxed and enjoy your time with your horse.",
      timestamp: new Date(),
      type: 'welcome'
    }]);
  };

  const pauseSession = () => {
    setIsActive(false);
    toast.info('Session paused');
  };

  const endSession = () => {
    setIsActive(false);
    toast.success('Ride session completed!');
    navigate('/post-ride', { 
      state: { 
        sessionId: sessionData?.sessionId,
        duration: duration,
        aiCoaching: aiCoaching,
        finalHeartRate: heartRate,
        finalStressLevel: stressLevel
      }
    });
  };

  const toggleListening = () => {
    setIsListening(!isListening);
    toast.info(isListening ? 'Microphone disabled' : 'Microphone enabled');
  };

  const handleEmergencyStop = () => {
    setIsActive(false);
    navigate('/emergency');
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const getStressColor = (level) => {
    if (level <= 2) return 'text-green-500';
    if (level <= 4) return 'text-yellow-500';
    return 'text-red-500';
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-100">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur-sm border-b border-blue-100">
        <div className="max-w-4xl mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/pre-ride')}
                className="p-2 hover:bg-blue-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-6 h-6 text-blue-600" />
              </button>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">During Ride Coaching</h1>
                <p className="text-blue-600 capitalize">
                  {sessionData?.rideType?.replace('_', ' ') || 'Training Session'}
                </p>
              </div>
            </div>
            
            <button
              onClick={handleEmergencyStop}
              className="flex items-center space-x-2 bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors"
            >
              <AlertTriangle className="w-5 h-5" />
              <span className="hidden md:inline">Emergency</span>
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        
        {/* Session Controls */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8 text-center">
          <div className="space-y-6">
            {/* Timer Display */}
            <div className="text-center">
              <div className="text-6xl font-bold text-gray-900 mb-2">
                {formatTime(duration)}
              </div>
              <p className="text-gray-600 text-lg">Session Duration</p>
            </div>
            
            {/* Control Buttons */}
            <div className="flex items-center justify-center space-x-4">
              {!isActive ? (
                <button
                  onClick={startRideSession}
                  className="bg-emerald-500 hover:bg-emerald-600 text-white px-8 py-4 rounded-full font-semibold transition-colors flex items-center space-x-3 text-lg"
                >
                  <Play className="w-6 h-6" />
                  <span>Start Ride Session</span>
                </button>
              ) : (
                <>
                  <button
                    onClick={pauseSession}
                    className="bg-yellow-500 hover:bg-yellow-600 text-white px-6 py-3 rounded-full font-semibold transition-colors flex items-center space-x-2"
                  >
                    <Pause className="w-5 h-5" />
                    <span>Pause</span>
                  </button>
                  
                  <button
                    onClick={endSession}
                    className="bg-red-500 hover:bg-red-600 text-white px-6 py-3 rounded-full font-semibold transition-colors flex items-center space-x-2"
                  >
                    <Square className="w-5 h-5" />
                    <span>End Session</span>
                  </button>
                </>
              )}
            </div>
            
            {/* Microphone Toggle */}
            <button
              onClick={toggleListening}
              className={`px-6 py-3 rounded-full font-semibold transition-colors flex items-center space-x-2 mx-auto ${
                isListening 
                  ? 'bg-green-500 hover:bg-green-600 text-white' 
                  : 'bg-gray-300 hover:bg-gray-400 text-gray-700'
              }`}
            >
              {isListening ? <Mic className="w-5 h-5" /> : <MicOff className="w-5 h-5" />}
              <span>{isListening ? 'Microphone On' : 'Microphone Off'}</span>
            </button>
          </div>
        </div>

        {/* Real-time Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
            <div className="flex items-center space-x-3 mb-4">
              <Heart className="w-6 h-6 text-red-500" />
              <h3 className="font-semibold text-gray-900">Heart Rate</h3>
            </div>
            <div className="text-3xl font-bold text-red-500 mb-2">
              {heartRate} BPM
            </div>
            <p className="text-sm text-gray-600">Normal riding range</p>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
            <div className="flex items-center space-x-3 mb-4">
              <Brain className="w-6 h-6 text-purple-500" />
              <h3 className="font-semibold text-gray-900">Stress Level</h3>
            </div>
            <div className={`text-3xl font-bold mb-2 ${getStressColor(stressLevel)}`}>
              {stressLevel}/5
            </div>
            <p className="text-sm text-gray-600">
              {stressLevel <= 2 ? 'Relaxed' : stressLevel <= 4 ? 'Moderate' : 'High'}
            </p>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
            <div className="flex items-center space-x-3 mb-4">
              <Activity className="w-6 h-6 text-emerald-500" />
              <h3 className="font-semibold text-gray-900">Ride Phase</h3>
            </div>
            <div className="text-2xl font-bold text-emerald-500 mb-2 capitalize">
              {currentPhase.replace('-', ' ')}
            </div>
            <p className="text-sm text-gray-600">Current activity</p>
          </div>
        </div>

        {/* AI Coaching Messages */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Brain className="w-6 h-6 text-blue-600 mr-3" />
            AI Coaching Guidance
          </h2>
          
          <div className="space-y-4 max-h-96 overflow-y-auto">
            {aiCoaching.length === 0 ? (
              <div className="text-center py-8">
                <Brain className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">
                  Start your ride session to receive real-time AI coaching and guidance
                </p>
              </div>
            ) : (
              aiCoaching.map((message) => (
                <div key={message.id} className="flex items-start space-x-4 p-4 bg-blue-50 rounded-xl">
                  <div className="p-2 bg-blue-100 rounded-lg flex-shrink-0">
                    <Brain className="w-5 h-5 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-gray-900 font-medium mb-1">{message.message}</p>
                    <p className="text-xs text-gray-500">
                      {message.timestamp.toLocaleTimeString()}
                    </p>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Quick Actions */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-6">Quick Actions</h2>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <button 
              onClick={() => toast.info('Starting breathing exercise...')}
              className="p-4 bg-green-50 hover:bg-green-100 rounded-xl transition-colors text-center"
            >
              <Wind className="w-8 h-8 text-green-600 mx-auto mb-2" />
              <span className="text-sm font-medium text-green-800">Breathing</span>
            </button>
            
            <button 
              onClick={() => toast.info('Posture reminder activated')}
              className="p-4 bg-blue-50 hover:bg-blue-100 rounded-xl transition-colors text-center"
            >
              <CheckCircle className="w-8 h-8 text-blue-600 mx-auto mb-2" />
              <span className="text-sm font-medium text-blue-800">Posture Check</span>
            </button>
            
            <button 
              onClick={() => setCurrentPhase('cool-down')}
              className="p-4 bg-purple-50 hover:bg-purple-100 rounded-xl transition-colors text-center"
            >
              <Heart className="w-8 h-8 text-purple-600 mx-auto mb-2" />
              <span className="text-sm font-medium text-purple-800">Cool Down</span>
            </button>
            
            <button 
              onClick={handleEmergencyStop}
              className="p-4 bg-red-50 hover:bg-red-100 rounded-xl transition-colors text-center"
            >
              <AlertTriangle className="w-8 h-8 text-red-600 mx-auto mb-2" />
              <span className="text-sm font-medium text-red-800">Emergency</span>
            </button>
          </div>
        </div>

        {/* Session Status */}
        {isActive && (
          <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-6 text-center">
            <div className="flex items-center justify-center space-x-3 mb-3">
              <div className="w-3 h-3 bg-emerald-500 rounded-full animate-pulse"></div>
              <span className="font-semibold text-emerald-800">Session Active</span>
            </div>
            <p className="text-emerald-700">
              AI coaching is monitoring your ride and providing real-time guidance. 
              Stay relaxed and enjoy your time with your horse!
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default DuringRideCoaching;