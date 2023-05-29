install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	python -m pytest -vv --cov=cli --cov=mlib --cov=utilscli --cov=app test_mlib.py

format:
	black *.py

lint:
	pylint --disable=R,C,W1203,E1101 mlib cli utilscli
	#lint Dockerfile
	#docker run --rm -i hadolint/hadolint < Dockerfile

deploy:
	#push to ECR for deploy
	aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 234130974935.dkr.ecr.us-east-2.amazonaws.com/pythonmlops
	docker build -t mlops .
	docker tag pythonmlops:latest 234130974935.dkr.ecr.us-east-2.amazonaws.com/pythonmlops:latest
	docker push 234130974935.dkr.ecr.us-east-2.amazonaws.com/pythonmlops:latest
	
all: install lint test format deploy
