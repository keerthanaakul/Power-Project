pipeline {
    
   agent  any
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/keerthanaakul/Power-Project.git'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
        
    }
}
