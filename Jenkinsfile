pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub_id'
        REPO_NAME = 'nuraybayrakdar/repo1'
        ACR_NAME = 'crnew'
        K8S_ID = 'K8S'
        registeryName = 'aksnew'
        registryCredential = 'ACR'
        registryUrl = 'https://crnew.azurecr.io'
        dockerImage = ''
        KUBE_URL = 'https://aksnew-dns-ogavmv7o.hcp.norwayeast.azmk8s.io'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nuraybayrakdar/website.git', credentialsId: 'GitHub-id'
            }
        }
        stage('Synk Code Scanning'){
            steps {
                script {
                    snykSecurity(
                        snykInstallation: 'synk@latest',
                        snykTokenId: 'SNYK_TOKEN'
                    )
                }
            }
        }
        stage('Docker Image Build') {
            steps {
                script {
                    docker.build("${REPO_NAME}:${BUILD_NUMBER}")
                    dockerImage = "${REPO_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage ('Verify Files') {
            steps {
                sh 'ls -l'
            }
        }
        stage('Docker Image Scan Trivy') {
            steps {
                script {
                    try {
                        def trivyOutput = sh(script: "trivy image ${dockerImage}", returnStdout: true).trim()
                        println trivyOutput
                        if (trivyOutput.contains("CRITICAL") || trivyOutput.contains("HIGH")) {
                            echo "Trivy found vulnerabilities but continuing the build."
                        } else {
                            echo "No vulnerabilities found"
                        }
                    } catch (Exception e) {
                        echo "Trivy scan failed: ${e.message}"
                    }
                }
            }
        }
        stage('Docker Image Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image("${dockerImage}").push('latest')
                    }
                    dockerImage = "${REPO_NAME}:${BUILD_NUMBER}"
                    sh "echo ${dockerImage}"
                }
            }
        }
        stage('Update Deployment YAML') {
            steps {
                script {
                    sh "sed -i 's|<image_placeholder>|${dockerImage}|g' deployment.yaml"
                    sh "cat deployment.yaml"
                }
            }
        }

        stage('Deploy K8S') {
            steps {
                script {
                    withCredentials([file(credentialsId: K8S_ID, variable: 'KUBECONFIG')]) {
                        sh 'kubectl config view --minify'
                        sh 'kubectl cluster-info'
                        sh 'kubectl apply -f deployment.yaml'
                    }
                }
            }
        }
    }
}
