package dbmodel

type Expense struct {
	ID            string `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
	Business_ID   string `gorm:"type:uuid;not null"`
	Business_Name string `gorm:"not null"`
	Name          string `gorm:"not null"`
	Amount int `gorm:"not null"`
	
}
