pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform fmt & validate') {
            steps {
                bat '''
                    terraform --version
                    terraform fmt -check || terraform fmt
                    terraform validate || exit 0
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Terraform',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat '''
                        setx AWS_ACCESS_KEY_ID %AWS_ACCESS_KEY_ID%
                        setx AWS_SECRET_ACCESS_KEY %AWS_SECRET_ACCESS_KEY%
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Terraform',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat '''
                        setx AWS_ACCESS_KEY_ID %AWS_ACCESS_KEY_ID%
                        setx AWS_SECRET_ACCESS_KEY %AWS_SECRET_ACCESS_KEY%
                        terraform plan -out=tfplan -input=false
                        terraform show -no-color tfplan > plan.txt
                    '''
                }
                archiveArtifacts artifacts: 'plan.txt', fingerprint: true
            }
        }

        stage('Manual Approval') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Apply"
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Terraform',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat '''
                        setx AWS_ACCESS_KEY_ID %AWS_ACCESS_KEY_ID%
                        setx AWS_SECRET_ACCESS_KEY %AWS_SECRET_ACCESS_KEY%
                        terraform apply -auto-approve -input=false tfplan
                    '''
                }
            }
        }
    }

    post {
        always {
            bat 'terraform workspace show || exit 0'
        }
    }
}
