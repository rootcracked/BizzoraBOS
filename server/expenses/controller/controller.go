package controller

import (
	dbmodel "bizzora/authentication/models/db_model"
	expensemodel "bizzora/expenses/models/expensemodel"
	"bizzora/expenses/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ExpenseController struct {
	Service *service.ExpenseService
}

func NewexpenseController(service *service.ExpenseService) *ExpenseController {
	return &ExpenseController{Service: service}
}

func (e *ExpenseController) AddExpense(c *gin.Context) {

	//request
	var request expensemodel.Request

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// getting currentuser from middlware
	currentUser := c.MustGet("currentUser").(*dbmodel.Admin)

	expense, err := e.Service.AddExpense(request, currentUser)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, expense)
}
