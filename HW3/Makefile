WD = ~/Desktop/STA250/HW3
VW = ~/vowpal_wabbit/vowpalwabbit/vw

predict: train_model public_leaderboard.vw
	${VW} --loss_function logistic --oaa 5 -i train_model -t -d ${WD}/tmp/public_leaderboard.vw -r predictions.txt	
	python sigmoid.py predictions.txt prediction_result.txt
	
clean:
	rm -rf ${WD}/tmp/*
	rm -rf *.vw model

train-sample-processed.csv:
	python convert_csv.py ${WD}/data/train-sample.csv ${WD}/tmp/train-sample-processed.csv

public_leaderboard-processed.csv:
	python convert_csv.py ${WD}/data/public_leaderboard.csv ${WD}/tmp/public_leaderboard-processed.csv

train-sample.vw: train-sample-processed.csv
	python convert_vw.py ${WD}/tmp/train-sample-processed.csv ${WD}/tmp/train-sample.vw

public_leaderboard.vw: public_leaderboard-processed.csv
	python convert_vw.py ${WD}/tmp/public_leaderboard-processed.csv ${WD}/tmp/public_leaderboard.vw

train_model: train-sample.vw 
	${VW} --loss_function logistic --oaa 5 -d ${WD}/tmp/train-sample.vw -f train_model

