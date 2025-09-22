import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  Heart, 
  TrendingUp, 
  Clock, 
  Shield, 
  Play, 
  Settings,
  Calendar,
  Award,
  AlertTriangle,
  Brain,
  Target,
  Activity
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const Dashboard = ({ currentRider }) => {
  const navigate = useNavigate();
  const [analytics, setAnalytics] = useState(null);
  const [recentSessions, setRecentSessions] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (currentRider?.id) {
      fetchDashboardData();
    }
  }, [currentRider]);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      
      // Fetch analytics
      const analyticsResponse = await axios.get(`${API}/riders/${currentRider.id}/analytics`);
      setAnalytics(analyticsResponse.data);
      
      // Fetch recent sessions
      const sessionsResponse = await axios.get(`${API}/riders/${currentRider.id}/sessions?limit=5`);
      setRecentSessions(sessionsResponse.data);
      
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      toast.error('Unable to load dashboard data');
      
      // Set mock data for demo
      setAnalytics({
        total_sessions: 12,
        avg_confidence_level: 7.8,
        avg_anxiety_level: 3.2,
        recent_performance_trend: 'improving',
        completed_sessions: 10,
        emergency_events_count: 1
      });
      
      setRecentSessions([
        {
          id: 'session-1',
          session_type: 'pre_ride',
          ride_type: 'show_jumping',
          created_at: new Date().toISOString(),
          progress_percentage: 85,
          performance_score: 8.5
        }
      ]);
    } finally {
      setLoading(false);
    }
  };

  const startNewSession = (sessionType, rideType) => {
    navigate('/pre-ride', { 
      state: { 
        sessionType, 
        rideType,
        riderId: currentRider.id 
      } 
    });
  };

  const handleEmergencySupport = () => {
    navigate('/emergency');
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-emerald-50 via-teal-50 to-cyan-100">
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="animate-pulse space-y-8">
            <div className="h-32 bg-white/50 rounded-2xl"></div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {[1, 2, 3].map(i => (
                <div key={i} className="h-48 bg-white/50 rounded-2xl"></div>
              ))}
            </div>
          </div>
        </div>
      </div>
    );
  }

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  };

  const getEmotionalStateColor = (level) => {
    if (level >= 8) return 'text-emerald-600';
    if (level >= 6) return 'text-green-600';
    if (level >= 4) return 'text-yellow-600';
    return 'text-red-600';
  };

  const heroImages = [
    'https://images.unsplash.com/photo-1695133994223-02698c56f100?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwxfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85',
    'https://images.unsplash.com/photo-1594768816441-1dd241ffaa67?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwyfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85'
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-emerald-50 via-teal-50 to-cyan-100">
      {/* Header Section */}
      <div className="relative overflow-hidden">
        <div className="absolute inset-0">
          <img 
            src={heroImages[0]} 
            alt="Equestrian" 
            className="w-full h-full object-cover opacity-20"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-emerald-900/80 to-teal-900/60"></div>
        </div>
        
        <div className="relative max-w-7xl mx-auto px-4 py-16">
          <div className="flex items-center justify-between">
            <div className="space-y-4">
              <h1 className="text-4xl md:text-5xl font-bold text-white">
                {getGreeting()}, {currentRider?.name}
              </h1>
              <p className="text-xl text-emerald-100 max-w-2xl">
                Ready to elevate your equestrian performance with evidence-based mental training?
              </p>
            </div>
            
            <button
              onClick={handleEmergencySupport}
              className="hidden md:flex items-center space-x-2 bg-red-500 hover:bg-red-600 text-white px-6 py-3 rounded-xl font-semibold transition-all duration-200 emergency-pulse"
            >
              <Shield className="w-5 h-5" />
              <span>Emergency Support</span>
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 py-8 space-y-8">
        
        {/* Quick Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-emerald-100 rounded-xl">
                <TrendingUp className="w-6 h-6 text-emerald-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Confidence Level</p>
                <p className={`text-2xl font-bold ${getEmotionalStateColor(analytics?.avg_confidence_level || 0)}`}>
                  {analytics?.avg_confidence_level || 0}/10
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-blue-100 rounded-xl">
                <Calendar className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Total Sessions</p>
                <p className="text-2xl font-bold text-gray-900">
                  {analytics?.total_sessions || 0}
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-purple-100 rounded-xl">
                <Brain className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Anxiety Level</p>
                <p className="text-2xl font-bold text-purple-600">
                  {analytics?.avg_anxiety_level || 0}/10
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-orange-100 rounded-xl">
                <Award className="w-6 h-6 text-orange-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Completion Rate</p>
                <p className="text-2xl font-bold text-orange-600">
                  {Math.round(((analytics?.completed_sessions || 0) / (analytics?.total_sessions || 1)) * 100)}%
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Start Your Session</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            
            {/* Show Jumping Session */}
            <div className="group cursor-pointer" onClick={() => startNewSession('pre_ride', 'show_jumping')}>
              <div className="relative overflow-hidden rounded-2xl transition-all duration-300 group-hover:scale-105">
                <img 
                  src="https://images.unsplash.com/photo-1512934772407-b292436089ee?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHwxfHxzaG93JTIwanVtcGluZ3xlbnwwfHx8fDE3NTg1MDE2MDB8MA&ixlib=rb-4.1.0&q=85" 
                  alt="Show Jumping" 
                  className="w-full h-48 object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"></div>
                <div className="absolute bottom-4 left-4 right-4">
                  <h3 className="text-xl font-bold text-white mb-2">Show Jumping</h3>
                  <p className="text-emerald-200 text-sm">Mental preparation for jumping disciplines</p>
                  <div className="flex items-center mt-3 text-white">
                    <Play className="w-5 h-5 mr-2" />
                    <span className="font-semibold">Start Session</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Dressage Session */}
            <div className="group cursor-pointer" onClick={() => startNewSession('pre_ride', 'dressage')}>
              <div className="relative overflow-hidden rounded-2xl transition-all duration-300 group-hover:scale-105">
                <img 
                  src="https://images.unsplash.com/flagged/photo-1568382007362-5d0d0a26b422?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2Njl8MHwxfHNlYXJjaHwxfHxkcmVzc2FnZXxlbnwwfHx8fDE3NTg1MDE2MDZ8MA&ixlib=rb-4.1.0&q=85" 
                  alt="Dressage" 
                  className="w-full h-48 object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"></div>
                <div className="absolute bottom-4 left-4 right-4">
                  <h3 className="text-xl font-bold text-white mb-2">Dressage</h3>
                  <p className="text-emerald-200 text-sm">Focus and harmony preparation</p>
                  <div className="flex items-center mt-3 text-white">
                    <Play className="w-5 h-5 mr-2" />
                    <span className="font-semibold">Start Session</span>
                  </div>
                </div>
              </div>
            </div>

            {/* General Training Session */}
            <div className="group cursor-pointer" onClick={() => startNewSession('pre_ride', 'general_training')}>
              <div className="relative overflow-hidden rounded-2xl transition-all duration-300 group-hover:scale-105">
                <img 
                  src="https://images.unsplash.com/photo-1695133996154-e09d82de12b9?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHw0fHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85" 
                  alt="General Training" 
                  className="w-full h-48 object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"></div>
                <div className="absolute bottom-4 left-4 right-4">
                  <h3 className="text-xl font-bold text-white mb-2">General Training</h3>
                  <p className="text-emerald-200 text-sm">All-around mental preparation</p>
                  <div className="flex items-center mt-3 text-white">
                    <Play className="w-5 h-5 mr-2" />
                    <span className="font-semibold">Start Session</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Recent Activity & Tools */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Recent Sessions */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Recent Activity</h2>
            
            {recentSessions.length > 0 ? (
              <div className="space-y-4">
                {recentSessions.slice(0, 3).map((session, index) => (
                  <div key={session.id || index} className="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                    <div className="p-2 bg-emerald-100 rounded-lg">
                      <Activity className="w-5 h-5 text-emerald-600" />
                    </div>
                    <div className="flex-1">
                      <h3 className="font-semibold text-gray-900 capitalize">
                        {session.ride_type?.replace('_', ' ') || 'Training Session'}
                      </h3>
                      <p className="text-sm text-gray-600">
                        {new Date(session.created_at).toLocaleDateString()} • 
                        Progress: {session.progress_percentage || 0}%
                      </p>
                    </div>
                    {session.performance_score && (
                      <div className="text-right">
                        <p className="font-bold text-emerald-600">{session.performance_score}/10</p>
                        <p className="text-xs text-gray-500">Score</p>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8">
                <Clock className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">No recent sessions. Start your first session above!</p>
              </div>
            )}
          </div>

          {/* Mental Health Tools */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Mental Health Tools</h2>
            
            <div className="space-y-4">
              <button
                onClick={handleEmergencySupport}
                className="w-full flex items-center space-x-4 p-4 bg-red-50 hover:bg-red-100 rounded-xl transition-colors group"
              >
                <div className="p-2 bg-red-100 group-hover:bg-red-200 rounded-lg">
                  <AlertTriangle className="w-5 h-5 text-red-600" />
                </div>
                <div className="text-left">
                  <h3 className="font-semibold text-gray-900">Emergency Support</h3>
                  <p className="text-sm text-gray-600">Immediate anxiety & fear management</p>
                </div>
              </button>
              
              <button
                onClick={() => navigate('/pre-ride')}
                className="w-full flex items-center space-x-4 p-4 bg-blue-50 hover:bg-blue-100 rounded-xl transition-colors group"
              >
                <div className="p-2 bg-blue-100 group-hover:bg-blue-200 rounded-lg">
                  <Brain className="w-5 h-5 text-blue-600" />
                </div>
                <div className="text-left">
                  <h3 className="font-semibold text-gray-900">Pre-Ride Preparation</h3>
                  <p className="text-sm text-gray-600">Breathing exercises & emotional assessment</p>
                </div>
              </button>
              
              <button
                onClick={() => navigate('/profile')}
                className="w-full flex items-center space-x-4 p-4 bg-purple-50 hover:bg-purple-100 rounded-xl transition-colors group"
              >
                <div className="p-2 bg-purple-100 group-hover:bg-purple-200 rounded-lg">
                  <Settings className="w-5 h-5 text-purple-600" />
                </div>
                <div className="text-left">
                  <h3 className="font-semibold text-gray-900">Rider Profile</h3>
                  <p className="text-sm text-gray-600">Manage preferences & progress tracking</p>
                </div>
              </button>
            </div>
          </div>
        </div>

        {/* Progress Insight */}
        {analytics && (
          <div className="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-2xl p-8 text-white">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold mb-2">Your Progress Insight</h2>
                <p className="text-emerald-100 text-lg">
                  Your confidence has been {analytics.recent_performance_trend} with an average of {analytics.avg_confidence_level}/10. 
                  Keep up the excellent work!
                </p>
              </div>
              <div className="hidden md:block">
                <Target className="w-16 h-16 text-emerald-200" />
              </div>
            </div>
          </div>
        )}
      </div>
      
      {/* Emergency FAB for mobile */}
      <button
        onClick={handleEmergencySupport}
        className="md:hidden fixed bottom-6 right-6 bg-red-500 hover:bg-red-600 text-white p-4 rounded-full shadow-2xl emergency-pulse z-50"
      >
        <Shield className="w-6 h-6" />
      </button>
    </div>
  );
};

export default Dashboard;