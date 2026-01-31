package models

import "time"

type Sale struct {
	ID          string    `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
	ProductID   string    `gorm:"type:uuid;not null"`
	productName string    `gorm:"not null"`
	WorkerID    string    `gorm:"not null"`
	WorkerName  string    `gorm:"not null"`
	BusinessID  string    `gorm:"not null"`
	Quantity    int       `gorm:"not null"`
	TotalPrice  float64   `gorm:"not null"`
	GrossProfit float64   `gorm:"not null"`
	CreatedAt   time.Time `gorm:"created_at"`
}
