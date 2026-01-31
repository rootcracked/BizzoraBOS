package controller

import (
	dbmodel "bizzora/authentication/models/db_model"
	salemodel "bizzora/sales/models/sale_model"
	workermodel "bizzora/workers/models/workermodels/db_model"
	"bizzora/sales/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

type SaleController struct {
	Service *services.Sales_Service
}


func NewSaleController(service *services.Sales_Service) *SaleController {
	return &SaleController{Service: service}
} 

func (sc *SaleController) SellProduct(c *gin.Context) {
	var request salemodel.Sale_Request
	
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Something wrong somewhere"})
		return
	}

	//get currentuser
	currentUser := c.MustGet("currentUser")

	var sellerID, businessID, sellerName string

	switch u := currentUser.(type) {
		case *dbmodel.Admin:
			sellerID = u.ID
			businessID = u.Business_ID
			sellerName = u.Username

	case *workermodel.Worker:
		sellerID = u.ID
		businessID = u.Business_ID
		sellerName = u.Username

	default:
		c.JSON(http.StatusForbidden, gin.H{"error":"invalid user type"})
	return
	}

	sale,err := sc.Service.SellProduct(request, sellerID, businessID, sellerName)
	if err != nil{
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, sale)

}
