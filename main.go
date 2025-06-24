package main

import (
	"fmt"
	"log"
	"net/http"
)

func pingHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	fmt.Println("handled ping request")

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("pong"))
}

func main() {
	http.HandleFunc("/api/ping", pingHandler)

	log.Println("Server started on :8080")
	for {
		err := http.ListenAndServe(":8080", nil)
		if err != nil {
			log.Printf("Server error: %v. Restarting...", err)
		}
	}
}
