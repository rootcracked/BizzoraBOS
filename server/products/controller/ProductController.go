package controller

import (
	dbmodel "bizzora/authentication/models/db_model"
	productmodel "bizzora/products/models/product_model"
	"bizzora/products/services"
	workermodel "bizzora/workers/models/workermodels/db_model"
	
	"net/http"

	"github.com/gin-gonic/gin"
)

type ProductController struct {
	Service *services.ProductService
}

func NewProductController(service *services.ProductService) *ProductController {
	return &ProductController{Service: service}
}

// Handle product
func (pc *ProductController) AddProduct(c *gin.Context) {
	// request from frontend
	var request productmodel.Product_Request

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return 
	}

	//get current user from middleware
	currentUser := c.MustGet("currentUser").(*dbmodel.Admin)
 
	product, err := pc.Service.AddProduct(request, currentUser)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, product)
}

func (pc *ProductController) GetProducts(c *gin.Context) {
	currentUser := c.MustGet("currentUser")

	var businessID string

	// Detect user type
	switch u := currentUser.(type) {
	case *dbmodel.Admin:
		businessID = u.Business_ID
	case *workermodel.Worker:
		businessID = u.Business_ID
	default:
		c.JSON(http.StatusForbidden, gin.H{"error": "invalid user type"})
		return
	}

	products, err := pc.Service.GetProducts(businessID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, products)
}

