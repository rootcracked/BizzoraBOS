package productdb_model

type Product struct {
	ID            string `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
	Business_ID   string `gorm:"type:uuid;not null"`
	Business_Name string `gorm:"not null"`
	Owner         string `gorm:"not null"`
	Name          string `gorm:"not null"`
	Buying_Price  int    `gorm:"not null"`
	Selling_Price int    `gorm:"not null"`
	Gross_Profit  int    `gorm:"not null"`
	Quantity      int    `gorm:"not null"`
}
