package main

import(
	"net/http"
)

func main(){
	mux := http.NewServeMux()
	mux.HandleFunc("/healthCheck",health_check)
}

func health_check(w http.ResponseWriter, r *http.Request){
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"ok"}`))
}	