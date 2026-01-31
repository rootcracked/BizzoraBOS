package main

import (
	repository "bizzora/authentication/Repository"
	"bizzora/authentication/controllers"
	"bizzora/authentication/middleware"
	"bizzora/authentication/services"
	bizzoramiddleware "bizzora/bizzora_middleware"
	pcontroller "bizzora/products/controller"
	prepository "bizzora/products/repository"
	pservice "bizzora/products/services"
	scontroller "bizzora/sales/controller"
	srepository "bizzora/sales/repository"
	s_service "bizzora/sales/services"
	wcontroller "bizzora/workers/controller"
	wrepository "bizzora/workers/repository"
	wservice "bizzora/workers/service"

	econtroller "bizzora/expenses/controller"
	erepository "bizzora/expenses/repository"
	eservice "bizzora/expenses/service"
	"bizzora/sales/realtime"

	"log"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load .env
	err := godotenv.Load()
	if err != nil {
		log.Println(" [~ERROR~] No .env file found")

	}

	// Connect DB
	InitDB()

	//configure hub and websocket
	hub := realtime.NewHub(DB)
	go hub.Run()
	log.Println("Hub started listening to incomings.... :")
	

	// Setup layers
	userRepo := repository.NewUserRepository(DB)
	BusinessRepo := repository.NewBusinessRepository(DB)
	ProductRepo := prepository.NewProductRepository(DB)
	workerRepo := wrepository.NewWorkerRepository(DB)
	salesRepo := srepository.NewSalesRepository(DB)
	expenseRepo := erepository.NewExpenseRepository(DB)

	authService := services.NewAuthService(userRepo, BusinessRepo)
	ProductService := pservice.NewProductService(ProductRepo)
	WorkerService := wservice.NewWorkerService(workerRepo)
	ExpenseService := eservice.NewexpenseService(expenseRepo)
	SalesService := s_service.NewSalesService(salesRepo, ProductRepo, expenseRepo, hub)

	authController := controllers.NewAuthController(authService)
	userController := controllers.NewUserController(userRepo)
	ProductController := pcontroller.NewProductController(ProductService)
	WorkerController := wcontroller.NewWorkerController(WorkerService)
	SaleController := scontroller.NewSaleController(SalesService)
	expenseController := econtroller.NewexpenseController(ExpenseService)
	

	// Gin router
	r := gin.Default()
	//Cors middleware setup
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,

		
	}))

	// Routes
	r.POST("/register", authController.Register)
	r.POST("/login", authController.Login)
	r.POST("/worker/login", WorkerController.Login)
	protected := r.Group("/users")
	protected.Use(middleware.AuthMiddleware(userRepo, workerRepo))
	protected.GET("/current", userController.GetCurrentUser)

	BizzoraService := protected.Group("/admin", bizzoramiddleware.BizzoraMiddleware())
	BizzoraService.POST("/add-product", ProductController.AddProduct)
	BizzoraService.GET("/get-products", ProductController.GetProducts)
	BizzoraService.GET("/ws/revenue", realtime.HandleWebSocket(hub, salesRepo, expenseRepo))
	
        :lls
        :q
        :

	BizzoraService.POST("/add-worker", WorkerController.AddWorker)
	BizzoraService.GET("/get-workers", WorkerController.GetWorkers)

	BizzoraService.POST("/sales", SaleController.SellProduct)
	BizzoraService.POST("/add-expenses", expenseController.AddExpense)
	



	

	for _, routes := range r.Routes() {
		log.Printf("Routes [~METHOD~] %s [~ROUTES~]  %s ", routes.Method, routes.Path )
	}

	// Start server
	r.Run("0.0.0.0:8080")

}
