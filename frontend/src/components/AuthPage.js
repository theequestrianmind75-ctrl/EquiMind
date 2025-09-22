import React, { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  Mail, 
  Lock, 
  User, 
  Eye, 
  EyeOff,
  ArrowLeft,
  Loader2,
  CheckCircle,
  Star
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const AuthPage = ({ onAuthSuccess }) => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const initialMode = searchParams.get('mode') === 'signin' ? 'signin' : 'signup';
  
  const [mode, setMode] = useState(initialMode);
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
    experience_level: 'Intermediate',
    preferred_disciplines: []
  });

  const disciplineOptions = [
    { id: 'show_jumping', label: 'Show Jumping', icon: '🏇' },
    { id: 'dressage', label: 'Dressage', icon: '🎯' },
    { id: 'general_training', label: 'General Training', icon: '🐎' },
    { id: 'competition', label: 'Competition', icon: '🏆' }
  ];

  const experienceLevels = ['Beginner', 'Intermediate', 'Advanced', 'Professional'];

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleDisciplineToggle = (disciplineId) => {
    setFormData(prev => ({
      ...prev,
      preferred_disciplines: prev.preferred_disciplines.includes(disciplineId)
        ? prev.preferred_disciplines.filter(d => d !== disciplineId)
        : [...prev.preferred_disciplines, disciplineId]
    }));
  };

  const validateForm = () => {
    if (mode === 'signup') {
      if (!formData.name.trim()) {
        toast.error('Please enter your name');
        return false;
      }
      if (formData.password !== formData.confirmPassword) {
        toast.error('Passwords do not match');
        return false;
      }
      if (formData.password.length < 6) {
        toast.error('Password must be at least 6 characters');
        return false;
      }
      if (formData.preferred_disciplines.length === 0) {
        toast.error('Please select at least one discipline');
        return false;
      }
    }
    
    if (!formData.email.trim()) {
      toast.error('Please enter your email');
      return false;
    }
    
    if (!formData.password.trim()) {
      toast.error('Please enter your password');
      return false;
    }

    return true;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) return;
    
    setIsLoading(true);
    
    try {
      if (mode === 'signup') {
        // Create new rider profile
        const riderData = {
          name: formData.name.trim(),
          email: formData.email.trim().toLowerCase(),
          experience_level: formData.experience_level,
          preferred_disciplines: formData.preferred_disciplines
        };
        
        const response = await axios.post(`${API}/riders`, riderData);
        
        if (response.data) {
          toast.success('Welcome to The Equestrian Mind! Your mental training journey begins now.');
          
          // Store authentication info (in a real app, you'd use proper JWT tokens)
          localStorage.setItem('equimind_user', JSON.stringify(response.data));
          
          if (onAuthSuccess) {
            onAuthSuccess(response.data);
          }
        }
      } else {
        // Sign in (simplified for demo - in production you'd have proper authentication)
        const demoUser = {
          id: 'user-' + Date.now(),
          name: formData.email.split('@')[0].charAt(0).toUpperCase() + formData.email.split('@')[0].slice(1),
          email: formData.email.trim().toLowerCase(),
          experience_level: 'Intermediate',
          preferred_disciplines: ['show_jumping', 'dressage'],
          created_at: new Date().toISOString()
        };
        
        localStorage.setItem('equimind_user', JSON.stringify(demoUser));
        toast.success('Welcome back to The Equestrian Mind!');
        
        if (onAuthSuccess) {
          onAuthSuccess(demoUser);
        }
      }
    } catch (error) {
      console.error('Authentication error:', error);
      
      if (mode === 'signup') {
        // Even if API fails, create local demo account
        const localUser = {
          id: 'local-user-' + Date.now(),
          name: formData.name.trim(),
          email: formData.email.trim().toLowerCase(),
          experience_level: formData.experience_level,
          preferred_disciplines: formData.preferred_disciplines,
          created_at: new Date().toISOString()
        };
        
        localStorage.setItem('equimind_user', JSON.stringify(localUser));
        toast.success('Welcome to The Equestrian Mind! Your mental training journey begins now.');
        
        if (onAuthSuccess) {
          onAuthSuccess(localUser);
        }
      } else {
        toast.error('Sign in failed. Please try again.');
      }
    } finally {
      setIsLoading(false);
    }
  };

  const heroImage = 'https://images.unsplash.com/photo-1594768816441-1dd241ffaa67?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwyfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85';

  return (
    <div className="min-h-screen bg-brand-light flex">
      
      {/* Left Side - Image & Branding */}
      <div className="hidden lg:flex lg:w-1/2 relative overflow-hidden">
        <img 
          src={heroImage} 
          alt="Equestrian" 
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-br from-blue-900/85 to-indigo-900/65"></div>
        
        <div className="absolute inset-0 flex flex-col justify-center items-center text-white p-12">
          <div className="max-w-md text-center">
            <div className="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mx-auto mb-8">
              <img 
                src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                alt="EquiMind" 
                className="w-10 h-10 object-contain filter brightness-0 invert"
              />
            </div>
            
            <h1 className="text-4xl font-bold mb-6">
              Transform Your Mental Performance
            </h1>
            
            <p className="text-blue-100 text-lg mb-8 leading-relaxed">
              Join riders worldwide who have overcome anxiety and achieved peak performance 
              through evidence-based mental training from a Licensed Clinical Professional.
            </p>
            
            <div className="space-y-4">
              {[
                'Reduce riding anxiety with proven techniques',
                'Build unshakeable confidence in the saddle',
                'Strengthen your horse-rider connection',
                'Access professional support when needed'
              ].map((benefit, index) => (
                <div key={index} className="flex items-center space-x-3">
                  <CheckCircle className="w-5 h-5 text-blue-300 flex-shrink-0" />
                  <span className="text-blue-100">{benefit}</span>
                </div>
              ))}
            </div>
            
            <div className="mt-8 flex items-center justify-center space-x-1">
              {[...Array(5)].map((_, i) => (
                <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
              ))}
              <span className="ml-2 text-blue-200">Licensed Clinical Professional • 50+ Years Experience</span>
            </div>
          </div>
        </div>
      </div>

      {/* Right Side - Auth Form */}
      <div className="w-full lg:w-1/2 flex flex-col justify-center p-8 lg:p-16">
        
        {/* Header */}
        <div className="max-w-md mx-auto w-full">
          <div className="flex items-center justify-between mb-8">
            <button
              onClick={() => navigate('/')}
              className="flex items-center space-x-2 text-gray-600 hover:text-gray-900 transition-colors"
            >
              <ArrowLeft className="w-5 h-5" />
              <span>Back to Home</span>
            </button>
            
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 rounded-lg flex items-center justify-center">
                <img 
                  src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                  alt="EquiMind" 
                  className="w-6 h-6 object-contain"
                />
              </div>
              <span className="text-xl font-bold text-brand-primary">EquiMind</span>
            </div>
          </div>

          {/* Mode Toggle */}
          <div className="text-center mb-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              {mode === 'signup' ? 'Join The Equestrian Mind' : 'Welcome Back'}
            </h2>
            <p className="text-gray-600 mb-6">
              {mode === 'signup' 
                ? 'Begin your journey to confident, anxiety-free riding with professional guidance'
                : 'Continue your mental performance training journey'
              }
            </p>
            
            <div className="flex bg-gray-100 rounded-lg p-1">
              <button
                onClick={() => setMode('signin')}
                className={`flex-1 py-2 px-4 rounded-md font-medium transition-all ${
                  mode === 'signin'
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                Sign In
              </button>
              <button
                onClick={() => setMode('signup')}
                className={`flex-1 py-2 px-4 rounded-md font-medium transition-all ${
                  mode === 'signup'
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                Sign Up
              </button>
            </div>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-6">
            
            {/* Name (Sign Up Only) */}
            {mode === 'signup' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Full Name
                </label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleInputChange}
                    className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-brand-primary focus:border-brand-primary transition-colors"
                    placeholder="Enter your full name"
                    required
                  />
                </div>
              </div>
            )}

            {/* Email */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Email Address
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleInputChange}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-brand-primary focus:border-brand-primary transition-colors"
                  placeholder="Enter your email"
                  required
                />
              </div>
            </div>

            {/* Password */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Password
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type={showPassword ? 'text' : 'password'}
                  name="password"
                  value={formData.password}
                  onChange={handleInputChange}
                  className="w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-brand-primary focus:border-brand-primary transition-colors"
                  placeholder="Enter your password"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                </button>
              </div>
            </div>

            {/* Confirm Password (Sign Up Only) */}
            {mode === 'signup' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Confirm Password
                </label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <input
                    type={showPassword ? 'text' : 'password'}
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleInputChange}
                    className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-brand-primary focus:border-brand-primary transition-colors"
                    placeholder="Confirm your password"
                    required
                  />
                </div>
              </div>
            )}

            {/* Experience Level (Sign Up Only) */}
            {mode === 'signup' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Experience Level
                </label>
                <select
                  name="experience_level"
                  value={formData.experience_level}
                  onChange={handleInputChange}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-brand-primary focus:border-brand-primary transition-colors"
                  required
                >
                  {experienceLevels.map(level => (
                    <option key={level} value={level}>{level}</option>
                  ))}
                </select>
              </div>
            )}

            {/* Disciplines (Sign Up Only) */}
            {mode === 'signup' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Preferred Disciplines (Select all that apply)
                </label>
                <div className="grid grid-cols-2 gap-3">
                  {disciplineOptions.map((discipline) => (
                    <button
                      key={discipline.id}
                      type="button"
                      onClick={() => handleDisciplineToggle(discipline.id)}
                      className={`p-3 rounded-lg border transition-all text-left ${
                        formData.preferred_disciplines.includes(discipline.id)
                          ? 'bg-blue-50 border-brand-primary text-brand-primary'
                          : 'bg-gray-50 border-gray-300 text-gray-700 hover:bg-gray-100'
                      }`}
                    >
                      <div className="text-lg mb-1">{discipline.icon}</div>
                      <div className="font-medium text-sm">{discipline.label}</div>
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Submit Button */}
            <button
              type="submit"
              disabled={isLoading}
              className="w-full professional-button text-white py-3 px-4 rounded-lg font-semibold transition-all flex items-center justify-center space-x-2 disabled:opacity-50"
            >
              {isLoading ? (
                <>
                  <Loader2 className="w-5 h-5 animate-spin" />
                  <span>{mode === 'signup' ? 'Creating Account...' : 'Signing In...'}</span>
                </>
              ) : (
                <span>{mode === 'signup' ? 'Begin Mental Training' : 'Sign In'}</span>
              )}
            </button>

            {/* Additional Options */}
            <div className="text-center">
              <p className="text-gray-600">
                {mode === 'signup' ? 'Already have an account?' : "Don't have an account?"}{' '}
                <button
                  type="button"
                  onClick={() => setMode(mode === 'signup' ? 'signin' : 'signup')}
                  className="text-brand-primary hover:text-blue-700 font-semibold transition-colors"
                >
                  {mode === 'signup' ? 'Sign In' : 'Sign Up'}
                </button>
              </p>
            </div>

            {mode === 'signup' && (
              <div className="text-center">
                <p className="text-xs text-gray-500 leading-relaxed">
                  By creating an account, you agree to our{' '}
                  <a href="#" className="text-brand-primary hover:underline">Terms of Service</a>{' '}
                  and{' '}
                  <a href="#" className="text-brand-primary hover:underline">Privacy Policy</a>
                </p>
              </div>
            )}
          </form>
        </div>
      </div>
    </div>
  );
};

export default AuthPage;