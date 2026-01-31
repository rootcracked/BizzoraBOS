import { useState } from "react";
import apiservice from "@/business_owner/ApiService/ApiService";
import { type ProductRequest, type ProductResponse } from "../model/product";


export default function useProduct(){
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>("");
  const [success, setSuccess] = useState<string>("");

  const addProduct = async (formData: ProductRequest): Promise<ProductResponse> => {

    setLoading(true);
    setError("");
    setSuccess("");

    try {
      const res = await apiservice.addproduct(formData);
      setSuccess("Product Added SuccessFully");
      console.log(res.data);

      return res.data;
    }catch(err:any){
      setError(err.response?.data?.error || "Failed to Add Product");
      throw err;
    }finally{
      setLoading(false);
    }
      
  };
  return {addProduct, success, loading, error};
}



