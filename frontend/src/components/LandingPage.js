import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import { 
  ArrowRight, 
  Shield, 
  Brain, 
  Heart, 
  Target,
  Star,
  CheckCircle,
  Play,
  Users,
  Award,
  TrendingUp
} from 'lucide-react';

const LandingPage = ({ onGetStarted }) => {
  const navigate = useNavigate();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const heroImages = [
    'https://images.unsplash.com/photo-1695133994223-02698c56f100?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwxfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85',
    'https://images.unsplash.com/photo-1594768816441-1dd241ffaa67?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NDk1Nzh8MHwxfHNlYXJjaHwyfHxlcXVlc3RyaWFufGVufDB8fHx8MTc1ODUwMTU5NXww&ixlib=rb-4.1.0&q=85',
    'https://images.unsplash.com/photo-1512934772407-b292436089ee?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHwxfHxzaG93JTIwanVtcGluZ3xlbnwwfHx8fDE3NTg1MDE2MDB8MA&ixlib=rb-4.1.0&q=85'
  ];

  const features = [
    {
      icon: Brain,
      title: 'Real Time Coaching',
      description: 'Immediate guidance and support during your riding sessions with AI-powered insights.',
      color: 'text-blue-600'
    },
    {
      icon: Heart,
      title: 'Mental Health Solutions',
      description: 'Evidence-based strategies you can use now for managing performance anxiety and building confidence.',
      color: 'text-blue-700'
    },
    {
      icon: Target,
      title: 'Horse-Rider Connection',
      description: 'Strengthen the trust, understanding, and communication that creates an unbreakable bond with your horse.',
      color: 'text-blue-800'
    }
  ];

  const testimonials = [
    {
      name: 'Sarah M.',
      role: 'Show Jumping Competitor',
      quote: 'The mental skills training transformed my competition anxiety into confidence. I finally feel prepared mentally for every ride.',
      rating: 5
    },
    {
      name: 'Dr. James R.',
      role: 'Dressage Professional',
      quote: 'The evidence-based approach really works. My students see improvement in just weeks. Highly recommend this program.',
      rating: 5
    },
    {
      name: 'Emma T.',
      role: 'Amateur Rider',
      quote: 'Finally, a program that understands the unique mental challenges of equestrian sports. Life-changing experience.',
      rating: 5
    }
  ];

  const stats = [
    { number: '50+', label: 'Years Experience', icon: Users },
    { number: '95%', label: 'Anxiety Reduction', icon: TrendingUp },
    { number: '4.9/5', label: 'Client Rating', icon: Star },
    { number: 'LPC, MBA', label: 'Licensed Credentials', icon: Award }
  ];

  const handleGetStarted = () => {
    if (onGetStarted) {
      onGetStarted();
    } else {
      navigate('/auth');
    }
  };

  return (
    <div className="min-h-screen bg-brand-light">
      
      {/* Navigation */}
      <nav className="bg-white/90 backdrop-blur-sm border-b border-blue-100 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 rounded-xl flex items-center justify-center">
                <img 
                  src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                  alt="EquiMind" 
                  className="w-10 h-10 object-contain"
                />
              </div>
              <h1 className="text-2xl font-bold text-brand-primary">EquiMind</h1>
            </div>
            
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="text-gray-700 hover:text-brand-primary transition-colors">Features</a>
              <a href="#testimonials" className="text-gray-700 hover:text-brand-primary transition-colors">Success Stories</a>
              <a href="#coaching" className="text-gray-700 hover:text-brand-primary transition-colors">Coaching</a>
            </div>
            
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/auth?mode=signin')}
                className="text-brand-primary hover:text-blue-700 font-semibold transition-colors"
              >
                Sign In
              </button>
              <button
                onClick={handleGetStarted}
                className="professional-button text-white px-6 py-2 rounded-lg font-semibold"
              >
                Get Started
              </button>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative overflow-hidden py-20">
        <div className="absolute inset-0">
          <img 
            src="https://customer-assets.emergentagent.com/job_equihero/artifacts/jkqy4a6h_jumping%20knees.jpg" 
            alt="Show Jumping" 
            className="w-full h-full object-cover opacity-30"
            style={{ objectPosition: '30% center' }}
          />
          <div className="absolute inset-0 bg-gradient-to-r from-blue-900/70 to-indigo-900/50"></div>
          {/* Hide watermark in bottom right corner */}
          <div className="absolute bottom-0 right-0 w-32 h-16 bg-gradient-to-l from-blue-900/90 to-transparent"></div>
        </div>
        
        <div className="relative max-w-7xl mx-auto px-4 text-center">
          <div className="max-w-4xl mx-auto">
            <h1 className="text-5xl md:text-7xl font-bold text-white mb-16 leading-tight">
              Strengthen Your Mindset
              <br />
              <br />
              <span className="gradient-text bg-gradient-to-r from-blue-200 to-white bg-clip-text text-transparent">Excel in the Saddle</span>
            </h1>
            
            <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6 mb-16">
              <button
                onClick={handleGetStarted}
                className="professional-button text-white px-8 py-4 rounded-xl font-bold text-lg hover-lift flex items-center space-x-3"
              >
                <span>Start Your Journey</span>
                <ArrowRight className="w-6 h-6" />
              </button>
              
              <button
                onClick={() => setIsModalOpen(true)}
                className="professional-button text-white px-8 py-4 rounded-xl font-semibold hover-lift flex items-center space-x-3"
              >
                <span>Learn More</span>
                <ArrowRight className="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Why EquiMind Works
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Combining clinical expertise with deep equestrian knowledge to deliver 
              results that transform both rider performance and horse-rider relationships.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="professional-card rounded-2xl p-8 hover-lift group">
                <div className="w-16 h-16 rounded-xl bg-white flex items-center justify-center mb-6 group-hover:scale-110 transition-transform mx-auto">
                  <img 
                    src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                    alt="EquiMind" 
                    className="w-12 h-12 object-contain"
                  />
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-4 text-center">{feature.title}</h3>
                <p className="text-gray-600 leading-relaxed text-center">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials */}
      <section id="testimonials" className="py-20">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Trusted by Riders Worldwide
            </h2>
            <p className="text-xl text-gray-600">
              Real stories from riders who transformed their performance
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {testimonials.map((testimonial, index) => (
              <div key={index} className="professional-card rounded-2xl p-8 hover-lift">
                <div className="flex items-center mb-4">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star key={i} className="w-5 h-5 text-yellow-500 fill-current" />
                  ))}
                </div>
                <p className="text-gray-700 italic mb-6">"{testimonial.quote}"</p>
                <div>
                  <div className="font-bold text-gray-900">{testimonial.name}</div>
                  <div className="text-gray-600 text-sm">{testimonial.role}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-brand-dark">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-4xl md:text-5xl font-bold text-white mb-8">
            Ready to Transform Your Riding?
          </h2>
          <p className="text-xl text-blue-100 mb-12">
            Join riders who have overcome anxiety and achieved their equestrian dreams through evidence-based mental training.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6">
            <button
              onClick={handleGetStarted}
              className="bg-white text-brand-primary hover:bg-blue-50 px-8 py-4 rounded-xl font-bold text-lg transition-all hover-lift flex items-center space-x-3"
            >
              <span>Start Your Mental Training</span>
              <ArrowRight className="w-6 h-6" />
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-3 mb-6">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center">
                  <img 
                    src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                    alt="EquiMind" 
                    className="w-8 h-8 object-contain filter brightness-0 invert"
                  />
                </div>
                <h3 className="text-2xl font-bold">EquiMind</h3>
              </div>
              <p className="text-gray-400">
                Empowering equestrians through evidence-based mental performance coaching.
              </p>
            </div>
            
            <div>
              <h4 className="font-bold mb-4">Services</h4>
              <div className="space-y-2 text-gray-400">
                <div>Performance Coaching</div>
                <div>Mental Training</div>
                <div>Anxiety Management</div>
                <div>Competition Prep</div>
              </div>
            </div>
            
            <div>
              <h4 className="font-bold mb-4">Support</h4>
              <div className="space-y-2 text-gray-400">
                <div>Help Center</div>
                <div>Contact</div>
                <div>Emergency Support</div>
                <div>Resources</div>
              </div>
            </div>
            
            <div>
              <h4 className="font-bold mb-4">Legal</h4>
              <div className="space-y-2 text-gray-400">
                <div>Privacy Policy</div>
                <div>Terms of Service</div>
                <div>Professional Credentials</div>
              </div>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>&copy; 2025 EquiMind. All rights reserved. Licensed Clinical Professional.</p>
          </div>
        </div>
      </footer>

      {/* Info Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl p-8 max-w-2xl w-full">
            <div className="text-center">
              <img 
                src="https://customer-assets.emergentagent.com/job_equihero/artifacts/e0yoq28q_horse%20head%20.png" 
                alt="EquiMind" 
                className="w-16 h-16 object-contain mx-auto mb-4"
              />
              <h3 className="text-2xl font-bold text-gray-900 mb-4">About EquiMind</h3>
              <p className="text-gray-600 mb-6">
                Evidence-based mental performance coaching designed specifically for equestrians. 
                Led by Kristi Seymour, a Licensed Clinical Professional with over 50 years of equestrian experience, 
                our approach combines clinical expertise with deep understanding of horse-rider relationships.
              </p>
              <div className="flex space-x-4 justify-center">
                <button
                  onClick={() => setIsModalOpen(false)}
                  className="px-6 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  Close
                </button>
                <button
                  onClick={() => {
                    setIsModalOpen(false);
                    handleGetStarted();
                  }}
                  className="professional-button text-white px-6 py-3 rounded-lg"
                >
                  Get Started
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default LandingPage;