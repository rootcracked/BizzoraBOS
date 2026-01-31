package repository

import (
	models "bizzora/sales/models/db_model"
	salemodel "bizzora/sales/models/sale_model"
	"time"

	"gorm.io/gorm"
)

type SalesRepository struct {
	DB *gorm.DB
}

func NewSalesRepository(db *gorm.DB) *SalesRepository {
	return &SalesRepository{DB: db}
}

func (r *SalesRepository) CreateSale(sale *models.Sale) error {
	return r.DB.Create(sale).Error
}

func (r *SalesRepository) GetSalesByWorker(workerID string) ([]models.Sale, error) {
	var sales []models.Sale
	err := r.DB.Where("worker_id = ?", workerID).Find(&sales).Error
	return sales, err
}

func (r *SalesRepository) GetSalesbyBusiness(businessID string) ([]models.Sale, error) {
	var sales []models.Sale
	err := r.DB.Where("business_id = ? ", businessID).Find(&sales).Error
	return sales,err
}

func (r *SalesRepository) GetRevenue(businessID string) (models.Sale, error) {
	var revenue models.Sale
	err := r.DB.Where("total_price = ? ", businessID).Find(&revenue).Error
	return revenue, err
}

func (r *SalesRepository) GetTotalRevenue(businessID string) (float64, error) {
	var totalRevenue float64

	err := r.DB.Model(&models.Sale{}).
		Where("business_id = ?", businessID).
		Select("COALESCE(SUM(total_price), 0)").
		Scan(&totalRevenue).Error

	if err != nil {
		return 0, err
	}

	return totalRevenue, nil
}

func (r *SalesRepository) GetTotalGross(businessID string) (float64, error) {
	var totalGross float64

	err := r.DB.Model(&models.Sale{}).
		Where("business_id = ?", businessID).
		Select("COALESCE(SUM(gross_profit), 0)").
		Scan(&totalGross).Error

	if err != nil {
		return 0, err
	}

	return totalGross, nil
}

func (r *SalesRepository) GetDailyRevenue(businessID string, days int) ([]salemodel.DailyRevenue, error) {
	var dailyRevenue []salemodel.DailyRevenue

	endDate := time.Now()
	startDate := endDate.AddDate(0, 0, -days)

	err := r.DB.Model(&models.Sale{}).
		Select("DATE(created_at) as date, COALESCE(SUM(total_price), 0) as revenue, COUNT(*) as sales").
		Where("business_id = ? AND created_at >= ? AND created_at <= ?", businessID, startDate, endDate).
		Group("DATE(created_at)").
		Order("date ASC").
		Scan(&dailyRevenue).Error

	return dailyRevenue, err
}

func (r *SalesRepository) GetTodayRevenue(businessID string) (float64, int, error) {
	var revenue float64
	var salesCount int64

	today := time.Now().Format("2006-01-02")

	err := r.DB.Model(&models.Sale{}).
		Where("business_id = ? AND DATE(created_at) = ?", businessID, today).
		Select("COALESCE(SUM(total_price), 0)").
		Scan(&revenue).Error

	if err != nil {
		return 0, 0, err
	}

	r.DB.Model(&models.Sale{}).
		Where("business_id = ? AND DATE(created_at) = ?", businessID, today).
		Count(&salesCount)

	return revenue, int(salesCount), nil
}
