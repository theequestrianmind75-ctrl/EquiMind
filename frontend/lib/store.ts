import { create } from 'zustand';
import * as SecureStore from 'expo-secure-store';
import api from './api';

interface User {
  id: string;
  email: string;
  name: string;
}

interface AuthState {
  user: User | null;
  token: string | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  logout: () => Promise<void>;
  loadUser: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  token: null,
  loading: true,

  login: async (email: string, password: string) => {
    try {
      const response = await api.post('/auth/login', { email, password });
      const { access_token, user } = response.data;
      await SecureStore.setItemAsync('auth_token', access_token);
      set({ token: access_token, user, loading: false });
    } catch (error: any) {
      throw new Error(error.response?.data?.detail || 'Login failed');
    }
  },

  register: async (email: string, password: string, name: string) => {
    try {
      const response = await api.post('/auth/register', { email, password, name });
      const { access_token, user } = response.data;
      await SecureStore.setItemAsync('auth_token', access_token);
      set({ token: access_token, user, loading: false });
    } catch (error: any) {
      throw new Error(error.response?.data?.detail || 'Registration failed');
    }
  },

  logout: async () => {
    await SecureStore.deleteItemAsync('auth_token');
    set({ token: null, user: null });
  },

  loadUser: async () => {
    try {
      const token = await SecureStore.getItemAsync('auth_token');
      if (token) {
        const response = await api.get('/auth/me');
        set({ user: response.data, token, loading: false });
      } else {
        set({ loading: false });
      }
    } catch (error) {
      await SecureStore.deleteItemAsync('auth_token');
      set({ loading: false });
    }
  },
}));
