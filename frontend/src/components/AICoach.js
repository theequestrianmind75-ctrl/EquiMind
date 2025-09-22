import React, { useState, useEffect } from 'react';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  Brain, 
  MessageSquare, 
  Send, 
  Loader2,
  Sparkles,
  Target,
  Heart,
  TrendingUp,
  AlertCircle
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const AICoach = ({ currentRider, sessionData, emotionalState, onCoachingReceived }) => {
  const [messages, setMessages] = useState([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [showCoach, setShowCoach] = useState(false);

  useEffect(() => {
    // Initialize with welcome message and personalized insights
    if (currentRider && !messages.length) {
      initializeCoaching();
    }
  }, [currentRider]);

  const initializeCoaching = async () => {
    try {
      setIsLoading(true);
      
      const contextData = {
        rider_name: currentRider.name,
        experience_level: currentRider.experience_level,
        preferred_disciplines: currentRider.preferred_disciplines,
        current_emotional_state: emotionalState,
        session_type: sessionData?.sessionType || 'general',
        ride_type: sessionData?.rideType || 'general_training'
      };

      const response = await axios.post(`${API}/ai-coach/initialize`, contextData);
      
      if (response.data.message) {
        const welcomeMessage = {
          id: Date.now(),
          type: 'ai',
          content: response.data.message,
          timestamp: new Date(),
          category: 'welcome'
        };
        setMessages([welcomeMessage]);
        
        if (onCoachingReceived) {
          onCoachingReceived(response.data.message);
        }
      }
    } catch (error) {
      console.error('Error initializing AI coach:', error);
      // Fallback welcome message
      const fallbackMessage = {
        id: Date.now(),
        type: 'ai',
        content: `Hello ${currentRider.name}! I'm your AI equestrian coach. I'm here to provide personalized mental training guidance based on your ${currentRider.experience_level} level experience and your focus on ${currentRider.preferred_disciplines?.join(' and ')}. How are you feeling about today's session?`,
        timestamp: new Date(),
        category: 'welcome'
      };
      setMessages([fallbackMessage]);
    } finally {
      setIsLoading(false);
      setShowCoach(true);
    }
  };

  const sendMessage = async () => {
    if (!inputMessage.trim() || isLoading) return;

    const userMessage = {
      id: Date.now(),
      type: 'user',
      content: inputMessage.trim(),
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage('');
    setIsLoading(true);

    try {
      const contextData = {
        rider_id: currentRider.id,
        message: inputMessage.trim(),
        conversation_history: messages.slice(-5), // Last 5 messages for context
        rider_context: {
          name: currentRider.name,
          experience_level: currentRider.experience_level,
          preferred_disciplines: currentRider.preferred_disciplines,
          current_emotional_state: emotionalState,
          session_type: sessionData?.sessionType,
          ride_type: sessionData?.rideType
        }
      };

      const response = await axios.post(`${API}/ai-coach/chat`, contextData);
      
      if (response.data.message) {
        const aiMessage = {
          id: Date.now() + 1,
          type: 'ai',
          content: response.data.message,
          timestamp: new Date(),
          category: response.data.category || 'general',
          confidence: response.data.confidence || 0.8
        };
        
        setMessages(prev => [...prev, aiMessage]);
        
        if (onCoachingReceived) {
          onCoachingReceived(response.data.message);
        }
      }
    } catch (error) {
      console.error('Error sending message to AI coach:', error);
      toast.error('Unable to get AI response. Please try again.');
      
      // Fallback response
      const fallbackResponse = {
        id: Date.now() + 1,
        type: 'ai',
        content: "I apologize, but I'm having trouble responding right now. Please try again in a moment, or proceed with your preparation steps.",
        timestamp: new Date(),
        category: 'error'
      };
      setMessages(prev => [...prev, fallbackResponse]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  const getMessageIcon = (category) => {
    switch (category) {
      case 'welcome': return <Sparkles className="w-4 h-4 text-purple-500" />;
      case 'encouragement': return <Heart className="w-4 h-4 text-red-500" />;
      case 'technique': return <Target className="w-4 h-4 text-blue-500" />;
      case 'progress': return <TrendingUp className="w-4 h-4 text-green-500" />;
      case 'concern': return <AlertCircle className="w-4 h-4 text-yellow-500" />;
      default: return <Brain className="w-4 h-4 text-indigo-500" />;
    }
  };

  if (!showCoach) {
    return (
      <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8 text-center">
        <div className="animate-pulse space-y-4">
          <Brain className="w-12 h-12 text-indigo-500 mx-auto" />
          <h3 className="text-xl font-bold text-gray-900">Initializing AI Coach...</h3>
          <p className="text-gray-600">Personalizing your coaching experience</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6">
      <div className="flex items-center space-x-3 mb-6">
        <div className="p-2 bg-indigo-100 rounded-lg">
          <Brain className="w-6 h-6 text-indigo-600" />
        </div>
        <div>
          <h3 className="text-xl font-bold text-gray-900">AI Mental Coach</h3>
          <p className="text-sm text-gray-600">Personalized guidance for your equestrian journey</p>
        </div>
      </div>

      {/* Messages */}
      <div className="space-y-4 max-h-96 overflow-y-auto mb-4">
        {messages.map((message) => (
          <div
            key={message.id}
            className={`flex items-start space-x-3 ${
              message.type === 'user' ? 'flex-row-reverse space-x-reverse' : ''
            }`}
          >
            <div className={`p-2 rounded-lg flex-shrink-0 ${
              message.type === 'user'
                ? 'bg-indigo-100'
                : 'bg-gray-100'
            }`}>
              {message.type === 'user' ? (
                <MessageSquare className="w-4 h-4 text-indigo-600" />
              ) : (
                getMessageIcon(message.category)
              )}
            </div>
            
            <div className={`flex-1 ${message.type === 'user' ? 'text-right' : ''}`}>
              <div className={`inline-block p-4 rounded-xl max-w-xs lg:max-w-md ${
                message.type === 'user'
                  ? 'bg-indigo-500 text-white'
                  : 'bg-gray-50 text-gray-900'
              }`}>
                <p className="text-sm">{message.content}</p>
                <p className={`text-xs mt-2 ${
                  message.type === 'user' ? 'text-indigo-200' : 'text-gray-500'
                }`}>
                  {message.timestamp.toLocaleTimeString()}
                </p>
              </div>
            </div>
          </div>
        ))}
        
        {isLoading && (
          <div className="flex items-start space-x-3">
            <div className="p-2 bg-gray-100 rounded-lg">
              <Loader2 className="w-4 h-4 text-gray-600 animate-spin" />
            </div>
            <div className="flex-1">
              <div className="bg-gray-50 text-gray-900 p-4 rounded-xl max-w-xs lg:max-w-md">
                <p className="text-sm">AI coach is thinking...</p>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Input */}
      <div className="flex items-center space-x-3">
        <input
          type="text"
          value={inputMessage}
          onChange={(e) => setInputMessage(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="Ask your AI coach anything..."
          className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
          disabled={isLoading}
        />
        <button
          onClick={sendMessage}
          disabled={!inputMessage.trim() || isLoading}
          className="bg-indigo-500 hover:bg-indigo-600 disabled:bg-gray-400 text-white p-3 rounded-lg transition-colors"
        >
          {isLoading ? (
            <Loader2 className="w-5 h-5 animate-spin" />
          ) : (
            <Send className="w-5 h-5" />
          )}
        </button>
      </div>

      {/* Quick Questions */}
      <div className="mt-4">
        <p className="text-xs font-medium text-gray-700 mb-2">Quick questions:</p>
        <div className="flex flex-wrap gap-2">
          {[
            "How do I manage pre-competition nerves?",
            "Tips for building confidence with my horse?",
            "Breathing exercises for jumping anxiety?"
          ].map((question, index) => (
            <button
              key={index}
              onClick={() => setInputMessage(question)}
              className="text-xs px-3 py-1 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 rounded-full transition-colors"
            >
              {question}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default AICoach;