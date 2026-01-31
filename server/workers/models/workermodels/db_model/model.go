package dbmodel

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Worker struct {
	ID            string `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
	Business_ID   string `gorm:"type:uuid"`
	Business_Name string `gorm:"not null" `
	Username      string `gorm:"not null"`
	Email         string `gorm:"unique" `
	PhoneNumber   string `gorm:"not null"`
	Password      string `gorm:"not null" `
	Role          string `gorm:"default:worker" `
}

// Auto-generate UUIDs before inserting
func (u *Worker) BeforeCreate(tx *gorm.DB) (err error) {
	if u.ID == "" {
		u.ID = uuid.New().String()
	}
	if u.Business_ID == "" {
		u.Business_ID = uuid.New().String()
	}
	return
}
