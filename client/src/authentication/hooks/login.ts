import { useState } from "react";
import loginService from "../authService/loginService";
import { type LoginRequest, type LoginResponse } from "../models/auth";




export default function useLogin() {
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>("");
  const [success, setSuccess] = useState<string>("");

  const login = async (formData: LoginRequest): Promise<LoginResponse> => {
    setLoading(true);
    setError("");
    setSuccess("");

    try {

      const res = await loginService.login(formData);
      const token = res.data.token;
      setSuccess("Registration Successfully");
      console.log(res.data);

      localStorage.setItem("token", token)
      return res.data;




    } catch (err: any) {
      setError(err.response?.data?.error || "Something went wrong");
      throw err;
    } finally {
      setLoading(false);
    }
  };

  return { login, success, error, loading };

}


