import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { toast } from "sonner";
import useProduct from "../hook/useProduct";
import {CheckCircle2, XCircle } from "lucide-react";

interface FormData {
  product_name: string;
  buying_price: number;
  selling_price: number;
  quantity: number;
}

export default function ProductForm() {
  const navigate = useNavigate();
  const {addProduct,success,loading,error} = useProduct();
  const [formData, setFormData] = useState<FormData>({
    product_name: "",
    buying_price: 0,
    selling_price: 0,
    quantity: 0,
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: name === "product_name" ?  value : Number(value) }));
  };

  const ProductSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.product_name || !formData.selling_price || !formData.buying_price || !formData.quantity){
      toast.error("Please Fill the form", {
        icon: <XCircle className="text-red-500" />,
      });
    }
    try {
      await addProduct(formData);
      toast.success("Produce Added SuccessFully", {
        description: success,
        icon: <CheckCircle2 className="text-green-500" />,
      });
    }catch {
      toast.error("Failed", {
        description: "Something went wrong",
        icon: <XCircle className="text-red-500" />,
      });
        
    }

    

  };

  return (

    <div className="flex justify-center items-center h-full w-full px-4 py-6">
      <div className="w-full max-w-2xl bg-white dark:bg-gray-800/50 rounded-2xl shadow-xl border border-border-light dark:border-border-dark p-8 flex flex-col gap-6"
           style={{ maxHeight: "calc(100vh - 4rem)" }}> {/* adjust maxHeight */}
        {/* Header */}
        <div className="text-center">
          <h1 className="text-3xl md:text-4xl font-extrabold text-text-light dark:text-text-dark">
            Add Product
          </h1>
          <p className="text-gray-500 dark:text-gray-400 mt-2 text-sm md:text-base">
            Enter the core details to add a new product to your inventory.
          </p>
        </div>

        <form className="flex flex-col gap-6" onSubmit={ProductSubmit}>
          {/* Product Name */}
          <label className="flex flex-col">
            <span className="text-text-light dark:text-text-dark text-sm font-semibold pb-1">
              Product Name
            </span>
            <input
              type="text"
              name="product_name" 
              placeholder="e.g., Enterprise Fusion Core"
              value={formData.product_name}
              onChange={handleChange}
              className="w-full rounded-xl border border-border-light dark:border-border-dark bg-white dark:bg-gray-800 h-12 px-4 text-sm focus:outline-none focus:ring-2 focus:ring-primary/40 transition"
            />
          </label>

          {/* Prices */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <label className="flex flex-col">
              <span className="text-text-light dark:text-text-dark text-sm font-semibold pb-1">
                Buying Price
              </span>
              <input
                type="number"
                name="buying_price"
                placeholder="0.00"
                value={formData.buying_price}
                onChange={handleChange}
                className="w-full rounded-xl border border-border-light dark:border-border-dark bg-white dark:bg-gray-800 h-12 px-4 text-sm focus:outline-none focus:ring-2 focus:ring-primary/40 transition"
              />
            </label>

            <label className="flex flex-col">
              <span className="text-text-light dark:text-text-dark text-sm font-semibold pb-1">
                Selling Price
              </span>
              <input
               type="number" 
                name="selling_price"
                placeholder="0.00"
                
                value={formData.selling_price}
                onChange={handleChange}
                className="w-full rounded-xl border border-border-light dark:border-border-dark bg-white dark:bg-gray-800 h-12 px-4 text-sm focus:outline-none focus:ring-2 focus:ring-primary/40 transition"
              />
            </label>
          </div>

          {/* Quantity */}
          <label className="flex flex-col md:w-1/3">
            <span className="text-text-light dark:text-text-dark text-sm font-semibold pb-1">
              Quantity
            </span>
            <input
              type="number"
              name="quantity"
              placeholder="0"
              value={formData.quantity}
              onChange={handleChange}
              className="w-full rounded-xl border border-border-light dark:border-border-dark bg-white dark:bg-gray-500 h-12 px-4 text-sm focus:outline-none focus:ring-2 focus:ring-primary/40 transition"
            />
          </label>

          {/* Buttons */}
          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              className="px-6 py-2 rounded-xl   border border-primary text-dark dark:text-white hover:bg-red-500 dark:hover:bg-white/10 transition"
              onClick={() => {navigate("/admin-dashboard")}}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-6 py-2 rounded-xl bg-blue-600 text-white shadow-md duration-300 transition"
            >
              {loading ? "Adding Product" : "Add Product"} 
            </button>
          </div>
        </form>
      </div>
    </div>
   

  );


}  


