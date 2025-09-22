import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { toast } from 'sonner';
import { 
  ArrowLeft, 
  TrendingUp, 
  Award, 
  Heart, 
  Brain,
  Target,
  MessageSquare,
  Share2,
  Save,
  Star,
  Clock,
  Activity
} from 'lucide-react';

const PostRideAnalysis = ({ currentRider }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const sessionData = location.state;
  
  const [performanceScore, setPerformanceScore] = useState(8.2);
  const [confidenceLevel, setConfidenceLevel] = useState(7.8);
  const [stressReduction, setStressReduction] = useState(65);
  const [notes, setNotes] = useState('');
  const [horseFeedback, setHorseFeedback] = useState({
    energy: 8,
    responsiveness: 9,
    mood: 'positive'
  });

  const analysisData = {
    duration: sessionData?.duration || 2420, // 40:20 in seconds
    avgHeartRate: sessionData?.finalHeartRate || 85,
    maxHeartRate: 102,
    stressLevel: sessionData?.finalStressLevel || 2,
    achievements: [
      'Maintained calm breathing throughout session',
      'Excellent posture in challenging transitions',
      'Strong connection with horse observed',
      'Anxiety levels decreased significantly'
    ],
    improvements: [
      'Focus on softer hands during collection work',
      'Practice deeper breathing in trot transitions',
      'Continue building confidence in jumping exercises'
    ],
    aiInsights: [
      'Your breathing patterns were 40% more consistent than your last session',
      'Horse responded positively to your calm energy throughout the ride',
      'Significant improvement in handling anxiety triggers',
      'Recommend continuing current mental preparation routine'
    ]
  };

  const formatDuration = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const saveSession = async () => {
    try {
      // In a real app, this would save to the backend
      toast.success('Session analysis saved successfully!');
      navigate('/dashboard');
    } catch (error) {
      toast.error('Failed to save session');
    }
  };

  const shareResults = () => {
    toast.success('Session results shared with your coach!');
  };

  const getScoreColor = (score) => {
    if (score >= 8) return 'text-emerald-600';
    if (score >= 6) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getScoreText = (score) => {
    if (score >= 8.5) return 'Excellent';
    if (score >= 7) return 'Very Good';
    if (score >= 5.5) return 'Good';
    return 'Needs Improvement';
  };

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
                <h1 className="text-2xl font-bold text-gray-900">Post-Ride Analysis</h1>
                <p className="text-emerald-600">Session completed • {new Date().toLocaleDateString()}</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <button
                onClick={shareResults}
                className="flex items-center space-x-2 bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors"
              >
                <Share2 className="w-4 h-4" />
                <span className="hidden md:inline">Share</span>
              </button>
              
              <button
                onClick={saveSession}
                className="flex items-center space-x-2 bg-emerald-500 hover:bg-emerald-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors"
              >
                <Save className="w-4 h-4" />
                <span className="hidden md:inline">Save</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        
        {/* Overall Performance */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-8 text-center">Session Performance</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="text-center">
              <div className="w-20 h-20 mx-auto mb-4 bg-emerald-100 rounded-full flex items-center justify-center">
                <Award className="w-10 h-10 text-emerald-600" />
              </div>
              <div className={`text-3xl font-bold mb-1 ${getScoreColor(performanceScore)}`}>
                {performanceScore}/10
              </div>
              <p className="text-sm text-gray-600">Overall Score</p>
              <p className="text-xs font-medium text-emerald-600 mt-1">
                {getScoreText(performanceScore)}
              </p>
            </div>
            
            <div className="text-center">
              <div className="w-20 h-20 mx-auto mb-4 bg-blue-100 rounded-full flex items-center justify-center">
                <Brain className="w-10 h-10 text-blue-600" />
              </div>
              <div className="text-3xl font-bold text-blue-600 mb-1">
                {confidenceLevel}/10
              </div>
              <p className="text-sm text-gray-600">Confidence</p>
              <p className="text-xs font-medium text-blue-600 mt-1">
                +0.8 from pre-ride
              </p>
            </div>
            
            <div className="text-center">
              <div className="w-20 h-20 mx-auto mb-4 bg-purple-100 rounded-full flex items-center justify-center">
                <Heart className="w-10 h-10 text-purple-600" />
              </div>
              <div className="text-3xl font-bold text-purple-600 mb-1">
                {stressReduction}%
              </div>
              <p className="text-sm text-gray-600">Stress Reduction</p>
              <p className="text-xs font-medium text-purple-600 mt-1">
                Excellent progress
              </p>
            </div>
            
            <div className="text-center">
              <div className="w-20 h-20 mx-auto mb-4 bg-orange-100 rounded-full flex items-center justify-center">
                <Clock className="w-10 h-10 text-orange-600" />
              </div>
              <div className="text-3xl font-bold text-orange-600 mb-1">
                {formatDuration(analysisData.duration)}
              </div>
              <p className="text-sm text-gray-600">Duration</p>
              <p className="text-xs font-medium text-orange-600 mt-1">
                Optimal length
              </p>
            </div>
          </div>
        </div>

        {/* Detailed Metrics */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Physical Metrics */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Activity className="w-6 h-6 text-red-500 mr-3" />
              Physical Metrics
            </h3>
            
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <span className="text-gray-700">Average Heart Rate</span>
                <span className="font-semibold text-red-500">{analysisData.avgHeartRate} BPM</span>
              </div>
              
              <div className="flex items-center justify-between">
                <span className="text-gray-700">Max Heart Rate</span>
                <span className="font-semibold text-red-600">{analysisData.maxHeartRate} BPM</span>
              </div>
              
              <div className="flex items-center justify-between">
                <span className="text-gray-700">Final Stress Level</span>
                <span className="font-semibold text-green-500">{analysisData.stressLevel}/5</span>
              </div>
              
              <div className="pt-4 border-t border-gray-200">
                <p className="text-sm text-gray-600">
                  Your heart rate stayed within the optimal training zone for 92% of the session.
                  Excellent cardiovascular management throughout the ride.
                </p>
              </div>
            </div>
          </div>

          {/* Horse Feedback */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Heart className="w-6 h-6 text-pink-500 mr-3" />
              Horse Feedback
            </h3>
            
            <div className="space-y-6">
              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-gray-700">Energy Level</span>
                  <span className="font-semibold text-emerald-600">{horseFeedback.energy}/10</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-emerald-500 h-2 rounded-full" 
                    style={{ width: `${horseFeedback.energy * 10}%` }}
                  ></div>
                </div>
              </div>
              
              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-gray-700">Responsiveness</span>
                  <span className="font-semibold text-blue-600">{horseFeedback.responsiveness}/10</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-blue-500 h-2 rounded-full" 
                    style={{ width: `${horseFeedback.responsiveness * 10}%` }}
                  ></div>
                </div>
              </div>
              
              <div className="flex items-center justify-between">
                <span className="text-gray-700">Overall Mood</span>
                <span className="font-semibold text-green-500 capitalize">{horseFeedback.mood}</span>
              </div>
              
              <div className="pt-4 border-t border-gray-200">
                <p className="text-sm text-gray-600">
                  Your horse showed excellent cooperation and positive energy throughout the session.
                  The bond between you two was clearly visible.
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* AI Insights */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <Brain className="w-6 h-6 text-purple-600 mr-3" />
            AI Performance Insights
          </h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h4 className="font-semibold text-emerald-800 mb-4 flex items-center">
                <Star className="w-5 h-5 mr-2" />
                Key Achievements
              </h4>
              <div className="space-y-3">
                {analysisData.achievements.map((achievement, index) => (
                  <div key={index} className="flex items-start space-x-3">
                    <div className="w-2 h-2 bg-emerald-500 rounded-full mt-2 flex-shrink-0"></div>
                    <p className="text-gray-700 text-sm">{achievement}</p>
                  </div>
                ))}
              </div>
            </div>
            
            <div>
              <h4 className="font-semibold text-blue-800 mb-4 flex items-center">
                <Target className="w-5 h-5 mr-2" />
                Areas for Improvement
              </h4>
              <div className="space-y-3">
                {analysisData.improvements.map((improvement, index) => (
                  <div key={index} className="flex items-start space-x-3">
                    <div className="w-2 h-2 bg-blue-500 rounded-full mt-2 flex-shrink-0"></div>
                    <p className="text-gray-700 text-sm">{improvement}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
          
          <div className="mt-8 p-6 bg-purple-50 rounded-xl">
            <h4 className="font-semibold text-purple-800 mb-4">AI Analysis Summary</h4>
            <div className="space-y-2">
              {analysisData.aiInsights.map((insight, index) => (
                <p key={index} className="text-purple-700 text-sm">• {insight}</p>
              ))}
            </div>
          </div>
        </div>

        {/* Session Notes */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <MessageSquare className="w-6 h-6 text-indigo-600 mr-3" />
            Session Notes
          </h3>
          
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            rows={4}
            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 resize-none"
            placeholder="Add your thoughts about this session, goals for next time, or any observations..."
          />
          
          <div className="mt-4 flex items-center justify-between">
            <p className="text-sm text-gray-600">
              Your notes will be saved and available for future reference
            </p>
            <button
              onClick={() => toast.success('Notes saved!')}
              className="bg-indigo-500 hover:bg-indigo-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors"
            >
              Save Notes
            </button>
          </div>
        </div>

        {/* Next Steps */}
        <div className="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-2xl p-8 text-white">
          <h3 className="text-xl font-bold mb-4">Congratulations on a Great Session!</h3>
          <p className="text-emerald-100 mb-6">
            Based on your performance, you're making excellent progress in managing anxiety and 
            building confidence. Your connection with your horse continues to strengthen.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4">
            <button
              onClick={() => navigate('/dashboard')}
              className="bg-white text-emerald-600 hover:bg-emerald-50 px-6 py-3 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
            >
              <TrendingUp className="w-5 h-5" />
              <span>View Progress</span>
            </button>
            
            <button
              onClick={() => navigate('/pre-ride')}
              className="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-3 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
            >
              <Target className="w-5 h-5" />
              <span>Plan Next Session</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PostRideAnalysis;