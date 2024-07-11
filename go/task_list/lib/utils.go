package lib

import (
	"log"
	"os"
)

type TaskList struct {
	Tasks []Task
}

type Task struct {
	Name     string
	Priority int
}

func PathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

func LogError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s %s", msg, err)
	}
}
