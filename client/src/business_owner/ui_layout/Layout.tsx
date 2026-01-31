
import { FC, ReactNode } from "react";
import Sidebar from "./Sidebar";
import { Outlet } from "react-router-dom";

const Layout: FC = () => {
  return (
    <div className="flex h-screen bg-blue ">
      <Sidebar />
      <main className="flex-1 p-6 overflow-y-auto">
        <Outlet />
      </main>
    </div>
  );
};

export default Layout;
