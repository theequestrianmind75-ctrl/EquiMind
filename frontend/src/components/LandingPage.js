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
      title: 'Evidence-Based Mental Training',
      description: 'Scientifically-proven techniques to reduce anxiety and build confidence in the saddle.',
      color: 'text-purple-600'
    },
    {
      icon: Heart,
      title: 'Horse-Rider Connection',
      description: 'Tools to strengthen your bond and communication with your equine partner.',
      color: 'text-red-600'
    },
    {
      icon: Shield,
      title: 'Emergency Anxiety Support',
      description: 'Immediate access to calming techniques when you need them most.',
      color: 'text-emerald-600'
    },
    {
      icon: Target,
      title: 'Personalized AI Coaching',
      description: 'Custom guidance tailored to your discipline, experience level, and goals.',
      color: 'text-blue-600'
    }
  ];

  const testimonials = [
    {
      name: 'Emma Rodriguez',
      role: 'Show Jumping Competitor',
      quote: 'EquiMind transformed my competition anxiety into confidence. I\'ve never felt so prepared mentally.',
      rating: 5
    },
    {
      name: 'Dr. James Mitchell',
      role: 'Dressage Professional',
      quote: 'The evidence-based approach really works. My students see improvement in just weeks.',
      rating: 5
    },
    {
      name: 'Sarah Chen',
      role: 'Amateur Rider',
      quote: 'Finally, a tool that understands the unique mental challenges of equestrian sports.',
      rating: 5
    }
  ];

  const stats = [
    { number: '10,000+', label: 'Riders Helped', icon: Users },
    { number: '95%', label: 'Anxiety Reduction', icon: TrendingUp },
    { number: '4.9/5', label: 'User Rating', icon: Star },
    { number: '500+', label: 'Success Stories', icon: Award }
  ];

  const handleGetStarted = () => {
    if (onGetStarted) {
      onGetStarted();
    } else {
      navigate('/auth');
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-emerald-50 via-teal-50 to-cyan-100">
      
      {/* Navigation */}
      <nav className="bg-white/80 backdrop-blur-sm border-b border-emerald-100 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl flex items-center justify-center">
                <Heart className="w-6 h-6 text-white" />
              </div>
              <h1 className="text-2xl font-bold gradient-text">EquiMind</h1>
            </div>
            
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="text-gray-700 hover:text-emerald-600 transition-colors">Features</a>
              <a href="#testimonials" className="text-gray-700 hover:text-emerald-600 transition-colors">Success Stories</a>
              <a href="#pricing" className="text-gray-700 hover:text-emerald-600 transition-colors">Pricing</a>
            </div>
            
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/auth?mode=signin')}
                className="text-emerald-600 hover:text-emerald-700 font-semibold transition-colors"
              >
                Sign In
              </button>
              <button
                onClick={handleGetStarted}
                className="bg-emerald-500 hover:bg-emerald-600 text-white px-6 py-2 rounded-lg font-semibold transition-colors"
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
            src={heroImages[0]} 
            alt="Equestrian" 
            className="w-full h-full object-cover opacity-20"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-emerald-900/60 to-teal-900/40"></div>
        </div>
        
        <div className="relative max-w-7xl mx-auto px-4 text-center">
          <div className="max-w-4xl mx-auto">
            <h1 className="text-5xl md:text-7xl font-bold text-white mb-8 leading-tight">
              Master Your Mind,
              <br />
              <span className="gradient-text">Excel in the Saddle</span>
            </h1>
            
            <p className="text-xl md:text-2xl text-emerald-100 mb-12 max-w-3xl mx-auto leading-relaxed">
              Evidence-based mental training for equestrians. Overcome anxiety, build confidence, 
              and achieve peak performance with personalized AI coaching.
            </p>
            
            <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6">
              <button
                onClick={handleGetStarted}
                className="bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white px-8 py-4 rounded-xl font-bold text-lg transition-all hover-lift flex items-center space-x-3"
              >
                <span>Start Your Journey</span>
                <ArrowRight className="w-6 h-6" />
              </button>
              
              <button
                onClick={() => setIsModalOpen(true)}
                className="bg-white/20 backdrop-blur-sm border border-white/30 text-white px-8 py-4 rounded-xl font-semibold hover:bg-white/30 transition-all flex items-center space-x-3"
              >
                <Play className="w-5 h-5" />
                <span>Watch Demo</span>
              </button>
            </div>
            
            <div className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-8">
              {stats.map((stat, index) => (
                <div key={index} className="text-center">
                  <div className="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-lg flex items-center justify-center mx-auto mb-3">
                    <stat.icon className="w-6 h-6 text-white" />
                  </div>
                  <div className="text-2xl font-bold text-white">{stat.number}</div>
                  <div className="text-emerald-200 text-sm">{stat.label}</div>
                </div>
              ))}
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
              Combining cutting-edge psychology with equestrian expertise to deliver 
              results that transform both rider and horse.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="bg-white/80 backdrop-blur-sm rounded-2xl p-8 hover-lift group">
                <div className={`w-12 h-12 rounded-xl bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform`}>
                  <feature.icon className={`w-7 h-7 ${feature.color}`} />
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-4">{feature.title}</h3>
                <p className="text-gray-600 leading-relaxed">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section className="py-20 bg-white/50">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Simple. Effective. Proven.
            </h2>
            <p className="text-xl text-gray-600">
              Three steps to mental mastery in equestrian sports
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                step: '01',
                title: 'Assess Your Mental State',
                description: 'Complete our comprehensive evaluation to understand your unique anxiety patterns and confidence levels.',
                image: heroImages[1]
              },
              {
                step: '02',
                title: 'Train With AI Guidance',
                description: 'Follow personalized mental training protocols designed specifically for your discipline and experience level.',
                image: heroImages[2]
              },
              {
                step: '03',
                title: 'Perform With Confidence',
                description: 'Apply your new mental skills in training and competition, with emergency support always available.',
                image: heroImages[0]
              }
            ].map((item, index) => (
              <div key={index} className="text-center group">
                <div className="relative mb-8">
                  <img 
                    src={item.image} 
                    alt={item.title}
                    className="w-full h-64 object-cover rounded-2xl group-hover:scale-105 transition-transform duration-300"
                  />
                  <div className="absolute -top-4 -left-4 w-12 h-12 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-full flex items-center justify-center text-white font-bold text-lg">
                    {item.step}
                  </div>
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-4">{item.title}</h3>
                <p className="text-gray-600">{item.description}</p>
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
              <div key={index} className="bg-white/80 backdrop-blur-sm rounded-2xl p-8 hover-lift">
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
      <section className="py-20 bg-gradient-to-r from-emerald-500 to-teal-600">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-4xl md:text-5xl font-bold text-white mb-8">
            Ready to Transform Your Riding?
          </h2>
          <p className="text-xl text-emerald-100 mb-12">
            Join thousands of riders who have overcome anxiety and achieved their equestrian dreams.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6">
            <button
              onClick={handleGetStarted}
              className="bg-white text-emerald-600 hover:bg-emerald-50 px-8 py-4 rounded-xl font-bold text-lg transition-all hover-lift flex items-center space-x-3"
            >
              <span>Start Free Trial</span>
              <ArrowRight className="w-6 h-6" />
            </button>
            
            <p className="text-emerald-100 text-sm">
              No credit card required • 14-day free trial
            </p>
          </div>
          
          <div className="mt-12 flex items-center justify-center space-x-8 text-emerald-200">
            <div className="flex items-center space-x-2">
              <CheckCircle className="w-5 h-5" />
              <span>Cancel anytime</span>
            </div>
            <div className="flex items-center space-x-2">
              <CheckCircle className="w-5 h-5" />
              <span>Expert support</span>
            </div>
            <div className="flex items-center space-x-2">
              <CheckCircle className="w-5 h-5" />
              <span>Proven results</span>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-3 mb-6">
                <div className="w-10 h-10 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl flex items-center justify-center">
                  <Heart className="w-6 h-6 text-white" />
                </div>
                <h3 className="text-2xl font-bold">EquiMind</h3>
              </div>
              <p className="text-gray-400">
                Empowering equestrians through evidence-based mental training.
              </p>
            </div>
            
            <div>
              <h4 className="font-bold mb-4">Product</h4>
              <div className="space-y-2 text-gray-400">
                <div>Features</div>
                <div>Pricing</div>
                <div>Success Stories</div>
                <div>FAQ</div>
              </div>
            </div>
            
            <div>
              <h4 className="font-bold mb-4">Support</h4>
              <div className="space-y-2 text-gray-400">
                <div>Help Center</div>
                <div>Contact</div>
                <div>Emergency Support</div>
                <div>Community</div>
              </div>
            </div>
            
            <div>
              <h4 className="font-bold mb-4">Legal</h4>
              <div className="space-y-2 text-gray-400">
                <div>Privacy Policy</div>
                <div>Terms of Service</div>
                <div>Cookie Policy</div>
              </div>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>&copy; 2025 EquiMind. All rights reserved. Built with passion for equestrians.</p>
          </div>
        </div>
      </footer>

      {/* Demo Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl p-8 max-w-2xl w-full">
            <div className="text-center">
              <Play className="w-16 h-16 text-emerald-600 mx-auto mb-4" />
              <h3 className="text-2xl font-bold text-gray-900 mb-4">Coming Soon</h3>
              <p className="text-gray-600 mb-6">
                Our demo video is currently in production. Get started now to experience EquiMind firsthand!
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
                  className="px-6 py-3 bg-emerald-500 hover:bg-emerald-600 text-white rounded-lg transition-colors"
                >
                  Get Started Instead
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