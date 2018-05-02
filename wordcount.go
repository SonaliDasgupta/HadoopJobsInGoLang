package main

import (
	"github.com/vistarmedia/gossamr"
	"log"
	"strings"
)

type WordCount struct{}

func (wc *WordCount) Map(p int64, line string, c gossamr.Collector) error {
	for _, word := range strings.Fields(line) {
		c.Collect(strings.ToLower(word), int64(1))
	}
	return nil
}

func (w *WordCount) Reduce(word string, counts chan int64, c gossamr.Collector) error {
	var sum int64
	for v := range counts {
		sum += v
	}
	c.Collect(sum, word)
	log.Println("word: %v and count: %v", word, sum)

	return nil

}

func main() {
	wordCount := gossamr.NewTask(&WordCount{})

	err := gossamr.Run(wordCount)
	if err != nil {
		log.Fatal(err)
	}
}
