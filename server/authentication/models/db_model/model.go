package dbmodel

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Admin struct {
	ID            string `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
	Business_ID   string `gorm:"type:uuid;unique"`
	Business_Name string `gorm:"uniqueIndex;not null" `
	Username      string `gorm:"uniqueIndex;not null"`
	Email         string `gorm:"unique" `
	Password      string `gorm:"not null" `
	Role          string `gorm:"default:admin" `
}

// Auto-generate UUIDs before inserting
func (u *Admin) BeforeCreate(tx *gorm.DB) (err error) {
	if u.ID == "" {
		u.ID = uuid.New().String()
	}
	if u.Business_ID == "" {
		u.Business_ID = uuid.New().String()
	}
	return
}
