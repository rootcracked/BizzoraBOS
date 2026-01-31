package main

import (
	dbmodel "bizzora/authentication/models/db_model"
	expensemodel "bizzora/expenses/models/db_model"
	productdb_model "bizzora/products/models/db_model"
	salesmodel "bizzora/sales/models/db_model"
	workermodel "bizzora/workers/models/workermodels/db_model"
	"log"
	"os"

	"github.com/joho/godotenv" // 👈 new import
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	// Load .env file into os.Environ
	if err := godotenv.Load(); err != nil {
		log.Println("⚠️ No .env file found, falling back to system env")
	}

	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		log.Fatal("❌ DATABASE_URL not set in .env or system env")
	}

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("[ERROR] Failed to connect to database:", err)
	}

	if err := db.AutoMigrate(&dbmodel.Admin{}); err != nil {
		log.Fatal("❌ Failed to migrate models:", err)
	}
	if err := db.AutoMigrate(&dbmodel.Businesses{}); err != nil {
		log.Fatal("Failed to migrate models: ", err)
	}
	if err := db.AutoMigrate(&productdb_model.Product{}); err != nil {
		log.Fatal("Failed to migrate models: ", err)
	}

	if err := db.AutoMigrate(&workermodel.Worker{}); err != nil {
		log.Fatal("Failed to migrate models:", err)
	}

	if err := db.AutoMigrate(&salesmodel.Sale{}); err != nil {
		log.Fatal("Failed to migrate models:", err)
	}

	if err := db.AutoMigrate(&expensemodel.Expense{}); err != nil {
		log.Fatal("Failed to migrate models:", err)
	}

	DB = db
	log.Println("✅ Database connected & migrated")
}
