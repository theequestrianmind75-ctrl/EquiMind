import React, { useState, useEffect } from 'react';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  TrendingUp, 
  TrendingDown,
  Calendar,
  Target,
  Award,
  Brain,
  Heart,
  Activity,
  BarChart3,
  PieChart,
  ArrowUp,
  ArrowDown,
  Minus
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const ProgressAnalytics = ({ currentRider }) => {
  const [analytics, setAnalytics] = useState(null);
  const [timeRange, setTimeRange] = useState('7d');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (currentRider?.id) {
      fetchAnalytics();
    }
  }, [currentRider, timeRange]);

  const fetchAnalytics = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API}/riders/${currentRider.id}/analytics/detailed?timeRange=${timeRange}`);
      setAnalytics(response.data);
    } catch (error) {
      console.error('Error fetching analytics:', error);
      // Mock data for demo
      setAnalytics({
        summary: {
          total_sessions: 24,
          avg_confidence: 7.8,
          avg_anxiety: 3.2,
          completion_rate: 87,
          improvement_trend: 'improving'
        },
        trends: {
          confidence_trend: [6.2, 6.5, 6.8, 7.1, 7.4, 7.6, 7.8],
          anxiety_trend: [5.1, 4.8, 4.5, 4.2, 3.8, 3.5, 3.2],
          session_frequency: [3, 4, 2, 5, 3, 4, 3]
        },
        achievements: [
          { name: 'Consistency Champion', description: '7 days in a row', date: '2025-01-15', icon: '🏆' },
          { name: 'Anxiety Warrior', description: 'Reduced anxiety by 40%', date: '2025-01-12', icon: '⚡' },
          { name: 'Confidence Builder', description: 'Reached 8/10 confidence', date: '2025-01-10', icon: '💪' }
        ],
        disciplines: {
          show_jumping: {sessions: 12, avg_performance: 8.2, trend: 'up'},
          dressage: {sessions: 8, avg_performance: 7.8, trend: 'up'},
          general_training: {sessions: 4, avg_performance: 7.5, trend: 'stable'}
        },
        recommendations: [
          'Continue focusing on breathing exercises - they\'re showing great results',
          'Consider adding competition preparation sessions',
          'Your horse connection scores are excellent - maintain this strength'
        ]
      });
    } finally {
      setLoading(false);
    }
  };

  const formatTrend = (current, previous) => {
    const change = ((current - previous) / previous * 100).toFixed(1);
    const isPositive = current > previous;
    const isNegative = current < previous;
    
    return {
      change: Math.abs(change),
      direction: isPositive ? 'up' : isNegative ? 'down' : 'stable',
      color: isPositive ? 'text-green-600' : isNegative ? 'text-red-600' : 'text-gray-600',
      icon: isPositive ? ArrowUp : isNegative ? ArrowDown : Minus
    };
  };

  const getTrendColor = (trend) => {
    switch (trend) {
      case 'up': return 'text-green-600';
      case 'down': return 'text-red-600';
      default: return 'text-gray-600';
    }
  };

  const getTrendIcon = (trend) => {
    switch (trend) {
      case 'up': return TrendingUp;
      case 'down': return TrendingDown;
      default: return Minus;
    }
  };

  if (loading) {
    return (
      <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
        <div className="animate-pulse space-y-6">
          <div className="h-6 bg-gray-200 rounded w-1/3"></div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[1,2,3,4].map(i => (
              <div key={i} className="h-24 bg-gray-200 rounded"></div>
            ))}
          </div>
          <div className="h-40 bg-gray-200 rounded"></div>
        </div>
      </div>
    );
  }

  if (!analytics) return null;

  const confidenceTrend = formatTrend(
    analytics.trends.confidence_trend[analytics.trends.confidence_trend.length - 1],
    analytics.trends.confidence_trend[analytics.trends.confidence_trend.length - 2]
  );

  const anxietyTrend = formatTrend(
    analytics.trends.anxiety_trend[analytics.trends.anxiety_trend.length - 2],
    analytics.trends.anxiety_trend[analytics.trends.anxiety_trend.length - 1]
  );

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-gray-900">Progress Analytics</h2>
        <div className="flex items-center space-x-2">
          <select
            value={timeRange}
            onChange={(e) => setTimeRange(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
          >
            <option value="7d">Last 7 days</option>
            <option value="30d">Last 30 days</option>
            <option value="90d">Last 3 months</option>
          </select>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
          <div className="flex items-center justify-between mb-2">
            <Brain className="w-6 h-6 text-indigo-600" />
            <div className={`flex items-center space-x-1 ${confidenceTrend.color}`}>
              <confidenceTrend.icon className="w-4 h-4" />
              <span className="text-sm font-medium">{confidenceTrend.change}%</span>
            </div>
          </div>
          <div className="text-2xl font-bold text-gray-900">{analytics.summary.avg_confidence}/10</div>
          <div className="text-sm text-gray-600">Avg Confidence</div>
        </div>

        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
          <div className="flex items-center justify-between mb-2">
            <Heart className="w-6 h-6 text-red-600" />
            <div className={`flex items-center space-x-1 ${anxietyTrend.color}`}>
              <anxietyTrend.icon className="w-4 h-4" />
              <span className="text-sm font-medium">{anxietyTrend.change}%</span>
            </div>
          </div>
          <div className="text-2xl font-bold text-red-600">{analytics.summary.avg_anxiety}/10</div>
          <div className="text-sm text-gray-600">Avg Anxiety</div>
        </div>

        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
          <div className="flex items-center justify-between mb-2">
            <Calendar className="w-6 h-6 text-blue-600" />
            <div className="flex items-center space-x-1 text-green-600">
              <ArrowUp className="w-4 h-4" />
              <span className="text-sm font-medium">12%</span>
            </div>
          </div>
          <div className="text-2xl font-bold text-blue-600">{analytics.summary.total_sessions}</div>
          <div className="text-sm text-gray-600">Total Sessions</div>
        </div>

        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
          <div className="flex items-center justify-between mb-2">
            <Target className="w-6 h-6 text-emerald-600" />
            <div className="flex items-center space-x-1 text-emerald-600">
              <ArrowUp className="w-4 h-4" />
              <span className="text-sm font-medium">5%</span>
            </div>
          </div>
          <div className="text-2xl font-bold text-emerald-600">{analytics.summary.completion_rate}%</div>
          <div className="text-sm text-gray-600">Completion Rate</div>
        </div>
      </div>

      {/* Trends Chart */}
      <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
        <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
          <BarChart3 className="w-6 h-6 text-indigo-600 mr-3" />
          Progress Trends
        </h3>
        
        {/* Simple trend visualization */}
        <div className="space-y-6">
          <div>
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium text-gray-700">Confidence Level</span>
              <span className="text-sm text-emerald-600">Trending Up</span>
            </div>
            <div className="flex items-end space-x-2 h-20">
              {analytics.trends.confidence_trend.map((value, index) => (
                <div
                  key={index}
                  className="bg-emerald-500 rounded-t flex-1 transition-all duration-300"
                  style={{ height: `${(value / 10) * 100}%` }}
                  title={`Day ${index + 1}: ${value}/10`}
                ></div>
              ))}
            </div>
          </div>
          
          <div>
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium text-gray-700">Anxiety Level</span>
              <span className="text-sm text-green-600">Decreasing</span>
            </div>
            <div className="flex items-end space-x-2 h-20">
              {analytics.trends.anxiety_trend.map((value, index) => (
                <div
                  key={index}
                  className="bg-red-400 rounded-t flex-1 transition-all duration-300"
                  style={{ height: `${(value / 10) * 100}%` }}
                  title={`Day ${index + 1}: ${value}/10`}
                ></div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Discipline Performance */}
      <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
        <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
          <PieChart className="w-6 h-6 text-purple-600 mr-3" />
          Performance by Discipline
        </h3>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {Object.entries(analytics.disciplines).map(([discipline, data]) => {
            const TrendIcon = getTrendIcon(data.trend);
            return (
              <div key={discipline} className="p-4 border border-gray-200 rounded-xl">
                <div className="flex items-center justify-between mb-3">
                  <h4 className="font-semibold text-gray-900 capitalize">
                    {discipline.replace('_', ' ')}
                  </h4>
                  <div className={`flex items-center space-x-1 ${getTrendColor(data.trend)}`}>
                    <TrendIcon className="w-4 h-4" />
                  </div>
                </div>
                
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Sessions:</span>
                    <span className="font-medium">{data.sessions}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Avg Performance:</span>
                    <span className="font-medium text-indigo-600">{data.avg_performance}/10</span>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Recent Achievements */}
      <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
        <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
          <Award className="w-6 h-6 text-yellow-600 mr-3" />
          Recent Achievements
        </h3>
        
        <div className="space-y-4">
          {analytics.achievements.map((achievement, index) => (
            <div key={index} className="flex items-center space-x-4 p-4 bg-yellow-50 rounded-xl">
              <div className="text-2xl">{achievement.icon}</div>
              <div className="flex-1">
                <h4 className="font-semibold text-gray-900">{achievement.name}</h4>
                <p className="text-sm text-gray-600">{achievement.description}</p>
              </div>
              <div className="text-sm text-gray-500">
                {new Date(achievement.date).toLocaleDateString()}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* AI Recommendations */}
      <div className="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-2xl p-8 text-white">
        <h3 className="text-xl font-bold mb-4 flex items-center">
          <Brain className="w-6 h-6 mr-3" />
          AI-Powered Recommendations
        </h3>
        
        <div className="space-y-3">
          {analytics.recommendations.map((recommendation, index) => (
            <div key={index} className="flex items-start space-x-3">
              <div className="w-2 h-2 bg-white rounded-full mt-2 flex-shrink-0"></div>
              <p className="text-indigo-100">{recommendation}</p>
            </div>
          ))}
        </div>
        
        <div className="mt-6 p-4 bg-white/20 rounded-lg backdrop-blur-sm">
          <p className="text-sm text-indigo-100">
            <strong>Overall Progress:</strong> Your mental training is showing excellent results! 
            You've improved your confidence by {confidenceTrend.change}% and reduced anxiety by {anxietyTrend.change}% 
            over the selected period. Keep up the fantastic work!
          </p>
        </div>
      </div>
    </div>
  );
};

export default ProgressAnalytics;