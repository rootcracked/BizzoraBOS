package realtime

import (
	"encoding/json"
	"log"
	"sync"
	"time"
	"gorm.io/gorm"
)



// Hub manages all WebSocket connections
type Hub struct {
	businessClients map[string]map[*Client]bool
	register        chan *Client
	unregister      chan *Client
	broadcast       chan *BroadcastMessage
	mutex           sync.RWMutex
	db              *gorm.DB
}

type BroadcastMessage struct {
	BusinessID string
	Data       []byte
}



// ============================================================
// ENHANCED REVENUE UPDATE WITH CHART DATA
// ============================================================

type DailyRevenueData struct {
	Date    string  `json:"date"`    // e.g., "2025-11-15"
	Revenue float64 `json:"revenue"` // Revenue for that day
	Sales   int     `json:"sales"`   // Number of sales that day
}

type RevenueUpdate struct {
	Type         string `json:"type"`
	BusinessID   string `json:"business_id"`
	TotalRevenue float64 `json:"total_revenue"`         // All-time total
	TotalExpense float64 `json:"total_expense"` 	
	
	SaleAmount   float64 `json:"sale_amount,omitempty"` // This specific sale
	TodayRevenue float64 `json:"today_revenue"`         // Today's total
	TodaySales   int `json:"today_sales"`           // Today's count
	DailyRevenue []DailyRevenueData `json:"daily_revenue"`         // Last 7 days for chart
	Timestamp    string `json:"timestamp"`
}

func NewHub(db *gorm.DB) *Hub {
	return &Hub{
		businessClients: make(map[string]map[*Client]bool),
		register:        make(chan *Client),
		unregister:      make(chan *Client),
		broadcast:       make(chan *BroadcastMessage, 256),
		db:              db,
	}
}

func (h *Hub) Run() {
	for {
		select {
		case client := <-h.register:
			h.mutex.Lock()
			if h.businessClients[client.businessID] == nil {
				h.businessClients[client.businessID] = make(map[*Client]bool)
			}
			h.businessClients[client.businessID][client] = true
			h.mutex.Unlock()
			log.Printf(" >:[SUCCESS]:< Client registered for business %s. Total: %d",
				client.businessID, len(h.businessClients[client.businessID]))

		case client := <-h.unregister:
			h.mutex.Lock()
			if clients, ok := h.businessClients[client.businessID]; ok {
				if _, exists := clients[client]; exists {
					delete(clients, client)
					close(client.send)
					log.Printf(">:[ERROR]:< Client unregistered from business %s. Remaining: %d",
						client.businessID, len(clients))

					if len(clients) == 0 {
						delete(h.businessClients, client.businessID)
					}
				}
			}
			h.mutex.Unlock()

		case message := <-h.broadcast:
			h.mutex.RLock()
			clients := h.businessClients[message.BusinessID]
			h.mutex.RUnlock()

			log.Printf(">:[SENDING...]::< Broadcasting to %d client(s) for business %s",
				len(clients), message.BusinessID)

			for client := range clients {
				select {
				case client.send <- message.Data:
					// Message sent successfully
				default:
					// Client's channel is full - disconnect them
					close(client.send)
					h.mutex.Lock()
					delete(h.businessClients[message.BusinessID], client)
					h.mutex.Unlock()
				}
			}
		}
	}
}

// ============================================================
// OLD METHOD - DEPRECATED (Keep for backward compatibility)
// ============================================================
func (h *Hub) BroadcastToBusinessClients(businessID string, revenue float64, saleAmount float64) {
	update := RevenueUpdate{
		Type:         "revenue_update",
		BusinessID:   businessID,
		TotalRevenue: revenue,
		SaleAmount:   saleAmount,
		Timestamp:    time.Now().Format(time.RFC3339),
	}

	data, err := json.Marshal(update)
	if err != nil {
		log.Printf("[ERROR] Error marshaling revenue update: %v", err)
		return
	}

	h.broadcast <- &BroadcastMessage{
		BusinessID: businessID,
		Data:       data,
	}

	log.Printf("[SUCCESS] Revenue update queued for business %s: $%.2f (sale: $%.2f)",
		businessID, revenue, saleAmount)
}




// ============================================================
// NEW METHOD - WITH COMPLETE CHART DATA
// ============================================================
func (h *Hub) BroadcastRevenueUpdate(
	businessID string,
	totalRevenue float64,
	totalExpense float64,
	
	saleAmount float64,
	todayRevenue float64,
	todaySales int,
	dailyRevenue []DailyRevenueData,
	
) {
	update := RevenueUpdate{
		Type:         "revenue_update",
		BusinessID:   businessID,
		TotalRevenue: totalRevenue,
		TotalExpense: totalExpense,
		
		SaleAmount:   saleAmount,
		TodayRevenue: todayRevenue,

		TodaySales:   todaySales,
		DailyRevenue: dailyRevenue,
		Timestamp:    time.Now().Format(time.RFC3339),
	}

	data, err := json.Marshal(update)
	if err != nil {
		log.Printf("Error marshaling revenue update: %v", err)
		return
	}

	h.broadcast <- &BroadcastMessage{
		BusinessID: businessID,
		Data:       data,
	}

	log.Printf(" Complete revenue update queued for business %s: Total=$%.2f, Today=$%.2f (%d sales), Sale=$%.2f expense=$%.2f ",
		businessID, totalRevenue, todayRevenue, todaySales, saleAmount, totalExpense, )
}
