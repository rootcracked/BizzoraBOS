package service

import (
	dbmodel "bizzora/authentication/models/db_model"
	expensedb "bizzora/expenses/models/db_model"
	expensemodel "bizzora/expenses/models/expensemodel"
	"bizzora/expenses/repository"

	"github.com/google/uuid"
)

type ExpenseService struct {
	expenseRepo *repository.ExpenseRepository
}

func NewexpenseService(expenseRepo *repository.ExpenseRepository) *ExpenseService {
	return &ExpenseService{expenseRepo: expenseRepo}
}

func (e *ExpenseService) AddExpense(req expensemodel.Request, currentOwner *dbmodel.Admin) (*expensemodel.Response, error) {

	expense := &expensedb.Expense{
		ID:            uuid.New().String(),
		Business_ID:   currentOwner.Business_ID,
		Business_Name: currentOwner.Business_Name,
		Name:          req.Name,
		Amount:        req.Amount,
	}

	if err := e.expenseRepo.CreateExpense(expense); err != nil {
		return nil, err
	}

	response := &expensemodel.Response{
		ID:            expense.ID,
		Business_ID:   expense.Business_ID,
		Business_Name: expense.Business_Name,
		Name:          expense.Name,
		Amount:        expense.Amount,
	}

	return response, nil
}


