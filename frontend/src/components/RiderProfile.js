import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import { 
  ArrowLeft, 
  User, 
  Mail, 
  Award, 
  Target,
  Settings,
  Bell,
  Shield,
  Heart,
  Calendar,
  TrendingUp,
  Edit3,
  Save
} from 'lucide-react';

const RiderProfile = ({ currentRider, setCurrentRider }) => {
  const navigate = useNavigate();
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState({
    name: currentRider?.name || '',
    email: currentRider?.email || '',
    experience_level: currentRider?.experience_level || 'Intermediate',
    preferred_disciplines: currentRider?.preferred_disciplines || []
  });
  const [preferences, setPreferences] = useState({
    notifications: true,
    emergencyContact: '+1 (555) 123-4567',
    coachingIntensity: 'moderate',
    privacyLevel: 'standard'
  });

  const disciplineOptions = [
    { id: 'show_jumping', label: 'Show Jumping', icon: '🏇' },
    { id: 'dressage', label: 'Dressage', icon: '🎯' },
    { id: 'general_training', label: 'General Training', icon: '🐎' },
    { id: 'competition', label: 'Competition', icon: '🏆' }
  ];

  const experienceLevels = ['Beginner', 'Intermediate', 'Advanced', 'Professional'];

  const handleSave = () => {
    const updatedRider = { ...currentRider, ...formData };
    setCurrentRider(updatedRider);
    setIsEditing(false);
    toast.success('Profile updated successfully!');
  };

  const handleDisciplineToggle = (disciplineId) => {
    const currentDisciplines = formData.preferred_disciplines;
    const newDisciplines = currentDisciplines.includes(disciplineId)
      ? currentDisciplines.filter(d => d !== disciplineId)
      : [...currentDisciplines, disciplineId];
    
    setFormData({ ...formData, preferred_disciplines: newDisciplines });
  };

  const statsData = [
    { label: 'Total Sessions', value: '24', icon: Calendar, color: 'text-blue-600' },
    { label: 'Avg Confidence', value: '7.8/10', icon: TrendingUp, color: 'text-emerald-600' },
    { label: 'Anxiety Reduction', value: '65%', icon: Heart, color: 'text-purple-600' },
    { label: 'Emergency Uses', value: '3', icon: Shield, color: 'text-red-600' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-purple-50 to-pink-100">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur-sm border-b border-indigo-100">
        <div className="max-w-4xl mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/dashboard')}
                className="p-2 hover:bg-indigo-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-6 h-6 text-indigo-600" />
              </button>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">Rider Profile</h1>
                <p className="text-indigo-600">Manage your account and preferences</p>
              </div>
            </div>
            
            <button
              onClick={() => setIsEditing(!isEditing)}
              className={`flex items-center space-x-2 px-4 py-2 rounded-lg font-semibold transition-colors ${
                isEditing 
                  ? 'bg-emerald-500 hover:bg-emerald-600 text-white'
                  : 'bg-indigo-500 hover:bg-indigo-600 text-white'
              }`}
            >
              {isEditing ? <Save className="w-4 h-4" /> : <Edit3 className="w-4 h-4" />}
              <span>{isEditing ? 'Save Changes' : 'Edit Profile'}</span>
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        
        {/* Profile Header */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
          <div className="flex items-center space-x-6 mb-8">
            <div className="w-24 h-24 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full flex items-center justify-center">
              <User className="w-12 h-12 text-white" />
            </div>
            <div className="flex-1">
              {isEditing ? (
                <div className="space-y-4">
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    className="text-2xl font-bold bg-transparent border-b-2 border-indigo-300 focus:border-indigo-500 outline-none"
                    placeholder="Your Name"
                  />
                  <input
                    type="email"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    className="text-lg text-gray-600 bg-transparent border-b border-gray-300 focus:border-indigo-500 outline-none"
                    placeholder="your.email@example.com"
                  />
                </div>
              ) : (
                <div>
                  <h2 className="text-2xl font-bold text-gray-900">{currentRider?.name}</h2>
                  <p className="text-lg text-gray-600 flex items-center mt-2">
                    <Mail className="w-5 h-5 mr-2" />
                    {currentRider?.email}
                  </p>
                </div>
              )}
            </div>
            <div className="text-right">
              <div className="inline-flex items-center px-4 py-2 bg-emerald-100 rounded-full">
                <Award className="w-5 h-5 text-emerald-600 mr-2" />
                <span className="font-semibold text-emerald-800">
                  {formData.experience_level}
                </span>
              </div>
            </div>
          </div>

          {/* Stats Grid */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {statsData.map((stat, index) => (
              <div key={index} className="text-center p-4 bg-gray-50 rounded-xl">
                <stat.icon className={`w-8 h-8 mx-auto mb-2 ${stat.color}`} />
                <div className="text-2xl font-bold text-gray-900">{stat.value}</div>
                <div className="text-sm text-gray-600">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Riding Preferences */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Target className="w-6 h-6 text-indigo-600 mr-3" />
              Riding Preferences
            </h3>
            
            <div className="space-y-6">
              {/* Experience Level */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Experience Level
                </label>
                {isEditing ? (
                  <select
                    value={formData.experience_level}
                    onChange={(e) => setFormData({ ...formData, experience_level: e.target.value })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                  >
                    {experienceLevels.map(level => (
                      <option key={level} value={level}>{level}</option>
                    ))}
                  </select>
                ) : (
                  <p className="text-gray-900 font-medium">{formData.experience_level}</p>
                )}
              </div>

              {/* Preferred Disciplines */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Preferred Disciplines
                </label>
                <div className="grid grid-cols-2 gap-3">
                  {disciplineOptions.map((discipline) => (
                    <button
                      key={discipline.id}
                      onClick={() => isEditing && handleDisciplineToggle(discipline.id)}
                      disabled={!isEditing}
                      className={`p-3 rounded-lg border transition-colors text-left ${
                        formData.preferred_disciplines.includes(discipline.id)
                          ? 'bg-indigo-50 border-indigo-500 text-indigo-700'
                          : 'bg-gray-50 border-gray-300 text-gray-700'
                      } ${isEditing ? 'hover:bg-indigo-100 cursor-pointer' : 'cursor-default'}`}
                    >
                      <div className="text-lg mb-1">{discipline.icon}</div>
                      <div className="font-medium text-sm">{discipline.label}</div>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* App Settings */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Settings className="w-6 h-6 text-gray-600 mr-3" />
              App Settings
            </h3>
            
            <div className="space-y-6">
              {/* Notifications */}
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <Bell className="w-5 h-5 text-gray-600" />
                  <div>
                    <p className="font-medium text-gray-900">Notifications</p>
                    <p className="text-sm text-gray-600">Session reminders and tips</p>
                  </div>
                </div>
                <button
                  onClick={() => setPreferences({
                    ...preferences,
                    notifications: !preferences.notifications
                  })}
                  className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
                    preferences.notifications ? 'bg-indigo-600' : 'bg-gray-300'
                  }`}
                >
                  <span
                    className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                      preferences.notifications ? 'translate-x-6' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>

              {/* Emergency Contact */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Emergency Contact
                </label>
                <input
                  type="tel"
                  value={preferences.emergencyContact}
                  onChange={(e) => setPreferences({
                    ...preferences,
                    emergencyContact: e.target.value
                  })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                  placeholder="+1 (555) 123-4567"
                />
              </div>

              {/* Coaching Intensity */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  AI Coaching Intensity
                </label>
                <div className="grid grid-cols-3 gap-2">
                  {['light', 'moderate', 'intensive'].map((level) => (
                    <button
                      key={level}
                      onClick={() => setPreferences({
                        ...preferences,
                        coachingIntensity: level
                      })}
                      className={`py-2 px-3 rounded-lg text-sm font-medium transition-colors ${
                        preferences.coachingIntensity === level
                          ? 'bg-indigo-500 text-white'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {level.charAt(0).toUpperCase() + level.slice(1)}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        {isEditing && (
          <div className="flex justify-center space-x-4">
            <button
              onClick={() => {
                setIsEditing(false);
                setFormData({
                  name: currentRider?.name || '',
                  email: currentRider?.email || '',
                  experience_level: currentRider?.experience_level || 'Intermediate',
                  preferred_disciplines: currentRider?.preferred_disciplines || []
                });
              }}
              className="px-6 py-3 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-semibold transition-colors"
            >
              Cancel
            </button>
            <button
              onClick={handleSave}
              className="px-6 py-3 bg-emerald-500 hover:bg-emerald-600 text-white rounded-lg font-semibold transition-colors flex items-center space-x-2"
            >
              <Save className="w-5 h-5" />
              <span>Save Changes</span>
            </button>
          </div>
        )}

        {/* Achievement Section */}
        <div className="bg-gradient-to-r from-purple-500 to-indigo-600 rounded-2xl p-8 text-white">
          <h3 className="text-xl font-bold mb-4">Your Equestrian Journey</h3>
          <p className="text-purple-100 mb-6">
            You've completed 24 sessions and made significant progress in managing riding anxiety. 
            Your dedication to mental training is showing real results!
          </p>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl mb-2">🏆</div>
              <div className="text-sm text-purple-200">Anxiety Warrior</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🎯</div>
              <div className="text-sm text-purple-200">Confidence Builder</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">💪</div>
              <div className="text-sm text-purple-200">Mental Strength</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🤝</div>
              <div className="text-sm text-purple-200">Horse Connection</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RiderProfile;