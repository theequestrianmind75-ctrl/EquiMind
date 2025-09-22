import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import axios from 'axios';
import { 
  Trophy, 
  Calendar, 
  Target, 
  Brain,
  Clock,
  CheckCircle,
  AlertTriangle,
  Star,
  Zap,
  Heart,
  Play,
  ArrowRight
} from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const CompetitionPrep = ({ currentRider, onStartPreparation }) => {
  const navigate = useNavigate();
  const [selectedCompetition, setSelectedCompetition] = useState(null);
  const [competitionDate, setCompetitionDate] = useState('');
  const [daysUntilCompetition, setDaysUntilCompetition] = useState(0);
  const [preparationPlan, setPreparationPlan] = useState(null);
  const [completedTasks, setCompletedTasks] = useState(new Set());

  const competitionTypes = [
    {
      id: 'local_show',
      name: 'Local Show',
      description: 'Friendly local competition',
      stressLevel: 'Low',
      color: 'bg-green-500',
      icon: '🏆'
    },
    {
      id: 'regional_championship',
      name: 'Regional Championship',
      description: 'Competitive regional event',
      stressLevel: 'Medium',
      color: 'bg-yellow-500',
      icon: '🥇'
    },
    {
      id: 'national_competition',
      name: 'National Competition',
      description: 'High-level national event',
      stressLevel: 'High',
      color: 'bg-red-500',
      icon: '🏆'
    },
    {
      id: 'international_event',
      name: 'International Event',
      description: 'Elite international competition',
      stressLevel: 'Very High',
      color: 'bg-purple-500',
      icon: '🌟'
    }
  ];

  useEffect(() => {
    if (competitionDate) {
      const days = Math.ceil((new Date(competitionDate) - new Date()) / (1000 * 60 * 60 * 24));
      setDaysUntilCompetition(Math.max(0, days));
    }
  }, [competitionDate]);

  useEffect(() => {
    if (selectedCompetition && daysUntilCompetition > 0) {
      generatePreparationPlan();
    }
  }, [selectedCompetition, daysUntilCompetition]);

  const generatePreparationPlan = async () => {
    try {
      const planData = {
        rider_id: currentRider.id,
        competition_type: selectedCompetition.id,
        days_until_competition: daysUntilCompetition,
        rider_experience: currentRider.experience_level,
        preferred_disciplines: currentRider.preferred_disciplines
      };

      const response = await axios.post(`${API}/ai-coach/competition-plan`, planData);
      setPreparationPlan(response.data);
      
    } catch (error) {
      console.error('Error generating preparation plan:', error);
      // Mock preparation plan
      const mockPlan = {
        phases: [
          {
            name: 'Mental Foundation',
            duration: Math.max(1, Math.floor(daysUntilCompetition * 0.4)),
            tasks: [
              'Daily breathing exercises (10 minutes)',
              'Visualization practice (15 minutes)',
              'Positive affirmation sessions',
              'Confidence building exercises'
            ],
            color: 'bg-blue-500'
          },
          {
            name: 'Skill Refinement',
            duration: Math.max(1, Math.floor(daysUntilCompetition * 0.4)),
            tasks: [
              'Focus on weak areas identified in analysis',
              'Perfect competition routine',
              'Horse-rider synchronization work',
              'Pressure simulation exercises'
            ],
            color: 'bg-purple-500'
          },
          {
            name: 'Competition Readiness',
            duration: Math.max(1, Math.floor(daysUntilCompetition * 0.2)),
            tasks: [
              'Competition environment simulation',
              'Peak performance preparation',
              'Final mental rehearsal',
              'Recovery and rest protocols'
            ],
            color: 'bg-emerald-500'
          }
        ],
        dailyRoutine: [
          { time: 'Morning', activity: '10-minute meditation', duration: 10 },
          { time: 'Pre-ride', activity: 'Emotional assessment & breathing', duration: 15 },
          { time: 'Post-ride', activity: 'Performance review & visualization', duration: 20 },
          { time: 'Evening', activity: 'Relaxation & positive imagery', duration: 15 }
        ],
        mentalStrategies: [
          'Focus on process goals rather than outcome goals',
          'Develop competition day routine and stick to it',
          'Practice positive self-talk and error recovery',
          'Use imagery to rehearse successful performances'
        ],
        emergencyStrategies: [
          'Emergency breathing protocol (4-7-8 technique)',
          'Grounding exercises for overwhelming anxiety',
          'Quick confidence boosters and positive anchors',
          'Support team contact protocol'
        ]
      };
      setPreparationPlan(mockPlan);
    }
  };

  const toggleTaskCompletion = (phaseIndex, taskIndex) => {
    const taskId = `${phaseIndex}-${taskIndex}`;
    const newCompleted = new Set(completedTasks);
    
    if (newCompleted.has(taskId)) {
      newCompleted.delete(taskId);
    } else {
      newCompleted.add(taskId);
    }
    
    setCompletedTasks(newCompleted);
    toast.success('Task updated!');
  };

  const startCompetitionPreparation = () => {
    if (!selectedCompetition || !competitionDate) {
      toast.error('Please select competition type and date');
      return;
    }

    const competitionData = {
      competitionType: selectedCompetition,
      competitionDate,
      daysUntilCompetition,
      preparationPlan
    };

    if (onStartPreparation) {
      onStartPreparation(competitionData);
    }

    navigate('/pre-ride', { 
      state: { 
        sessionType: 'competition_prep',
        rideType: 'competition',
        competitionData 
      } 
    });
  };

  const getUrgencyColor = (days) => {
    if (days <= 3) return 'text-red-600 bg-red-50';
    if (days <= 7) return 'text-orange-600 bg-orange-50';
    if (days <= 14) return 'text-yellow-600 bg-yellow-50';
    return 'text-green-600 bg-green-50';
  };

  const getProgressPercentage = () => {
    if (!preparationPlan) return 0;
    const totalTasks = preparationPlan.phases.reduce((sum, phase) => sum + phase.tasks.length, 0);
    return totalTasks > 0 ? (completedTasks.size / totalTasks) * 100 : 0;
  };

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="text-center">
        <h2 className="text-3xl font-bold text-gray-900 mb-4 flex items-center justify-center">
          <Trophy className="w-8 h-8 text-yellow-600 mr-3" />
          Competition Preparation
        </h2>
        <p className="text-gray-600 max-w-2xl mx-auto">
          Specialized mental training program designed to help you perform at your peak when it matters most.
        </p>
      </div>

      {/* Competition Setup */}
      <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
        <h3 className="text-xl font-bold text-gray-900 mb-6">Competition Details</h3>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Competition Type Selection */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-4">
              Competition Type
            </label>
            <div className="space-y-3">
              {competitionTypes.map((comp) => (
                <button
                  key={comp.id}
                  onClick={() => setSelectedCompetition(comp)}
                  className={`w-full p-4 border-2 rounded-xl transition-all text-left ${
                    selectedCompetition?.id === comp.id
                      ? 'border-indigo-500 bg-indigo-50'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <div className="flex items-center space-x-3">
                    <div className="text-2xl">{comp.icon}</div>
                    <div className="flex-1">
                      <h4 className="font-semibold text-gray-900">{comp.name}</h4>
                      <p className="text-sm text-gray-600">{comp.description}</p>
                    </div>
                    <div className={`px-3 py-1 rounded-full text-xs font-medium text-white ${comp.color}`}>
                      {comp.stressLevel}
                    </div>
                  </div>
                </button>
              ))}
            </div>
          </div>

          {/* Date and Timeline */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-4">
              Competition Date
            </label>
            
            <div className="space-y-4">
              <input
                type="date"
                value={competitionDate}
                onChange={(e) => setCompetitionDate(e.target.value)}
                min={new Date().toISOString().split('T')[0]}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              />
              
              {daysUntilCompetition > 0 && (
                <div className={`p-4 rounded-lg ${getUrgencyColor(daysUntilCompetition)}`}>
                  <div className="flex items-center space-x-3">
                    <Clock className="w-6 h-6" />
                    <div>
                      <p className="font-semibold">
                        {daysUntilCompetition} days until competition
                      </p>
                      <p className="text-sm opacity-75">
                        {daysUntilCompetition <= 7 ? 'Final preparation phase' : 'Building phase'}
                      </p>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Preparation Plan */}
      {preparationPlan && (
        <>
          {/* Progress Overview */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-xl font-bold text-gray-900">Preparation Progress</h3>
              <div className="text-2xl font-bold text-indigo-600">
                {Math.round(getProgressPercentage())}%
              </div>
            </div>
            
            <div className="w-full bg-gray-200 rounded-full h-4 mb-4">
              <div 
                className="bg-gradient-to-r from-indigo-500 to-purple-600 h-4 rounded-full transition-all duration-500"
                style={{ width: `${getProgressPercentage()}%` }}
              ></div>
            </div>
            
            <p className="text-gray-600 text-center">
              {completedTasks.size} of {preparationPlan.phases.reduce((sum, phase) => sum + phase.tasks.length, 0)} tasks completed
            </p>
          </div>

          {/* Training Phases */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Target className="w-6 h-6 text-indigo-600 mr-3" />
              Training Phases
            </h3>
            
            <div className="space-y-6">
              {preparationPlan.phases.map((phase, phaseIndex) => (
                <div key={phaseIndex} className="border border-gray-200 rounded-xl p-6">
                  <div className="flex items-center space-x-4 mb-4">
                    <div className={`w-4 h-4 rounded-full ${phase.color}`}></div>
                    <h4 className="text-lg font-semibold text-gray-900">{phase.name}</h4>
                    <span className="text-sm text-gray-600">({phase.duration} days)</span>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    {phase.tasks.map((task, taskIndex) => {
                      const taskId = `${phaseIndex}-${taskIndex}`;
                      const isCompleted = completedTasks.has(taskId);
                      
                      return (
                        <button
                          key={taskIndex}
                          onClick={() => toggleTaskCompletion(phaseIndex, taskIndex)}
                          className={`flex items-center space-x-3 p-3 rounded-lg border transition-all text-left ${
                            isCompleted
                              ? 'bg-green-50 border-green-200 text-green-800'
                              : 'bg-gray-50 border-gray-200 hover:bg-gray-100'
                          }`}
                        >
                          <CheckCircle 
                            className={`w-5 h-5 ${
                              isCompleted ? 'text-green-600' : 'text-gray-400'
                            }`} 
                          />
                          <span className={isCompleted ? 'line-through' : ''}>{task}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Daily Routine */}
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <Clock className="w-6 h-6 text-emerald-600 mr-3" />
              Daily Training Routine
            </h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              {preparationPlan.dailyRoutine.map((routine, index) => (
                <div key={index} className="p-4 bg-emerald-50 rounded-xl">
                  <div className="font-semibold text-emerald-800 mb-2">{routine.time}</div>
                  <div className="text-gray-700 text-sm mb-2">{routine.activity}</div>
                  <div className="text-emerald-600 text-xs">{routine.duration} minutes</div>
                </div>
              ))}
            </div>
          </div>

          {/* Mental Strategies */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
              <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <Brain className="w-6 h-6 text-purple-600 mr-3" />
                Mental Strategies
              </h3>
              
              <div className="space-y-3">
                {preparationPlan.mentalStrategies.map((strategy, index) => (
                  <div key={index} className="flex items-start space-x-3">
                    <Star className="w-5 h-5 text-purple-600 mt-0.5 flex-shrink-0" />
                    <p className="text-gray-700 text-sm">{strategy}</p>
                  </div>
                ))}
              </div>
            </div>

            <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-8">
              <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <AlertTriangle className="w-6 h-6 text-red-600 mr-3" />
                Emergency Protocols
              </h3>
              
              <div className="space-y-3">
                {preparationPlan.emergencyStrategies.map((strategy, index) => (
                  <div key={index} className="flex items-start space-x-3">
                    <Zap className="w-5 h-5 text-red-600 mt-0.5 flex-shrink-0" />
                    <p className="text-gray-700 text-sm">{strategy}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </>
      )}

      {/* Action Button */}
      <div className="text-center">
        <button
          onClick={startCompetitionPreparation}
          disabled={!selectedCompetition || !competitionDate || daysUntilCompetition <= 0}
          className="bg-gradient-to-r from-indigo-500 to-purple-600 hover:from-indigo-600 hover:to-purple-700 disabled:from-gray-400 disabled:to-gray-500 text-white px-8 py-4 rounded-xl font-semibold transition-all flex items-center space-x-3 mx-auto"
        >
          <Play className="w-6 h-6" />
          <span>Start Competition Preparation</span>
          <ArrowRight className="w-5 h-5" />
        </button>
        
        {(!selectedCompetition || !competitionDate) && (
          <p className="text-sm text-gray-600 mt-3">
            Please select competition type and date to begin preparation
          </p>
        )}
      </div>
    </div>
  );
};

export default CompetitionPrep;