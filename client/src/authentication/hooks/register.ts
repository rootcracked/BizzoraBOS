import { useState } from "react";
import apiService from "../authService/apiService";
import { type RegisterRequest, type RegisterResponse } from "../models/auth";




export default function useRegister(){
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>("");
  const [success, setSuccess] = useState<string>("");

  const register = async (formData: RegisterRequest): Promise<RegisterResponse> => { 
    setLoading(true);
    setError("");
    setSuccess("");

    try {
      
      const res = await apiService.register(formData);
      const token = res.data.token;
      setSuccess("Registration Successfully");
      console.log(res.data);

      localStorage.setItem("token", token )
      return res.data;

      
      
      
    }catch(err:any){
      setError(err.response?.data?.error || "Something went wrong");
      throw err;
    }finally{
      setLoading(false);
    }
  };

  return {register, success,error,loading};

}
