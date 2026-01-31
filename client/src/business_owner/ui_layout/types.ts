import type { FC } from "react";


export interface MenuItem {
  name: string;
  path?: string; // optional if item has children
  icon: FC<{ size?: number }>;
  children?: MenuItem[];
}

export interface UserType {
  username: string;
  email: string;
  business_name: string;
}
