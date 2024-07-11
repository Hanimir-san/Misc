package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path"
	"runtime"
	"slices"
	"strings"

	"task-list/lib"
)

func main() {
	var cmdAdd *flag.FlagSet = flag.NewFlagSet("add", flag.ExitOnError)

	var addName *string = cmdAdd.String("task", "new task", "Name of a task to add.")
	// addPrio := cmdAdd.Int("prio", 1, "priority of a task to add.")

	flag.Parse()

	if !osIsSupported() {
		log.Fatalf("%s is not a supported operating system!", runtime.GOOS)
	}

	taskCache := getTaskCache()
	fmt.Println(*taskCache)

	if *addName != "" {
		addTask("", 1)
	}

}

func osIsSupported() bool {
	var osPrefix string = strings.Split(runtime.GOOS, "/")[0]
	return slices.Contains(lib.OsSupported[:], osPrefix)
}

func getTaskCache() *lib.TaskList {
	cache := &lib.TaskList{
		Tasks: []lib.Task{},
	}
	dirname, err := os.UserHomeDir()
	if err != nil {
		return cache
	}
	cachePath := path.Join(dirname, lib.CacheFileName)
	cacheExists, cacheErr := lib.PathExists(cachePath)
	lib.LogError(cacheErr, "Cannot verify cache path:")

	cacheBytes, err := json.Marshal(cache)
	if !cacheExists {
		err := os.WriteFile(cachePath, cacheBytes, 0660)
		lib.LogError(err, "Unable to write file:")
	} else {

	}
	return cache
}

func addTask(name string, prio int) {
	fmt.Println(name)
	fmt.Println(prio)

	// var date time.Time = time.Now()

}
