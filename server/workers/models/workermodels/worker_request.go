package workermodels

type WorkerRequest struct {
	Username string `json:"username" binding:"required"`
	Phone    string `json:"phone_number" binding:"required"`
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type WorkerLogin struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type WorkerFull struct {
	ID            string `json:"ID"`
	Business_id   string `json:"business_id"`
	Business_name string `json:"business_name" binding:"required"`
	Username      string `json:"username"`
	Phone         string `json:"phone_number"`
	Email         string `json:"email" binding:"required,email"`
	Role          string `json:"role"`
}

type WorkerResponse struct {
	Token       string     `json:"token"`
	Worker_info WorkerFull `json:"user"`
}
