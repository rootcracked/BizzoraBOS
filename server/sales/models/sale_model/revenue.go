package salemodel

type DailyRevenue struct {
	Date    string  `json:"date"`
	Revenue float64 `json:"revenue"`
	Sales   int     `json:"sales"`
}


type AllSales struct {
	Sales string `json:"sales"`
}
