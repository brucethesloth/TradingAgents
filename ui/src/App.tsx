import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { ProtectedRoute } from './components/Auth/ProtectedRoute';
import { Login } from './components/Auth/Login';
import { DashboardLayout } from './components/Layout/DashboardLayout';
import { Dashboard } from './pages/Dashboard';

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route
            path="/*"
            element={
              <ProtectedRoute>
                <DashboardLayout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Dashboard />} />
            <Route path="analytics" element={<div className="p-6"><h1 className="text-2xl">Analytics</h1></div>} />
            <Route path="users" element={<div className="p-6"><h1 className="text-2xl">Users</h1></div>} />
            <Route path="settings" element={<div className="p-6"><h1 className="text-2xl">Settings</h1></div>} />
          </Route>
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;