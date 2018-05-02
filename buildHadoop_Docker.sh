go get github.com/vistarmedia/gossamr
sudo docker pull sequenceiq/hadoop-docker:2.7.1
#migrate to project root
sudo docker cp ./wordcount $(sudo docker ps -q):/usr/local/hadoop/bin/wordcount
sudo docker cp words.txt $(sudo docker ps -q):words.txt
sudo docker cp Downloads/hadoop-streaming-2.7.1.jar $(sudo docker ps -q):/usr/local/hadoop/contrib/streaming/hadoop-streaming-2.7.1.jar
sudo docker run -it -p 8088:8088 sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
cd /usr/local/hadoop/bin
./hadoop fs -mkdir inputWords
./hadoop fs -copyFromLocal /words.txt inputWords/
cd /usr/local/hadoop
mkdir contrib
cd contrib
mkdir streaming
./hadoop jar /usr/local/hadoop/contrib/streaming/hadoop-streaming-2.7.1.jar -input inputWords -output outputDir -mapper "gossamr -task 0 -phase map" -reducer "gossamr -task 0 -phase reduce" -io typedbytes -file ./wordcount -numReduceTasks 6


#can now view the hadoop job on localhost:8088




