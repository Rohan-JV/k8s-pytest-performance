pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
        DOCKER_IMAGE = 'pytest-perf:latest'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'which docker'  // For debugging, confirm Jenkins can see docker
                sh 'which minikube'  // For debugging, confirm Jenkins can see minikube
                sh 'eval $(minikube docker-env)'  // Make sure Jenkins talks to Minikube Docker
                sh 'docker build -t pytest-perf:latest .'
            }
        }

        stage('Create Parallel Jobs in Kubernetes') {
            steps {
                script {
                    def testFiles = ['test_performance_1.py', 'test_performance_2.py', 'test_performance_3.py']
                    for (int i = 0; i < testFiles.size(); i++) {
                        def testFile = testFiles[i]
                        def jobYaml = """
apiVersion: batch/v1
kind: Job
metadata:
  name: pytest-job-${i+1}
spec:
  template:
    spec:
      containers:
      - name: pytest-runner
        image: ${DOCKER_IMAGE}
        command: ["pytest", "tests/${testFile}"]
      restartPolicy: Never
"""
                        writeFile file: "job-${i+1}.yaml", text: jobYaml
                        sh "kubectl apply -f job-${i+1}.yaml"
                    }
                }
            }
        }

        stage('Collect Test Results') {
            steps {
                script {
                    sleep 10 // Give pods time to run
                    def pods = sh(script: "kubectl get pods -o=jsonpath='{.items[*].metadata.name}'", returnStdout: true).trim().split(" ")

                    for (pod in pods) {
                        if (pod.contains("pytest-job")) {
                            echo "==== Logs from $pod ===="
                            sh "kubectl logs ${pod}"
                        }
                    }
                }
            }
        }
    }
}
