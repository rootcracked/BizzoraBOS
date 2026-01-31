import { useState } from "react";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import useLogin from "../hooks/login"; 
import { CheckCircle2, XCircle } from "lucide-react";
import { useNavigate } from "react-router-dom";

import BizzoraImage from "../assets/bizzoralogo.png"
import { Input } from "@/components/ui/input";

interface FormData {
  email: string;
  password: string;

}



export default function LoginForm() {

  const navigate = useNavigate()
  const { login, loading, error, success } = useLogin();
  const [formData, setFormData] = useState<FormData>({
    email: "",
    password: "",
    
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await login(formData);
      toast.success("Registration Successful 🎉", {
        description: success || "Welcome to SaaS Inc.!",
        icon: <CheckCircle2 className="text-green-500" />,
      });
      navigate("/admin-dashboard")
      
    } catch {
      toast.error("Registration Failed ⚠️", {
        description: error || "Please check your details and try again.",
        icon: <XCircle className="text-red-500" />,
      });
      
    }
  };

  return (
    <div className="flex min-h-screen w-full bg-background-light dark:bg-background-dark font-display ">
      {/* Left Side */}
      <div className="hidden lg:flex w-6/12 flex-col justify-between bg-primary p-8 rounded-r-3xl ">
        <div className="flex items-center gap-3">
          <span className="material-symbols-outlined text-white "><img className="w-10 h-10" src={BizzoraImage}/></span>
          <p className="text-white text-xl font-bold ">Bizzora Inc.</p>
        </div>
        <div className="mt-6 space-y-3">
          <h1 className="text-white text-3xl md:text-4xl font-bold leading-tight">
            Chude Your Business
          </h1>
        <h1 className="text-white text-3xl md:text-4xl font-bold leading-tight" >With BOS</h1>
          <p className="text-white/80 text-sm md:text-base">
            Unlock unparalleled efficiency and drive growth with our intuitive platform.
          </p>
        </div>
        <div className="text-white/60 text-xs mt-6">© 2024 SaaS Inc. All rights reserved.</div>
      </div>

      {/* Right Side */}
      <div className="flex-1 flex items-center justify-center p-6 sm:p-8">
        <div className="max-w-sm w-full">
          <div className="flex flex-col gap-5">
            {/* Header */}
            <div className="text-center lg:text-left space-y-1">
              <p className="text-[#111418] dark:text-white text-2xl md:text-3xl font-extrabold leading-tight ">
                Welcome Back 
              </p>
              <p className="text-text-light dark:text-gray-300 text-sm md:text-base">
                  change your business to a real time working partner
              </p>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="flex flex-col gap-3">
              {/** Email */}
              <label className="flex flex-col">
                <span className="text-[#111418] dark:text-white text-sm font-medium pb-1">Email</span>
                <Input
                  type="email"
                  name="email"
                  placeholder="Enter your corporate email"
                  value={formData.email}
                  onChange={handleChange}
                  className="h-10 w-[400px] rounded-lg border border-border-light dark:border-gray-700 bg-white dark:bg-background-dark text-[#111418] dark:text-white placeholder:text-text-light/70 p-2 text-sm focus:outline-none focus:ring-2 focus:ring-secondary/50 transition"
                />
              </label>

             

              {/** Password */}
              <label className="flex flex-col">
                <span className="text-[#111418] dark:text-white text-sm font-medium pb-1">Password</span>
                <Input
                  type="password"
                  name="password"
                  placeholder="Enter your password"
                  value={formData.password}
                  onChange={handleChange}
                  className="h-10 w-[400px] rounded-lg border border-border-light dark:border-gray-700 bg-white dark:bg-background-dark text-[#111418] dark:text-white placeholder:text-text-light/70 p-2 text-sm  focus:ring-2 focus:ring-2 focus:ring-secondary/50 transition"
                />
              </label>

              
              {/** Submit */}
              <Button
                type="submit"
                disabled={loading}
                className="bg-primary text-white font-bold py-2 rounded-lg hover:bg-primary/90 transition-colors duration-300 w-full text-sm"
              >
                {loading ? "Registering..." : "Create Account"}
              </Button>
            </form>

            {/* Footer */}
            <div className="text-center text-text-light dark:text-gray-400 text-xs mt-2">
              <p>
                By creating an account, you agree to our{" "}
                <a className="text-secondary hover:underline" href="#">Terms of Service</a> and{" "}
                <a className="text-secondary hover:underline" href="#">Privacy Policy</a>.
              </p>
              <p className="mt-1">
                Already have an account?{" "}
                <a className="text-secondary font-semibold hover:underline" href="#">Log in</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

