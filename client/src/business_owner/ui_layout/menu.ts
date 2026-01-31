import { LayoutDashboard,Users,UserPlus,UserCog,Package,LogOut, PackagePlus, Settings } from "lucide-react";


export interface MenuItem {
  name:string;
  path?: string;
  icon : React.FC<{size?: number}>
  children?: MenuItem[]; 
}


export const menuItems: MenuItem[] = [
  { name: "Dashboard", path: "/admin-dashboard", icon: LayoutDashboard },
  {
    name: "Workers",
    icon: Users,
    children: [
      { name: "Add Worker", path: "/add-worker", icon: UserPlus },
      { name: "Manage Workers", path: "/manage-workers", icon: UserCog },
    ],
  },
  {
    name: "Products",
    icon: Package,
    children: [
      { name: "Add Product", path: "/add-product", icon: PackagePlus },
      { name: "Manage Products", path: "/manage-products", icon: Package },
    ],
  },
  
  { name: "Settings", path: "/settings", icon: Settings },
  ];
