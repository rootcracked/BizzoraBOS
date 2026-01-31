package services

import (
	erepository "bizzora/expenses/repository"
	prepository "bizzora/products/repository"
	dbmodel "bizzora/sales/models/db_model"
	salemodel "bizzora/sales/models/sale_model"
	"bizzora/sales/realtime"
	srepository "bizzora/sales/repository"
	"errors"
	"log"
	"time"

	"github.com/google/uuid"
)

type Sales_Service struct {
	SalesRepo   *srepository.SalesRepository
	ProductRepo *prepository.ProductRepository
	ExpenseRepo *erepository.ExpenseRepository
	Hub         *realtime.Hub // WebSocket Hub
}

func NewSalesService(
	salesRepo *srepository.SalesRepository,
	productRepo *prepository.ProductRepository,
	expensePrepo *erepository.ExpenseRepository,
	hub *realtime.Hub,
) *Sales_Service {
	return &Sales_Service{
		SalesRepo:   salesRepo,
		ProductRepo: productRepo,
		ExpenseRepo: expensePrepo,
		Hub:         hub,
	}
}

func (s *Sales_Service) SellProduct(req salemodel.Sale_Request, SellerID string, businessID string, SellerName string) (*salemodel.Sale_Response, error) {
	// ============================================================
	// STEP 1: VALIDATE
	// ============================================================
	if req.Quantity <= 0 {
		return nil, errors.New("MUST BE GREATER")
	}

	// ============================================================
	// STEP 2: GET PRODUCT
	// ============================================================
	product, err := s.ProductRepo.GetProductbyID(req.Product_id)
	if err != nil {
		return nil, errors.New("product not found")
	}

	// ============================================================
	// STEP 3: CHECK OWNERSHIP
	// ============================================================
	if product.Business_ID != businessID {
		return nil, errors.New("product not for this business")
	}

	// ============================================================
	// STEP 4: CHECK STOCK
	// ============================================================
	if product.Quantity < req.Quantity {
		return nil, errors.New("not enough stock")
	}

	// ============================================================
	// STEP 5: CREATE SALE OBJECT
	// ============================================================
	totalprice := product.Selling_Price * (req.Quantity)
	grossprofit := product.Buying_Price * (req.Quantity)
	profit := totalprice - grossprofit
	sales := &dbmodel.Sale{
		ID:          uuid.New().String(),
		ProductID:   req.Product_id,
		BusinessID:  businessID,
		WorkerID:    SellerID,
		WorkerName:  SellerName,
		Quantity:    req.Quantity,
		TotalPrice:  float64(totalprice),
		GrossProfit: float64(profit),
		CreatedAt:   time.Now(),
	}

	// ============================================================
	// STEP 6: SAVE SALE TO DATABASE
	// ============================================================
	if err := s.SalesRepo.CreateSale(sales); err != nil {
		return nil, err
	}

	// ============================================================
	// STEP 7: UPDATE PRODUCT STOCK
	// ============================================================
	product.Quantity -= req.Quantity
	if err := s.ProductRepo.UpdateProduct(*product); err != nil {
		return nil, err
	}

	// ============================================================
	// STEP 8: BROADCAST REAL-TIME UPDATE WITH CHART DATA
	// Teaching: This runs in background (doesn't block HTTP response)
	// ============================================================
	go func() {
		// Get total revenue (all-time)
		totalRevenue, err := s.SalesRepo.GetTotalRevenue(businessID)
		if err != nil {
			log.Printf("⚠️ Failed to get total revenue: %v", err)
			return
		}

		

		totalExpenses, err := s.ExpenseRepo.GetTotalExpenses(businessID)
		if err != nil {
			log.Printf("Failed to get total profit : %v", err)
			return 
		}

		// Get today's revenue and count
		todayRevenue, todaySales, err := s.SalesRepo.GetTodayRevenue(businessID)
		if err != nil {
			log.Printf("⚠️ Failed to get today revenue: %v", err)
			return
		}

		// Get last 7 days for chart
		dailyRevenueData, err := s.SalesRepo.GetDailyRevenue(businessID, 7)
		if err != nil {
			log.Printf("⚠️ Failed to get daily revenue: %v", err)
			return
		}

		// Convert repository format to Hub format
		// Teaching: Different packages use different structs,
		// so we need to convert between them
		var dailyRevenue []realtime.DailyRevenueData
		for _, dr := range dailyRevenueData {
			dailyRevenue = append(dailyRevenue, realtime.DailyRevenueData{
				Date:    dr.Date,
				Revenue: dr.Revenue,
				Sales:   dr.Sales,
			})
		}

		// Broadcast everything to all connected dashboards
		s.Hub.BroadcastRevenueUpdate(
			businessID,
			totalRevenue,     // All-time total
			sales.TotalPrice,// This specific sale
			totalExpenses,
			
			todayRevenue,     // Today's total
			todaySales,       // Today's count
			dailyRevenue,     // Last 7 days array
		)

		log.Printf("📊 Broadcasted revenue update: Total=$%.2f, Today=$%.2f (%d sales)",
			totalRevenue, todayRevenue, todaySales)
	}()
	// ============================================================

	// ============================================================
	// STEP 9: RETURN HTTP RESPONSE (Immediately!)
	// ============================================================
	return &salemodel.Sale_Response{
		Message:    "SuccessFull Sale",
		SellerName: sales.WorkerName,
	}, nil
}
