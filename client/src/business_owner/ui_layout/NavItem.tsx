import React, { FC, useState } from "react";
import { Link, useLocation } from "react-router-dom";

export interface MenuItem {
  name: string;
  path?: string;
  icon: FC<{ size?: number; className?: string }>;
  children?: MenuItem[];
}

interface NavItemProps {
  item: MenuItem;
  activeItem: string;
  setActiveItem: (key: string) => void;
}

export const NavItem: FC<NavItemProps> = ({ item, activeItem, setActiveItem }) => {
  const location = useLocation();
  const isActive = item.path === activeItem || location.pathname === item.path;
  const [open, setOpen] = useState(false);

  // Dropdown toggle
  const toggleDropdown = () => setOpen((prev) => !prev);

  // Dropdown item
  if (item.children) {
    return (
      <li>
        <button
          onClick={toggleDropdown}
          className={`flex justify-between items-center w-full px-4 py-2 rounded-lg text-sm font-medium font-inter transition ${
            isActive ? "bg-blue-50 text-blue-600 border-l-4 border-blue-500" : "text-gray-700 hover:bg-gray-100"
          }`}
        >
          <div className="flex items-center gap-3">
            <item.icon size={20} />
            <span>{item.name}</span>
          </div>
          <span>▼</span>
        </button>

        {open &&
          item.children.map((child) => (
            <Link
              key={child.path}
              to={child.path!}
              onClick={() => setActiveItem(child.path!)}
              className={`flex items-center gap-2 ml-6 px-4 py-2 rounded-lg  text-sm font-medium font-inter text-gray-600 hover:text-blue-600 hover:bg-gray-100 ${
                activeItem === child.path ? "bg-blue-50 text-blue-600" : ""
              }`}
            >
              <child.icon size={16} />
              <span>{child.name}</span>
            </Link>
          ))}
      </li>
    );
  }

  // Single link
  return (
    <li>
      <Link
        to={item.path!}
        onClick={() => setActiveItem(item.path!)}
        className={`flex items-center gap-3 px-4 py-2 rounded-lg font-inter text-sm font-medium transition ${
          isActive ? "bg-blue-50 text-blue-600 border-l-4 border-blue-500" : "text-gray-700 hover:bg-gray-100 hover:text-blue-600"
        }`}
      >
        <item.icon size={20} />
        <span>{item.name}</span>
      </Link>
    </li>
  );
};
