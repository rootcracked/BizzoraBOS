
export interface RegisterRequest {
  username: string;
  email: string;
  business_name:string;
  password: string;
}



 
export interface RegisterResponse {
  token: string;

  user: {
  id: string;
  business_id: string;
  business_name: string;
  username: string;
  email: string;
  role: string;
  }
}


export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;

  user: {
  id: string;
  business_id: string;
  business_name: string;
  username: string;
  email: string;
  role: string;
  }
}
  

