import React, { type FC } from "react";

const RevenueCard:FC = (number { revenue }) => {
  const finalRevenue  = revenue || 0;
  
  // Chart data from hook
  //const { daily } = UsechartData();

  
    
  

  return (
    <div className="relative w-full max-w-md p-4 rounded-xl h-[170px] w-[420px] bg-[#05070a] border border-[#1a1a1a] text-white overflow-hidden">
      {/* Header */}
      <div className="flex items-center justify-between mb-2">
        <h2 className="text-sm font-medium text-gray-300">Revenue</h2>
        
      </div>
          
      {/* Main Value */}
      <div className="mb-1">
        <p className="text-2xl font-bold text-[#fefeff] font-poppins">
          {finalRevenue}
        </p>
      </div>

      {/* Subtitle */}
      <p className="text-xs text-gray-500 mb-2">Last 30 days</p>

       
      
    </div>
  );
};

export default RevenueCard;

