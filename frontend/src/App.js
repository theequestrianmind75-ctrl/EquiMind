import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Toaster } from 'sonner';
import './App.css';

// Components
import LandingPage from './components/LandingPage';
import AuthPage from './components/AuthPage';
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
    // Check for existing authentication
    const checkAuthStatus = () => {
      try {
        const storedUser = localStorage.getItem('equimind_user');
        if (storedUser) {
          const userData = JSON.parse(storedUser);
          setCurrentRider(userData);
        }
      } catch (error) {
        console.error('Error loading user data:', error);
        localStorage.removeItem('equimind_user');
      } finally {
        setIsLoading(false);
      }
    };

    checkAuthStatus();
  }, []);

  const handleAuthSuccess = (userData) => {
    setCurrentRider(userData);
    setIsLoading(false);
  };

  const handleLogout = () => {
    localStorage.removeItem('equimind_user');
    setCurrentRider(null);
  };

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
          {/* Public Routes */}
          <Route 
            path="/" 
            element={
              currentRider ? 
                <Navigate to="/dashboard" replace /> : 
                <LandingPage onGetStarted={() => window.location.href = '/auth'} />
            } 
          />
          
          <Route 
            path="/auth" 
            element={
              currentRider ? 
                <Navigate to="/dashboard" replace /> : 
                <AuthPage onAuthSuccess={handleAuthSuccess} />
            } 
          />

          {/* Protected Routes */}
          {currentRider ? (
            <>
              <Route 
                path="/dashboard" 
                element={<Dashboard currentRider={currentRider} onLogout={handleLogout} />} 
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
                element={
                  <RiderProfile 
                    currentRider={currentRider} 
                    setCurrentRider={setCurrentRider}
                    onLogout={handleLogout}
                  />
                } 
              />
            </>
          ) : (
            // Redirect unauthenticated users to landing page
            <Route path="*" element={<Navigate to="/" replace />} />
          )}
        </Routes>
      </div>
    </Router>
  );
};

export default App;