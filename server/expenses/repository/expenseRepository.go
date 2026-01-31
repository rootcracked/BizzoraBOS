package repository

import (
	dbmodel "bizzora/expenses/models/db_model"

	"gorm.io/gorm"
)

type ExpenseRepository struct {
	DB *gorm.DB
}

func NewExpenseRepository(db *gorm.DB) *ExpenseRepository {
	return &ExpenseRepository{DB: db}
}

func (e *ExpenseRepository) CreateExpense(expense *dbmodel.Expense) error {
	return e.DB.Create(expense).Error
}

func (e *ExpenseRepository) GetExpensesbyBusiness(business_id string) ([]dbmodel.Expense, error) {
	var expenses []dbmodel.Expense
	if err := e.DB.Where("business_id = ?", business_id).Find(&expenses).Error; err != nil {
		return nil, err
	}

	return expenses, nil
}

func (e *ExpenseRepository) GetTotalExpenses(businessID string) (float64, error) {
	var totalRevenue float64

	err := e.DB.Model(&dbmodel.Expense{}).
		Where("business_id = ?", businessID).
		Select("COALESCE(SUM(amount), 0)").
		Scan(&totalRevenue).Error

	if err != nil {
		return 0, err
	}

	return totalRevenue, nil
}


