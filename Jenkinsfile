pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
   agent  any
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/keerthanaakul/Power-Project.git'
            }
        }
        stage('Terraform init') {
            steps {
                bat 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                bat 'terraform apply --auto-approve'
            }
        }
        
    }
}
