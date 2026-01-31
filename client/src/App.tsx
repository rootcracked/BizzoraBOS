
import React from "react";
import { Toaster } from "./components/ui/sonner"; 
import RegisterPage from "./authentication/pages/RegisterPage";
import LoginPage from "./authentication/pages/LoginPage"; 
import {BrowserRouter as Router,Routes,Route } from 'react-router-dom'
import Dashboard from "./business_owner/pages/AdminDashboard";
import AddProductForm from "./business_owner/pages/product/component/ProductForm";
import Layout from "./business_owner/ui_layout/Layout";

function App() {
  return (
    
    <Router> 
      <Routes>

        <Route element={<Layout />}>
                      {/* Default */}
          <Route path="/admin-dashboard" element={<Dashboard />} />
          <Route path="/add-product" element={<AddProductForm/>} />
          
          
          {/* Add more nested pages here */}
        </Route>
        <Route path="/register" element={<RegisterPage/>} />
        <Route path="/login" element={<LoginPage/>} />
        
      </Routes>

    <Toaster 
  position="top-right" 
  theme="light" 
  richColors
  closeButton 
  
/>
    </Router>
  );
}

export default App;



