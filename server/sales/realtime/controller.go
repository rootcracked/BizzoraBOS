package realtime

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	dbmodel "bizzora/authentication/models/db_model"
	erepository "bizzora/expenses/repository" // ADD THIS
	salemodel "bizzora/sales/models/sale_model"
	srepository "bizzora/sales/repository" // ADD THIS
	workermodel "bizzora/workers/models/workermodels/db_model"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"

)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true // TODO  Restrict in production
	},
}

// HandleWebSocket now takes repositories as parameters
func HandleWebSocket(
	hub *Hub,
	salesRepo *srepository.SalesRepository,     // ADD THIS
	expenseRepo *erepository.ExpenseRepository, // ADD THIS
) gin.HandlerFunc {
	return func(c *gin.Context) {
		// ============================================================
		// STEP 1: GET AUTHENTICATED USER
		// ============================================================
		currentUser := c.MustGet("currentUser")
		var businessID string

		switch u := currentUser.(type) {
		case *dbmodel.Admin:
			businessID = u.Business_ID
		case *workermodel.Worker:
			businessID = u.Business_ID
		default:
			c.JSON(http.StatusForbidden, gin.H{"error": "invalid user type"})
			return
		}

		// ============================================================
		// STEP 2: UPGRADE HTTP TO WEBSOCKET
		// ============================================================
		conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
		if err != nil {
			log.Printf(" ~[ERROR]~ WebSocket upgrade error: %v", err)
			return
		}

		// ============================================================
		// STEP 3: CREATE CLIENT
		// ============================================================
		client := &Client{
			hub:        hub,
			conn:       conn,
			send:       make(chan []byte, 256),
			businessID: businessID,
		}

		// ============================================================
		// STEP 4: REGISTER WITH HUB
		// ============================================================
		client.hub.register <- client

		// ============================================================
		// STEP 5: SEND INITIAL COMPLETE DATA (Using Repositories!)
		// ============================================================
		go func() {
			// Get revenue data (from repository)
			totalRevenue, err := salesRepo.GetTotalRevenue(businessID)
			if err != nil {
				log.Printf("❌ Error fetching total revenue: %v", err)
				totalRevenue = 0
			}

			todayRevenue, todaySales, err := salesRepo.GetTodayRevenue(businessID)
			if err != nil {
				log.Printf("❌ Error fetching today revenue: %v", err)
				todayRevenue = 0
				todaySales = 0
			}

			dailyRevenueData, err := salesRepo.GetDailyRevenue(businessID, 7)
			if err != nil {
				log.Printf("❌ Error fetching daily revenue: %v", err)
				dailyRevenueData = []salemodel.DailyRevenue{}
			}

			// Get expense data (from repository)
			totalExpenses, err := expenseRepo.GetTotalExpenses(businessID)
			if err != nil {
				log.Printf("❌ Error fetching total expenses: %v", err)
				totalExpenses = 0
			}

			


			// Convert to Hub format
			var dailyRevenue []DailyRevenueData
			for _, dr := range dailyRevenueData {
				dailyRevenue = append(dailyRevenue, DailyRevenueData{
					Date:    dr.Date,
					Revenue: dr.Revenue,
					Sales:   dr.Sales,
				})
			}



			

			

			// Create complete initial message
			initialUpdate := RevenueUpdate{
				Type:          "initial_data",
				BusinessID:    businessID,
				TotalRevenue:  totalRevenue,
				TodayRevenue:  todayRevenue,
				TodaySales:    todaySales,
				DailyRevenue:  dailyRevenue,
				TotalExpense: totalExpenses,
				
				Timestamp:     time.Now().Format(time.RFC3339),
			}

			data, _ := json.Marshal(initialUpdate)
			client.send <- data

			log.Printf("📊 Sent initial data: Revenue=$%.2f, Expenses=$%.2f,",
				totalRevenue, totalExpenses)
		}()

		// ============================================================
		// STEP 6: START CLIENT GOROUTINES
		// ============================================================
		go client.writePump()
		go client.readPump()
	}
}


