import axios,{type AxiosResponse} from 'axios'
import { type ProductRequest, type ProductResponse } from '../pages/product/model/product'


const token = localStorage.getItem("token");

const axiosClient = axios.create({
  baseURL: "http://localhost:8080",
  headers: {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${token}`
  },
  
});


const apiservice = {
  addproduct: (data: ProductRequest): Promise<AxiosResponse<ProductResponse>> => 
    axiosClient.post("/users/admin/add-products", data),
  
}

export default apiservice;
