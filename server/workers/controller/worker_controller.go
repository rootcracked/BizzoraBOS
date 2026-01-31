package controller

import (
	adminmodel "bizzora/authentication/models/db_model"
	dbmodel "bizzora/authentication/models/db_model"

	"bizzora/workers/models/workermodels"
	"bizzora/workers/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

type WorkerController struct {
	WorkerService *service.WorkerService
}

func NewWorkerController(s *service.WorkerService) *WorkerController {
	return &WorkerController{s}
}

func (wc WorkerController) AddWorker(c *gin.Context) {
	//request from client
	var request workermodels.WorkerRequest

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	//get current user from middleware
	currentUser := c.MustGet("currentUser").(*adminmodel.Admin)

	worker, err := wc.WorkerService.AddWorker(request, *currentUser)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})

		return
	}

	c.JSON(http.StatusOK, worker)
}

func (wc WorkerController) Login(c *gin.Context) {
	var request workermodels.WorkerLogin

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"Error": err.Error()})
		return
	}

	worker, err := wc.WorkerService.Login(request)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"Error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, worker)

}

func (wc WorkerController) GetWorkers(c *gin.Context) {
	currentUser := c.MustGet("currentUser").(*dbmodel.Admin)

	workers, err := wc.WorkerService.GetWorkers(currentUser.Business_ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, workers)
}
