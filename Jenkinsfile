pipeline{
    agent any
    stages{
        stage("test"){
            steps{
                echo "HELLO GO"
            }
        }
        stage("Build Image"){
            steps{
                script{
                    sh 'docker build -t harbor.jinguang.cn:8443/hello_jenkins:v1 -f Dockerfile .'
                }
            }
        }
    }
}