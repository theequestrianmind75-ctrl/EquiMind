import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Toaster } from 'sonner';
import './App.css';

// Components
import Dashboard from './components/Dashboard';
import PreRidePreparation from './components/PreRidePreparation';
import DuringRideCoaching from './components/DuringRideCoaching';
import PostRideAnalysis from './components/PostRideAnalysis';
import EmergencySupport from './components/EmergencySupport';
import RiderProfile from './components/RiderProfile';

const App = () => {
  const [currentRider, setCurrentRider] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Initialize demo rider profile
    const initializeRider = () => {
      const demoRider = {
        id: 'demo-rider-001',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@example.com',
        experience_level: 'Advanced',
        preferred_disciplines: ['show_jumping', 'dressage'],
        created_at: new Date().toISOString()
      };
      setCurrentRider(demoRider);
      setIsLoading(false);
    };

    initializeRider();
  }, []);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-emerald-50 to-teal-100 flex items-center justify-center">
        <div className="flex flex-col items-center space-y-4">
          <div className="animate-spin rounded-full h-16 w-16 border-4 border-emerald-500 border-t-transparent"></div>
          <p className="text-emerald-700 font-medium text-lg">Loading EquiMind...</p>
        </div>
      </div>
    );
  }

  return (
    <Router>
      <div className="App">
        <Toaster 
          position="top-right" 
          richColors 
          closeButton
          duration={4000}
        />
        
        <Routes>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route 
            path="/dashboard" 
            element={<Dashboard currentRider={currentRider} />} 
          />
          <Route 
            path="/pre-ride" 
            element={<PreRidePreparation currentRider={currentRider} />} 
          />
          <Route 
            path="/during-ride" 
            element={<DuringRideCoaching currentRider={currentRider} />} 
          />
          <Route 
            path="/post-ride" 
            element={<PostRideAnalysis currentRider={currentRider} />} 
          />
          <Route 
            path="/emergency" 
            element={<EmergencySupport currentRider={currentRider} />} 
          />
          <Route 
            path="/profile" 
            element={<RiderProfile currentRider={currentRider} setCurrentRider={setCurrentRider} />} 
          />
        </Routes>
      </div>
    </Router>
  );
};

export default App;