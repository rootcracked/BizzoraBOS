
import React, { FC, useState, useEffect } from "react";
import { NavItem } from "./NavItem";
import { menuItems } from "./menu";
import type { UserType } from "./types";
import { User } from "lucide-react";
import axios from "axios";
import BizzoraLogo from "../assets/bizzoralogo.png"

const Sidebar: FC = () => {
  const [user, setUser] = useState<null>(null);
  const [activeItem, setActiveItem] = useState("/dashboard");

 useEffect(() => {
    const token = localStorage.getItem("token");
    if (!token) return;

    axios.get("http://localhost:8080/users/current", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
 // only if your backend needs cookies
      })
      .then((res) => {
      console.log("Current user data:", res.data); // check structure
      setUser(res.data.user);
    })
     .catch((err) => console.log("Error fetching user:", err));
  }, []);
    return (
    <aside className="w-60 h-screen flex flex-col border-r rounded-xl border-gray-200 bg-white shadow-lg">

      {/* Header */}
      <div className=" p-6 border rounded-xl mr-2 ml-2 mt-2 border-blue-200 ">
        <div className="flex items-center gap-3">
        <div className="w-10 h-10 bg-black-500 rounded-lg flex items-center justify-center text-white font-bold">
          <img className="w-10 h-10" src={BizzoraLogo}/>
        </div>
        <div className="flex flex-col">
          <span className="font-bold font-inter text-gray-800 truncate"> {user?.business_name || "Admin Panel"} </span>
          
        </div>
        </div>
      
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-2 overflow-y-auto space-y-3 mt-2">
        {menuItems.map((item) => (
          <NavItem
            key={item.name}
            item={item}
            activeItem={activeItem}
            setActiveItem={setActiveItem}
          />
        ))}
      </nav>

      {/* Footer */}
      <div className="p-4 border  mb-2 ml-2 mr-2 border-gray-200 rounded-xl">
         <div className="flex flex-col">
           <span className="text-sm font-inter text-gray-600 truncate">Owner: {user?.username || "Owner Name"}</span>
          <span className="font-bold font-inter text-gray-800 truncate text-sm">Email: {user?.email || "Owner Email"} </span>
                       </div>
      </div>
    </aside>
  );
};

export default Sidebar;
