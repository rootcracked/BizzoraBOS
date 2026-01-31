package dbmodel

import (
	"time"
)

type Businesses struct {
	ID        string `gorm:"primaryKey";type:uuid;`
	Name      string `gorm:"not null"`
	OwnerID   string `gorm:"not null"` // ties to user ID
	Owner     string `gorm:"not null"`
	CreatedAt time.Time
}
