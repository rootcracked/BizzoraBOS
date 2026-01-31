package expensemodel

type Request struct {
	Name   string `json:"expense" binding:"required"`
	Amount int    `json:"amount" binding:"required"`
}

type Response struct {
	ID            string `json:"ID"`
	Business_ID   string `json:"Business_ID"`
	Business_Name string `json:"Business_Name"`
	Name          string `json:"Expense"`
	Amount        int    `json:"Amount"`
}
