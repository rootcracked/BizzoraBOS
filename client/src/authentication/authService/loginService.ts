import axios,{ type AxiosResponse } from 'axios'
import { type LoginRequest, type LoginResponse } from '../models/auth';


const axiosClient = axios.create({
  baseURL: "http://localhost:8080",
  headers: {
    "Content-Type": "application/json",
  },
});


const loginService = {
  login: (data: LoginRequest): Promise<AxiosResponse<LoginResponse>> => 
  axiosClient.post("/login", data),
  
  
  
};


export default loginService;

