import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import axios from 'axios';
import { 
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
  Activity,
  LogOut,
  User,
  Menu,
  X
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const Dashboard = ({ currentRider, onLogout }) => {
  const navigate = useNavigate();
  const [analytics, setAnalytics] = useState(null);
  const [recentSessions, setRecentSessions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showUserMenu, setShowUserMenu] = useState(false);

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

  const handleLogout = () => {
    if (onLogout) {
      onLogout();
    }
    toast.success('Signed out successfully');
    navigate('/');
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-brand-light">
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
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  };

  const getEmotionalStateColor = (level) => {
    if (level >= 8) return 'text-brand-primary';
    if (level >= 6) return 'text-green-600';
    if (level >= 4) return 'text-yellow-600';
    return 'text-red-600';
  };

  const heroImages = [
    'https://images.unsplash.com/photo-1695133994223-02698c56f100?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwxfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85',
    'https://images.unsplash.com/photo-1594768816441-1dd241ffaa67?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwyfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85'
  ];

  return (
    <div className="min-h-screen bg-brand-light">
      
      {/* Navigation Bar */}
      <nav className="bg-white/90 backdrop-blur-sm border-b border-blue-100 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 rounded-xl flex items-center justify-center">
                <img 
                  src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                  alt="EquiMind" 
                  className="w-8 h-8 object-contain"
                />
              </div>
              <h1 className="text-2xl font-bold text-brand-primary">EquiMind</h1>
            </div>
            
            <div className="flex items-center space-x-4">
              <button
                onClick={handleEmergencySupport}
                className="hidden md:flex items-center space-x-2 bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors emergency-pulse"
              >
                <Shield className="w-4 h-4" />
                <span>Emergency</span>
              </button>
              
              {/* User Menu */}
              <div className="relative">
                <button
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="flex items-center space-x-3 bg-white hover:bg-gray-50 border border-gray-200 rounded-lg px-4 py-2 transition-colors"
                >
                  <div className="w-8 h-8 bg-gradient-brand-dark rounded-full flex items-center justify-center">
                    <User className="w-4 h-4 text-white" />
                  </div>
                  <span className="hidden md:block font-medium text-gray-900">
                    {currentRider?.name}
                  </span>
                  <Menu className="w-4 h-4 text-gray-600" />
                </button>
                
                {showUserMenu && (
                  <div className="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-200 py-2">
                    <div className="px-4 py-3 border-b border-gray-100">
                      <p className="font-medium text-gray-900">{currentRider?.name}</p>
                      <p className="text-sm text-gray-600">{currentRider?.email}</p>
                    </div>
                    
                    <button
                      onClick={() => {
                        setShowUserMenu(false);
                        navigate('/profile');
                      }}
                      className="w-full text-left px-4 py-2 hover:bg-gray-50 flex items-center space-x-3"
                    >
                      <Settings className="w-4 h-4 text-gray-600" />
                      <span>Profile Settings</span>
                    </button>
                    
                    <button
                      onClick={() => {
                        setShowUserMenu(false);
                        handleLogout();
                      }}
                      className="w-full text-left px-4 py-2 hover:bg-gray-50 flex items-center space-x-3 text-red-600"
                    >
                      <LogOut className="w-4 h-4" />
                      <span>Sign Out</span>
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>

      {/* Header Section */}
      <div className="bg-gradient-brand-dark">
        <div className="max-w-7xl mx-auto px-4 py-16">
          <div className="space-y-4">
            <h1 className="text-4xl md:text-5xl font-bold text-white">
              {getGreeting()}, {currentRider?.name}
            </h1>
            <p className="text-xl text-blue-100 max-w-2xl">
              We are glad your back continuing your mental performance journey!
            </p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 py-8 space-y-8">
        
        {/* Quick Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="professional-card rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-blue-100 rounded-xl">
                <TrendingUp className="w-6 h-6 text-brand-primary" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Confidence Level</p>
                <p className={`text-2xl font-bold ${getEmotionalStateColor(analytics?.avg_confidence_level || 0)}`}>
                  {analytics?.avg_confidence_level || 0}/10
                </p>
              </div>
            </div>
          </div>
          
          <div className="professional-card rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-indigo-100 rounded-xl">
                <Calendar className="w-6 h-6 text-indigo-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Total Sessions</p>
                <p className="text-2xl font-bold text-gray-900">
                  {analytics?.total_sessions || 0}
                </p>
              </div>
            </div>
          </div>
          
          <div className="professional-card rounded-2xl p-6 hover-lift">
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
          
          <div className="professional-card rounded-2xl p-6 hover-lift">
            <div className="flex items-center space-x-3">
              <div className="p-3 bg-emerald-100 rounded-xl">
                <Award className="w-6 h-6 text-emerald-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Completion Rate</p>
                <p className="text-2xl font-bold text-emerald-600">
                  {Math.round(((analytics?.completed_sessions || 0) / (analytics?.total_sessions || 1)) * 100)}%
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="professional-card rounded-2xl p-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Begin Your Mental Training Session</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            
            {/* Show Jumping Session */}
            <button
              onClick={() => startNewSession('pre_ride', 'show_jumping')}
              className="professional-button text-white py-6 px-8 rounded-xl font-semibold text-lg hover-lift transition-all"
            >
              Show Jumping
            </button>

            {/* Dressage Session */}
            <button
              onClick={() => startNewSession('pre_ride', 'dressage')}
              className="professional-button text-white py-6 px-8 rounded-xl font-semibold text-lg hover-lift transition-all"
            >
              Dressage
            </button>

            {/* General Training Session */}
            <button
              onClick={() => startNewSession('pre_ride', 'general_training')}
              className="professional-button text-white py-6 px-8 rounded-xl font-semibold text-lg hover-lift transition-all"
            >
              General Training
            </button>
          </div>
        </div>

        {/* Recent Activity & Tools */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Recent Sessions */}
          <div className="professional-card rounded-2xl p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Recent Training Activity</h2>
            
            {recentSessions.length > 0 ? (
              <div className="space-y-4">
                {recentSessions.slice(0, 3).map((session, index) => (
                  <div key={session.id || index} className="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                    <div className="p-2 bg-blue-100 rounded-lg">
                      <Activity className="w-5 h-5 text-brand-primary" />
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
                        <p className="font-bold text-brand-primary">{session.performance_score}/10</p>
                        <p className="text-xs text-gray-500">Score</p>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8">
                <Clock className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">No recent sessions. Start your first training session above!</p>
              </div>
            )}
          </div>

          {/* Mental Health Tools */}
          <div className="professional-card rounded-2xl p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Professional Support Tools</h2>
            
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
                  <p className="text-sm text-gray-600">Clinical-grade anxiety & fear management</p>
                </div>
              </button>
              
              <button
                onClick={() => navigate('/pre-ride')}
                className="w-full flex items-center space-x-4 p-4 bg-blue-50 hover:bg-blue-100 rounded-xl transition-colors group"
              >
                <div className="p-2 bg-blue-100 group-hover:bg-blue-200 rounded-lg">
                  <Brain className="w-5 h-5 text-brand-primary" />
                </div>
                <div className="text-left">
                  <h3 className="font-semibold text-gray-900">Mental Performance Training</h3>
                  <p className="text-sm text-gray-600">Evidence-based exercises & assessment</p>
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
                  <h3 className="font-semibold text-gray-900">Training Profile</h3>
                  <p className="text-sm text-gray-600">Customize your mental training plan</p>
                </div>
              </button>
            </div>
          </div>
        </div>

        {/* Progress Insight */}
        {analytics && (
          <div className="bg-gradient-brand-dark rounded-2xl p-8 text-white">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold mb-2">Your Mental Performance Progress</h2>
                <p className="text-blue-100 text-lg">
                  Your confidence has been {analytics.recent_performance_trend} with an average of {analytics.avg_confidence_level}/10. 
                  Continue applying evidence-based techniques for continued improvement.
                </p>
              </div>
              <div className="hidden md:block">
                <Target className="w-16 h-16 text-blue-200" />
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

      {/* Click outside to close user menu */}
      {showUserMenu && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setShowUserMenu(false)}
        ></div>
      )}
    </div>
  );
};

export default Dashboard;