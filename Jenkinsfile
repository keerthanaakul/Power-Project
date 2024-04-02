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
                sh 'C:\Users\keerthana.a\Desktop\Power\terraform'
                sh 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'C:\Users\keerthana.a\Desktop\Power\terraform'
                sh 'terraform apply --auto-approve'
            }
        }
        
    }
}

