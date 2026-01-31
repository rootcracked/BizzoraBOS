import axios,{ type AxiosResponse } from 'axios'
import { type RegisterRequest, type RegisterResponse } from '../models/auth';


const axiosClient = axios.create({
  baseURL: "http://localhost:8080",
  headers: {
    "Content-Type": "application/json",
  },
});


const apiService = {
  register: (data: RegisterRequest): Promise<AxiosResponse<RegisterResponse>> => 
  axiosClient.post("/register", data),
  
  
  
};


export default apiService;

